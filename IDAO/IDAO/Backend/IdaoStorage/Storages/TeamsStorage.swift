//
//  TeamsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class TeamsStorage: BaseStorage<Int> {
    
    private var teamsIds: [Int] = []
    private var teamsCache: [Int: Team] = [:]
    
    override func update(completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            IdaoManager.shared.getMyTeamsIds { [weak self] myTeams in
                self?.set(myTeams) {
                    completionHandler()
                }
            }
        }
    }
    
    func get(teamId: Int, completionHandler: @escaping (Team) -> ()) {
        self.queue.sync() {
            if let team = teamsCache[teamId] {
                completionHandler(team)
            } else {
                var retTeam = Team(id: -1, name: "", status: "NONEXISTS", registrationDate: Date(), teamMembers: nil)
                let mainGroup = DispatchGroup()
                mainGroup.enter()
                IdaoManager.shared.getTeam(byId: teamId) { team in
                    retTeam = team
                    mainGroup.enter()
                    IdaoManager.shared.getTeamMembers(teamId: teamId) { teamMembers in
                        retTeam.teamMembers = teamMembers
                        mainGroup.leave()
                    }
                    mainGroup.leave()
                }
                mainGroup.wait()
                self.queue.async(flags: .barrier) {
                    self.teamsCache[teamId] = retTeam
                }
                completionHandler(retTeam)
            }
        }
    }
}

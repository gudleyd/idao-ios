//
//  TeamsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class TeamsStorage: BaseStorage<Int> {
    
    private var teamsCache: [Int: (Team, Double)] = [:]
    private let teamsCacheTrustInterval: Double = 15 // in seconds
    
    override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            if forceUpdate {
                self.teamsCache = [:]
            }
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            IdaoManager.shared.getMyTeamsIds { [weak self] myTeams in
                self?.items = myTeams
                mainGroup.leave()
            }
            mainGroup.wait()
            self.notify()
            completionHandler()
        }
    }
    
    func getAllTeams(filter: @escaping (Team) -> (Bool), completionHandler: @escaping ([Team]) -> ()) {
        self.queue.sync {
            var teams = [Team]()
            for id in self.items {
                self.get(teamId: id) { team in
                    if (filter(team)) {
                        teams.append(team)
                    }
                }
            }
            completionHandler(teams)
        }
    }
    
    func get(teamId: Int, completionHandler: @escaping (Team) -> ()) {
        self.queue.sync() {
            if let team = teamsCache[teamId] {
                if Date().timeIntervalSince1970 - team.1 < teamsCacheTrustInterval {
                    completionHandler(team.0)
                    return
                }
            }
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
            self.teamsCache[teamId] = (retTeam, Date().timeIntervalSince1970)
            completionHandler(retTeam)
        }
    }
}

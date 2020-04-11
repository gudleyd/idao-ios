//
//  TeamsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class TeamsStorage: BaseStorage<Team> {
    
    override func update(completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            var teams: [Team] = []
            IdaoManager.shared.getMyTeams { myTeams in
                teams = myTeams
                let mainGroup = DispatchGroup()
                for i in 0..<teams.count {
                    mainGroup.enter()
                    IdaoManager.shared.getTeamMembers(teamId: teams[i].id) { members in
                        teams[i].teamMembers = members
                        mainGroup.leave()
                    }
                }
                self.queue.async {
                    mainGroup.wait()
                    self.set(teams) {
                        completionHandler()
                    }
                }
            }
        }
    }
    
    func get(byId: Int, withMembers: Bool = false, completionHandler: @escaping (Team) -> ()) {
        self.queue.sync() {
            let team = self.items.first { team in return team.id == byId }
            if let team = team {
                completionHandler(team)
            } else {
                IdaoManager.shared.getTeam(byId: byId) { team in
                    var teamMutable = team
                    if withMembers {
                        IdaoManager.shared.getTeamMembers(teamId: byId) { members in
                            teamMutable.teamMembers = members
                            completionHandler(teamMutable)
                        }
                    } else {
                        completionHandler(teamMutable)
                    }
                }
            }
        }
    }
}

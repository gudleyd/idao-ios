//
//  IdaoStorage-Teams.swift
//  IDAO
//
//  Created by Ivan Lebedev on 04.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoStorage {
    
    func updateTeams(completionHandler: @escaping () -> ()) {
        self.teamsQueue.async(flags: .barrier) {
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
                self.teamsQueue.async {
                    mainGroup.wait()
                    self.setTeams(teams: teams) {
                        completionHandler()
                    }
                }
            }
        }
    }
    
    func getTeam(byId: Int, withMembers: Bool = false, completionHandler: @escaping (Team) -> ()) {
        self.teamsQueue.sync() {
            let team = self.teamsArray.first { team in return team.id == byId }
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

    func getTeams(completionHandler: @escaping ([Team]) -> ()) {
        self.teamsQueue.sync() {
            completionHandler(self.teamsArray)
        }
    }

    func setTeams(teams: [Team], completionHandler: @escaping () -> ()) {
        self.teamsQueue.async(flags: .barrier) {
            self.teamsArray = teams
            self.teamsTableDelegate?.setTeams(teams: self.teamsArray)
            self.teamsTableDelegate?.reloadTable()
            completionHandler()
        }
    }
}

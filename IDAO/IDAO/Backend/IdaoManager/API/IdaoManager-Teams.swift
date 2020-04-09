//
//  IdaoManager-Teams.swift
//  IDAO
//
//  Created by Ivan Lebedev on 08.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


enum TeamCreationStatus {
    case teamAlreadyExists
    case created
    case unknownError
}

extension IdaoManager {

    func getTeamMembers(teamId: Int, completionHandler: @escaping ([Team.TeamMember]) -> ()) {

        let request = self.baseRequest(mapping: "/api/teams/\(teamId)/users")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let members = try! self.getJsonDecoder().decode([Team.TeamMember].self, from: data)
            completionHandler(members)
        }
        task.resume()
    }
    
    func getTeam(byId: Int, completionHandler: @escaping (Team) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/teams/\(byId)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let team = try! self.getJsonDecoder().decode(Team.self, from: data)
            completionHandler(team)
        }
        task.resume()
    }
    
    func getMyTeams(completionHandler: @escaping ([Team]) -> ()) {
        
        self.getTeamMembers(teamId: 1010, completionHandler: {_ in })

        let request = self.baseRequest(mapping: "/api/teams/my")

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let teams = try! self.getJsonDecoder().decode([Team].self, from: data)
            completionHandler(teams)
        }
        task.resume()
    }
    
    func getMyInvites(completionHandler: @escaping ([Int]) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/teams/my/invites")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let invites = try! self.getJsonDecoder().decode([Int].self, from: data)
            completionHandler(invites)
        }
        task.resume()
    }
    
    func createTeam(name: String, completionHandler: @escaping (TeamCreationStatus, Team?) -> ()) {
        
        var request = self.baseRequest(mapping: "/api/teams/")
        
        let body: [String: Any] = ["name": name]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 400 {
                completionHandler(.teamAlreadyExists, nil)
            } else if response.statusCode == 200 {
                completionHandler(.created, try? self.getJsonDecoder().decode(Team.self, from: data))
            } else {
                completionHandler(.unknownError, nil)
            }
        }
        task.resume()
    }
}

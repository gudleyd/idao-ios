//
//  IdaoManager-Invites.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


enum UserInviteStatus: Int {
    case sent = 200
    case userNotFound = 404
    case cannotAddMember = 400
    case unknownError
}


extension IdaoManager {
    
    func inviteUser(teamId: Int, userId: Int, completionHandler: @escaping (UserInviteStatus) -> ()) {
        var request = self.baseRequest(mapping: "/api/teams/\(teamId)/invites/\(userId)")
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                completionHandler(.unknownError)
                return
            }
            guard let _ = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            if let status = UserInviteStatus(rawValue: response.statusCode) {
                completionHandler(status)
            } else {
                completionHandler(.unknownError)
            }
        }
        task.resume()
    }
    
    func declineInvite(teamId: Int, completionHandler: @escaping () -> ()) {
        
        guard let userId = self.myUserId() else { return }
        
        var request = self.baseRequest(mapping: "/api/teams/\(teamId)/invites/\(userId)")
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            completionHandler()
        }
        task.resume()
    }
    
    func acceptInvite(teamId: Int, completionHandler: @escaping () -> ()) {
        
        guard let userId = self.myUserId() else { return }
        
        var request = self.baseRequest(mapping: "/api/teams/\(teamId)/invites/\(userId)")
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            completionHandler()
        }
        task.resume()
    }
}

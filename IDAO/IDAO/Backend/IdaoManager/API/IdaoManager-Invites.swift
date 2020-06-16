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
            if let _ = data,
                let response = response as? HTTPURLResponse {
                
                if let status = UserInviteStatus(rawValue: response.statusCode) {
                    completionHandler(status)
                } else {
                    completionHandler(.unknownError)
                }
            } else {
                completionHandler(.unknownError)
            }
        }
        task.resume()
    }
    
    func declineInvite(teamId: Int, completionHandler: @escaping (SimpleRequestResult) -> ()) {
        
        guard let userId = self.myUserId() else {
            completionHandler(.unknownError)
            return
        }
        
        var request = self.baseRequest(mapping: "/api/teams/\(teamId)/invites/\(userId)")
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                completionHandler(.unknownError)
            } else {
                completionHandler(.success)
            }
        }
        task.resume()
    }
    
    func acceptInvite(teamId: Int, completionHandler: @escaping (SimpleRequestResult) -> ()) {
        
        guard let userId = self.myUserId() else {
            completionHandler(.unknownError)
            return
        }
        
        var request = self.baseRequest(mapping: "/api/teams/\(teamId)/invites/\(userId)")
        request.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                completionHandler(.unknownError)
            } else {
                completionHandler(.success)
            }
        }
        task.resume()
    }
}

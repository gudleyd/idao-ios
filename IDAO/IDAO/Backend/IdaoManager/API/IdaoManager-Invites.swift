//
//  IdaoManager-Invites.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoManager {
    
    func inviteUser(teamId: Int, userId: Int, completionHandler: @escaping () -> ()) {
        var request = self.baseRequest(mapping: "/api/teams/\(teamId)/invites/\(userId)")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            completionHandler()
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

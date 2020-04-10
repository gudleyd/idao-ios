//
//  IdaoManager-Invites.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoManager {
    
    func declineInvite(teamId: Int, completionHandler: @escaping () -> ()) {
        
        var request = self.baseRequest(mapping: "/api/teams/invites/decline/\(teamId)")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            completionHandler()
        }
        task.resume()
    }
    
    func acceptInvite(teamId: Int, completionHandler: @escaping () -> ()) {
        
        var request = self.baseRequest(mapping: "/api/teams/invites/accept/\(teamId)")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            completionHandler()
        }
        task.resume()
    }
}

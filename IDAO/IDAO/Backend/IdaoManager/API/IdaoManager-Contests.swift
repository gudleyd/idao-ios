//
//  IdaoManager-Contests.swift
//  IDAO
//
//  Created by Ivan Lebedev on 16.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

extension IdaoManager {
    
    func getPublishedContests(completionHandler: @escaping (SimpleRequestStatus, [Contest]) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/contests/status/CLOSED")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let contests = try? self.getJsonDecoder().decode([Contest].self, from: data) {
                
                completionHandler(.success, contests)
            } else {
                completionHandler(.unknownError, [])
            }
        }
        task.resume()
    }
    
    func getContestSettings(id: Int, completionHandler: @escaping (SimpleRequestStatus, Contest.Settings?) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/contests/\(id)/settings")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let settings = try? self.getJsonDecoder().decode(Contest.Settings.self, from: data) {
                
                completionHandler(.success, settings)
            } else {
                completionHandler(.unknownError, nil)
            }
        }
        task.resume()
    }
    
    func getContestStages(id: Int, completionHandler: @escaping (SimpleRequestStatus, [Contest.Stage]) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/contests/\(id)/stages")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let stages = try? self.getJsonDecoder().decode([Contest.Stage].self, from: data) {
                
                completionHandler(.success, stages)
            } else {
                completionHandler(.unknownError, [])
            }
        }
        task.resume()
    }
    
    enum ContestRegistrationStatus {
        case success
        case registrationClosed
        case notFound
        case detailed(details: String)
        case unknownError
    }
    
    func registerForContest(contestId: Int, teamId: Int, completionHandler: @escaping (ContestRegistrationStatus) -> ()) {
        
        var request = self.baseRequest(mapping: "/api/contests/\(contestId)/teams/teamId")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let response = response as? HTTPURLResponse {
                
                if response.statusCode / 100 == 2 {
                    completionHandler(.success)
                } else if response.statusCode == 400 {
                    completionHandler(.registrationClosed)
                } else if response.statusCode == 404 {
                    completionHandler(.notFound)
                } else if let details = getDetails(data: data) {
                    completionHandler(.detailed(details: details))
                } else {
                    completionHandler(.unknownError)
                }
            } else {
                completionHandler(.unknownError)
            }
        }
        task.resume()
    }
}

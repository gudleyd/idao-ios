//
//  IdaoManager-Contests.swift
//  IDAO
//
//  Created by Ivan Lebedev on 16.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

extension IdaoManager {
    
    func getPublishedContests(completionHandler: @escaping (SimpleRequestResult, [Contest]) -> ()) {
        
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
    
    func getContestSettings(id: Int, completionHandler: @escaping (SimpleRequestResult, Contest.Settings?) -> ()) {
        
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
    
    func getContestStages(id: Int, completionHandler: @escaping (SimpleRequestResult, [Contest.Stage]) -> ()) {
        
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
        case unknownError
    }
    
    func registerForContest(contestId: Int, teamId: Int, completionHandler: @escaping (ContestRegistrationStatus) -> ()) {
        
        var request = self.baseRequest(mapping: "/api/contests/\(contestId)/teams/teamId")
        request.httpMethod = "POST"
        
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

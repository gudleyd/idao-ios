//
//  IdaoManager-Contests.swift
//  IDAO
//
//  Created by Ivan Lebedev on 16.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

extension IdaoManager {
    
    func getPublishedContests(completionHandler: @escaping ([Contest]) -> ()) {
        let request = self.baseRequest(mapping: "/api/contests/status/OPENED")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let contests = try! self.getJsonDecoder().decode([Contest].self, from: data)
            completionHandler(contests)
        }
        task.resume()
    }
    
    func getContestSettings(id: Int, completionHandler: @escaping (Contest.Settings) -> ()) {
        let request = self.baseRequest(mapping: "/api/contests/\(id)/settings")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let settings = try! self.getJsonDecoder().decode(Contest.Settings.self, from: data)
            completionHandler(settings)
        }
        task.resume()
    }
    
    func getContestStages(id: Int, completionHandler: @escaping ([Contest.Stage]) -> ()) {
        let request = self.baseRequest(mapping: "/api/contests/\(id)/stages")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let stages = try! self.getJsonDecoder().decode([Contest.Stage].self, from: data)
            completionHandler(stages)
        }
        task.resume()
    }
}

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
        let request = self.baseRequest(mapping: "/api/contests/published/")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let contests = try! self.getJsonDecoder().decode([Contest].self, from: data)
            completionHandler(contests)
        }
        task.resume()
    }
    
    func getContestSettings(id: Int, completionHandler: @escaping ([Contest.Settings]) -> ()) {
        let request = self.baseRequest(mapping: "/api/contests/settings/\(id)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}

//
//  IdaoManager-Api.swift
//  IDAO
//
//  Created by Ivan Lebedev on 04.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoManager {
    
    func getJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    
    func baseRequest(mapping: String) -> URLRequest {
        var request = URLRequest(url: URL(string: self.baseUrl + mapping)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(self.jwtoken)", forHTTPHeaderField: "Authorization")

        return request
    }
    
    func getMyAccount(completionHandler: @escaping (User) -> ()) {

        let request = self.baseRequest(mapping: "/api/users/me")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let user = try! self.getJsonDecoder().decode(User.self, from: data)
            print(user.account.id)
            completionHandler(user)
        }
        task.resume()
    }
    
    func getAllUsers(completionHandler: @escaping ([User.Account]) -> ()) {

        let request = self.baseRequest(mapping: "/api/users/")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let users = try! self.getJsonDecoder().decode([User.Account].self, from: data)
            print(users)
        }
        task.resume()
    }
}

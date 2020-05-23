//
//  IdaoManager-Api.swift
//  IDAO
//
//  Created by Ivan Lebedev on 04.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation
import KeychainSwift


extension IdaoManager {
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    func getJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(self.getDateFormatter())
        
        return decoder
    }
    
    func baseRequest(mapping: String) -> URLRequest {
        var request = URLRequest(url: URL(string: self.baseUrl + mapping)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(self.apptoken)", forHTTPHeaderField: "App-Token")
        if let token = self.token {
            request.addValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    // This method is sync by design
    func auth(username: String, password: String) {
        
        let group = DispatchGroup()
        
        var request = self.baseRequest(mapping: "/api/auth/login")
        
        let body: [String: Any] = ["username": username, "password": password]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            self.token = try? self.getJsonDecoder().decode(Token.self, from: data)
            group.leave()
        }
        task.resume()
        group.wait()
        if let token = self.token {
            let keychain = KeychainSwift()
            keychain.set(token.accessToken, forKey: "accessToken")
            keychain.set(token.tokenType, forKey: "tokenType")
        }
    }
    
    func getUserAccount(userId: Int, completionHandler: @escaping (User.Account) -> ()) {
        print("KEK")
        let request = self.baseRequest(mapping: "/api/accounts/\(userId)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let account = try! self.getJsonDecoder().decode(User.Account.self, from: data)
            print(account)
            completionHandler(account)
        }
        task.resume()
    }
    
    func getUserPersonalData(userId: Int, completionHandler: @escaping (User.PersonalData) -> ()) {
        let request = self.baseRequest(mapping: "/api/personal-data/\(userId)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let personalData = try! self.getJsonDecoder().decode(User.PersonalData.self, from: data)
            print(personalData)
            completionHandler(personalData)
        }
        task.resume()
    }
}

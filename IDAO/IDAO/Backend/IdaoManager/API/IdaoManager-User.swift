//
//  IdaoManager-User.swift
//  IDAO
//
//  Created by Ivan Lebedev on 12.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation
import KeychainSwift

extension IdaoManager {
    
    enum RegistrationStatus: Int {
        case success = 200
        case inUse = 400
        case unknownError
    }
    
    func register(userData: UserWithPasswordAndData?) -> RegistrationStatus {
        
        let group = DispatchGroup()
        
        var request = self.baseRequest(mapping: "/api/auth/register")
        
        guard let data = try? self.getJsonEncoder().encode(userData) else { return .unknownError }
        request.httpMethod = "POST"
        request.httpBody = data
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            group.leave()
        }
        task.resume()
        group.wait()
        return .success
    }
    
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
            keychain.set(username, forKey: "username")
            keychain.set(password, forKey: "password")
            
            let dec = decode(jwtToken: token.accessToken)
            self.appUserId = dec["id"] as? Int
        }
    }
    
    func changeUserPersonalData(userData: UserWithPasswordAndData?) -> RegistrationStatus {
        
        guard let id = self.myUserId() else { return .unknownError }
        
        let group = DispatchGroup()
        
        var request = self.baseRequest(mapping: "/api/personal-data/\(id)")
        guard let data = try? self.getJsonEncoder().encode(userData) else { return .unknownError }
        request.httpMethod = "PUT"
        request.httpBody = data
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            print("status: \(String(data: data, encoding: .utf8)!), code: \(response.statusCode)")
            group.leave()
        }
        task.resume()
        group.wait()
        
        IdaoStorage.appUser.update { }
        return .success
    }
    
    func getUserAccount(userId: Int, completionHandler: @escaping (User.Account) -> ()) {
        print("userId: \(userId)")
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
    
    func getUsers(completionHandler: @escaping ([User.Account]) -> ()) {
        let request = self.baseRequest(mapping: "/api/accounts/")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let users = try! self.getJsonDecoder().decode([User.Account].self, from: data)
            completionHandler(users)
        }
        task.resume()
    }
    
    func getUsers(username: String, completionHandler: @escaping ([User.Account]) -> ()) {
        self.getUsers { users in
            let user = users.filter { account in
                return (account.username.hasPrefix(username))
            }
            completionHandler(user)
        }
    }
}

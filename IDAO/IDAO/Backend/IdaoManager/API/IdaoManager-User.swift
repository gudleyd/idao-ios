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
    
    enum RegistrationStatus {
        case success
        case inUse(details: String)
        case unknownError
    }
    
    func register(userData: UserWithPasswordAndData?) -> RegistrationStatus {
        
        var currentStatus = RegistrationStatus.unknownError
        
        guard let userData = userData else { return currentStatus }
        
        let json = "{\"account\": {\"name\":\"\(userData.name)\", \"username\":\"\(userData.username)\"},\"password\":\"\(userData.password)\", \"personalData\": {\"levelOfStudy\":\"\(userData.levelOfStudy)\",\"phoneNumber\":\"\(userData.phoneNumber)\",\"countryOfResidence\":\"\(userData.countryOfResidence)\",\"company\":\"\(userData.company)\",\"university\":\"\(userData.university)\",\"birthday\":\"\(self.getDateFormatter().string(from: userData.birthday))\",\"studyProgram\":\"\(userData.studyProgram)\",\"email\":\"\(userData.email)\",\"gender\":\"\(userData.gender)\"}}"
        
        let group = DispatchGroup()
        
        var request = self.baseRequest(mapping: "/api/auth/register")
        
        guard let data = json.data(using: .utf8) else { return currentStatus }
        request.httpMethod = "POST"
        request.httpBody = data
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                group.leave()
                return
            }
            guard let response = response as? HTTPURLResponse else {
                group.leave()
                return
            }
            print(response.statusCode)
            if response.statusCode == 200 {
                currentStatus = .success
            } else if response.statusCode < 500 {
                if let data = data,
                    let details =  ((try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any])?["details"] as? String {
                        currentStatus = .inUse(details: details)
                }
            }
            group.leave()
        }
        task.resume()
        group.wait()
        return currentStatus
    }
    
    func auth(username: String, password: String) {
        
        let group = DispatchGroup()
        
        var request = self.baseRequest(mapping: "/api/auth/login")
        
        let body: [String: Any] = ["username": username, "password": password]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print("No internet connection")
            }
            guard let data = data else { return }
            self.token = try? self.getJsonDecoder().decode(Token.self, from: data)
            group.leave()
        }
        task.resume()
        group.wait()
        if let token = self.token {
            let keychain = KeychainSwift()
            keychain.set(username, forKey: "username")
            keychain.set(password, forKey: "password")
            
            let dec = decode(jwtToken: token.accessToken)
            self.appUserId = dec["id"] as? Int
            
            IdaoStorage.shared.updateOnInvalidState()
        }
    }
    
    func changeUserPersonalData(userData: User.PersonalData) {
        
        guard let id = self.myUserId() else { return }
        
        let group = DispatchGroup()
        
        var request = self.baseRequest(mapping: "/api/personal-data/\(id)")
        guard let data = try? self.getJsonEncoder().encode(userData) else { return }
        request.httpMethod = "PUT"
        request.httpBody = data
        
        group.enter()
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            group.leave()
        }
        task.resume()
        group.wait()
        
        IdaoStorage.appUser.update { }
    }
    
    func getUserAccount(userId: Int, completionHandler: @escaping (User.Account) -> ()) {
        let request = self.baseRequest(mapping: "/api/accounts/\(userId)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let account = try! self.getJsonDecoder().decode(User.Account.self, from: data)
            completionHandler(account)
        }
        task.resume()
    }
    
    func getUserPersonalData(userId: Int, completionHandler: @escaping (User.PersonalData) -> ()) {
        let request = self.baseRequest(mapping: "/api/personal-data/\(userId)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let personalData = try! self.getJsonDecoder().decode(User.PersonalData.self, from: data)
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

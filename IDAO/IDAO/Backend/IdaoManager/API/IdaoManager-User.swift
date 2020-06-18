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
    
    func register(userData: UserWithPasswordAndData?, completionHandler: @escaping (RegistrationStatus) -> ()) {
        
        guard let userData = userData else {
            completionHandler(.unknownError)
            return
        }
        
        let json = "{\"account\": {\"name\":\"\(userData.name)\", \"username\":\"\(userData.username)\"},\"password\":\"\(userData.password)\", \"personalData\": {\"levelOfStudy\":\"\(userData.levelOfStudy)\",\"phoneNumber\":\"\(userData.phoneNumber)\",\"countryOfResidence\":\"\(userData.countryOfResidence)\",\"company\":\"\(userData.company)\",\"university\":\"\(userData.university)\",\"birthday\":\"\(self.getDateFormatter().string(from: userData.birthday))\",\"studyProgram\":\"\(userData.studyProgram)\",\"email\":\"\(userData.email)\",\"gender\":\"\(userData.gender)\"}}"
        
        guard let data = json.data(using: .utf8) else {
            completionHandler(.unknownError)
            return
        }
        

        var request = self.baseRequest(mapping: "/api/auth/register")
        
        request.httpMethod = "POST"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    completionHandler(.success)
                } else if response.statusCode < 500 {
                    if let data = data,
                        let details = ((try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any])?["details"] as? String {
                            completionHandler(.inUse(details: details))
                    }
                } else {
                    completionHandler(.unknownError)
                }
            } else {
                completionHandler(.unknownError)
            }
            
        }
        task.resume()
    }
    
    enum AuthStatus {
        case success
        case unknownError
    }
    
    func auth(username: String, password: String, completionHandler: @escaping (AuthStatus) -> ()) {
        
        var request = self.baseRequest(mapping: "/api/auth/login")
        
        let body: [String: Any] = ["username": username, "password": password]
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let token = try? self.getJsonDecoder().decode(Token.self, from: data) {
                
                self.token = token
                let keychain = KeychainSwift()
                keychain.set(username, forKey: "username")
                keychain.set(password, forKey: "password")
                
                let dec = decode(jwtToken: token.accessToken)
                self.appUserId = dec["id"] as? Int
                
                IdaoStorage.shared.updateOnInvalidState()
                
                completionHandler(.success)
            } else {
                completionHandler(.unknownError)
            }
        }
        task.resume()
    }
    
    func changeUserPersonalData(userData: User.PersonalData, completionHandler: @escaping (SimpleRequestStatus) -> ()) {
        
        guard let id = self.myUserId() else {
            completionHandler(.unknownError)
            return
        }
        
        var request = self.baseRequest(mapping: "/api/personal-data/\(id)")
        guard let data = try? self.getJsonEncoder().encode(userData) else {
            completionHandler(.unknownError)
            return
        }
        request.httpMethod = "PUT"
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                completionHandler(.unknownError)
            } else {
                if let _ = data,
                    let _ = response as? HTTPURLResponse {
                    
                    completionHandler(.success)
                }
            }
        }
        task.resume()
    }

    func getUserAccount(userId: Int, completionHandler: @escaping (SimpleRequestStatus, User.Account?) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/accounts/\(userId)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let account = try? self.getJsonDecoder().decode(User.Account.self, from: data) {
                
                completionHandler(.success, account)
            } else {
                completionHandler(.unknownError, nil)
            }
        }
        task.resume()
    }
    
    func getUserPersonalData(userId: Int, completionHandler: @escaping (SimpleRequestStatus, User.PersonalData?) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/personal-data/\(userId)")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let personalData = try? self.getJsonDecoder().decode(User.PersonalData.self, from: data) {
                
                completionHandler(.success, personalData)
            } else {
                completionHandler(.unknownError, nil)
            }
        }
        task.resume()
    }
    
    func getUsers(completionHandler: @escaping (SimpleRequestStatus, [User.Account]) -> ()) {
        let request = self.baseRequest(mapping: "/api/accounts/")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let users = try? self.getJsonDecoder().decode([User.Account].self, from: data) {
                
                completionHandler(.success, users)
            } else {
                completionHandler(.unknownError, [])
            }
        }
        task.resume()
    }
    
    func getUsers(username: String, completionHandler: @escaping ([User.Account]) -> ()) {
        self.getUsers { status, users in
            let user = users.filter { account in
                return (account.username == username)
            }
            completionHandler(user)
        }
    }
}

//
//  IdaoManager.swift
//  IDAO
//
//  Created by Ivan Lebedev on 30.03.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation
import KeychainSwift


class IdaoManager {

    static let shared: IdaoManager = IdaoManager()

    internal var baseUrl: String = "https://api.idao.world"
    internal var apptoken: String = "sJ6-Pz7ufOpkZzppLbGOqE8lUS5YuWXhkNLudL1pWS4="
    internal var token: Token?
    
    internal var appUserId: Int?
    

    private init() {
        let keychain = KeychainSwift()
        if let password = keychain.get("password"),
            let username = keychain.get("username") {
            self.auth(username: username, password: password)
        }
    }
    
    func logOut() {
        let keychain = KeychainSwift()
        keychain.delete("password")
        keychain.delete("username")
        
        token = nil
        appUserId = nil
    }
    
    func myUserId() -> Int? {
        return self.appUserId
    }
    
    func isAuthorized() -> Bool {
        return self.token != nil
    }
}

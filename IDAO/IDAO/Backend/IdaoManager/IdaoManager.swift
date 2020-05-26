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
    internal var jwtExpirationDate: Date = Date()
    
    private var appUserId: Int?
    

    private init() {
        let keychain = KeychainSwift()
        if let accessToken = keychain.get("accessToken"),
            let tokenType = keychain.get("tokenType") {
            self.token = Token(accessToken: accessToken, tokenType: tokenType)
        
            let dec = decode(jwtToken: self.token?.accessToken ?? "")
            self.appUserId = dec["id"] as? Int
        }
    }
    
    func myUserId() -> Int? {
        return self.appUserId
    }
    
    func isAuthorized() -> Bool {
        return self.token != nil
    }
}

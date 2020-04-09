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
    internal var jwtoken: String = ""
    internal var jwtExpirationDate: Date = Date()

    internal var idaoStorage = IdaoStorage()

    private init() {
        let keychain = KeychainSwift()
        if let token = keychain.get("jwtoken"),
            let expDateString = keychain.get("jwtExpirationDate") {
            self.jwtoken = token
            self.jwtExpirationDate = Date(timeIntervalSince1970: TimeInterval(Int(expDateString)! / 1000))
        }
    }
    
    func setTeamsTableDelegate(delegate: TeamsTableDelegate) {
        self.idaoStorage.teamsTableDelegate = delegate
    }
}

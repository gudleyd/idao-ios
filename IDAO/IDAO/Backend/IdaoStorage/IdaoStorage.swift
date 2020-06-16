//
//  TeamsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 04.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

class IdaoStorage {
    
    static let shared: IdaoStorage = IdaoStorage()
    
    private var isValid: Bool = true
    
    static private(set) var news = NewsStorage(makeUpdate: false)
    static private(set) var teams = TeamsStorage(makeUpdate: false)
    static private(set) var invites = InvitesStorage(makeUpdate: false)
    static private(set) var contests = ContestsStorage(makeUpdate: false)
    static private(set) var appUser = AppUserStorage(makeUpdate: false)
    static private(set) var accounts = UserAccountsStorage(makeUpdate: false)
    
    private init() { }
    
    func invalidate() {
        self.isValid = false
    }
    
    func updateOnInvalidState() {
        if !self.isValid {
            IdaoStorage.news.update { }
            IdaoStorage.teams.update { }
            IdaoStorage.invites.update { }
            IdaoStorage.contests.update { }
            IdaoStorage.appUser.update { }
            IdaoStorage.accounts.update { }
        }
    }
}


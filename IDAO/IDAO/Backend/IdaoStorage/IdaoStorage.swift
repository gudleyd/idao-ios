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
    
    static private(set) var news: INewsStorage = NewsStorage(makeUpdate: false)
    static private(set) var teams: ITeamsStorage = TeamsStorage(makeUpdate: false)
    static private(set) var invites: IInvitesStorage = InvitesStorage(makeUpdate: false)
    static private(set) var contests: IContestsStorage = ContestsStorage(makeUpdate: false)
    static private(set) var appUser: IAppUserStorage = AppUserStorage(makeUpdate: false)
    static private(set) var accounts: IUserAccountsStorage = UserAccountsStorage(makeUpdate: false)
    
    private init() { }
    
    func invalidate() {
        self.isValid = false
    }
    
    func updateOnInvalidState() {
        if !self.isValid {
            IdaoStorage.news = NewsStorage(makeUpdate: true)
            IdaoStorage.teams = TeamsStorage(makeUpdate: true)
            IdaoStorage.invites = InvitesStorage(makeUpdate: true)
            IdaoStorage.contests = ContestsStorage(makeUpdate: true)
            IdaoStorage.appUser = AppUserStorage(makeUpdate: true)
            IdaoStorage.accounts = UserAccountsStorage(makeUpdate: true)
        }
    }
    
    func setTestData() {
        IdaoManager.shared.setTestData()
        IdaoStorage.news = TestNewsStorage()
        IdaoStorage.teams = TestTeamsStorage()
        IdaoStorage.invites = TestInvitesStorage()
        IdaoStorage.contests = TestContestsStorage()
        IdaoStorage.appUser = TestAppUserStorage()
        IdaoStorage.accounts = TestUserAccountsStorage()
    }
}


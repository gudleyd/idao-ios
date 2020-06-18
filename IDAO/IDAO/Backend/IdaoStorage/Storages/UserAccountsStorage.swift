//
//  UsersStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 19.05.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class IUserAccountsStorage: BaseStorage<Int> {
    
    func get(userId: Int, completionHandler: ((User.Account) -> ())) { }
}


class UserAccountsStorage: IUserAccountsStorage {
    
    internal var accountsCache = [Int: (User.Account, Double)]()
    internal let accountsCacheTrustInterval: Double = 300 // in seconds
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        if self.isUpdating {
            return
        }
        self.queue.async(flags: .barrier) {
            self.isUpdating = true
            if forceUpdate {
                self.accountsCache = [:]
            }
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            IdaoManager.shared.getUsers { status, users in
                for user in users {
                    self.accountsCache[user.id] = (user, Date().timeIntervalSince1970)
                }
                mainGroup.leave()
            }
            mainGroup.wait()
            self.notify()
            self.isUpdating = false
            self.queue.async {
                completionHandler()
            }
        }
    }
    
    final override func get(userId: Int, completionHandler: ((User.Account) -> ())) {
        self.queue.sync() {
            if let account = accountsCache[userId] {
                if Date().timeIntervalSince1970 - account.1 < accountsCacheTrustInterval {
                    completionHandler(account.0)
                    return
                }
            }
            var retAccount = User.Account(id: -1, name: "NONAME", username: "NOUSERNAME", roles: nil)
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            IdaoManager.shared.getUserAccount(userId: userId) { status, account in
                if let account = account {
                    retAccount = account
                }
                mainGroup.leave()
            }
            mainGroup.wait()
            self.queue.async(flags: .barrier) {
                self.accountsCache[userId] = (retAccount, Date().timeIntervalSince1970)
            }
            completionHandler(retAccount)
        }
    }
}

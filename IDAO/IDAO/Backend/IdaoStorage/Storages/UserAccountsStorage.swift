//
//  UsersStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 19.05.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class UserAccountsStorage: BaseStorage<Int> {
    
    internal var accountsCache = [Int: User.Account]()
    
    func get(userId: Int, completionHandler: ((User.Account) -> ())) {
        self.queue.sync() {
            if let account = accountsCache[userId] {
                completionHandler(account)
            } else {
                var retAccount = User.Account(id: -1, name: "NONAME", username: "NOUSERNAME", roles: nil)
                let mainGroup = DispatchGroup()
                mainGroup.enter()
                IdaoManager.shared.getUserAccount(userId: userId) { account in
                    retAccount = account
                    mainGroup.leave()
                }
                mainGroup.wait()
                self.queue.async(flags: .barrier) {
                    self.accountsCache[userId] = retAccount
                }
                completionHandler(retAccount)
            }
        }
    }
}

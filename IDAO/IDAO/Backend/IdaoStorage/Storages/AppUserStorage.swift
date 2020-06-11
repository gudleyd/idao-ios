//
//  UserStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 18.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class AppUserStorage: BaseStorage<User> {

    override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            guard let id = IdaoManager.shared.myUserId() else { return }
            var appUserAccount: User.Account?
            var appUserPersonalData: User.PersonalData?
            
            let group = DispatchGroup()
            group.enter()
            IdaoManager.shared.getUserAccount(userId: id) { account in
                appUserAccount = account
                group.leave()
            }
            group.enter()
            IdaoManager.shared.getUserPersonalData(userId: id) { personalData in
                appUserPersonalData = personalData
                group.leave()
            }
            group.wait()
            if let account = appUserAccount,
                let personalData = appUserPersonalData {
                self.set([User(account: account, personalData: personalData)]) {
                    completionHandler()
                }
            }
            self.notify()
            completionHandler()
        }
    }
}

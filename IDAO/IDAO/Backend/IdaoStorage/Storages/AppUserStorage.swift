//
//  UserStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 18.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class AppUserStorage: BaseStorage<User> {

    override func update(completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            IdaoManager.shared.getMyAccount { user in
                print(user)
                self.set([user]) {
                    completionHandler()
                }
            }
        }
    }
}

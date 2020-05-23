//
//  UsersStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 19.05.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class UserAccountsStorage {
    
    internal let queue = DispatchQueue(label: "base-queue-\(UUID())", attributes: .concurrent)
    internal var items = [Int: User.Account]()
    
    func get(userId: Int) {
        self.queue.sync {
            self.items[userId]
        }
    }
}

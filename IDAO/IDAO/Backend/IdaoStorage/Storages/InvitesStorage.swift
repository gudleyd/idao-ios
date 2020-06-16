//
//  InvitesStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class InvitesStorage: BaseStorage<Int> {
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        if self.isUpdating {
            return
        }
        self.queue.async(flags: .barrier) {
            self.isUpdating = true
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            IdaoManager.shared.getMyInvites { [weak self] invites in
                self?.items = invites
                mainGroup.leave()
            }
            mainGroup.wait()
            self.notify()
            self.queue.async {
                completionHandler()
            }
            self.isUpdating = false
        }
    }
}

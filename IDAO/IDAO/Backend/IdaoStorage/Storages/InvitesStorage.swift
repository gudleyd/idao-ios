//
//  InvitesStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class IInvitesStorage: BaseStorage<Int> {
    
}


class InvitesStorage: IInvitesStorage {
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        if self.isUpdating {
            return
        }
        self.queue.async(flags: .barrier) {
            self.isUpdating = true
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            IdaoManager.shared.getMyInvites { [weak self] status, invites in
                if status == .success {
                    self?.items = invites
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
}

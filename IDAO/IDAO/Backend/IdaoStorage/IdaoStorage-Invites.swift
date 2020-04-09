//
//  IdaoStorage-Invites.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoStorage {
    
    func updateInvites(completionHandler: @escaping () -> ()) {
        self.invitesQueue.async(flags: .barrier) {
            IdaoManager.shared.getMyInvites { invites in
                self.setInvites(invites: invites) {
                    completionHandler()
                }
            }
        }
    }

    func getInvites(completionHandler: @escaping ([Int]) -> ()) {
        self.invitesQueue.sync() {
            completionHandler(self.invitesArray)
        }
    }

    func setInvites(invites: [Int], completionHandler: @escaping () -> ()) {
        self.invitesQueue.async(flags: .barrier) {
            self.invitesArray = invites
            self.invitesTableDelegate?.setInvites(invites: self.invitesArray)
            self.invitesTableDelegate?.reloadTable()
            completionHandler()
        }
    }
}

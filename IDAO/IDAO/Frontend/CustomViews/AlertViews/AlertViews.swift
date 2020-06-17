//
//  AlertViews.swift
//  IDAO
//
//  Created by Ivan Lebedev on 08.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit
import Foundation

class AlertViewsFactory {
    
    static func newAlert(title: String = "Error", message: String = "Try again later", handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
        return alertController
    }
    
    static func newPending(title: String = "Waiting...") -> UIAlertController {
        let pending = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        return pending
    }
    
    static func unknownError() -> UIAlertController {
        return self.newAlert(title: "Unknown Error", message: "Try again later or contact the administrator")
    }
    
    static func joiningContest() -> UIAlertController {
        return self.newPending(title: "Joining...")
    }
    
    static func creatingTeam() -> UIAlertController {
        return self.newPending(title: "Creating...")
    }
    
    static func invitingUser() -> UIAlertController {
        return self.newPending(title: "Inviting...")
    }
    
    static func leavingTeam() -> UIAlertController {
        return self.newPending(title: "Leaving...")
    }
    
    static func removingMember() -> UIAlertController {
        return self.newPending(title: "Removing...")
    }
    
    static func removingTeam() -> UIAlertController {
        return self.newPending(title: "Removing...")
    }
    
    static func emptyTeamName() -> UIAlertController {
        return self.newAlert(message: "Team name is empty")
    }
    
    static func emptyUsername() -> UIAlertController {
        return self.newAlert(message: "Username is empty")
    }
    
    static func userNotFound() -> UIAlertController {
        return self.newAlert(message: "User not found")
    }
    
    static func teamAlreadyExists() -> UIAlertController {
        return self.newAlert(message: "Team with this name already exists")
    }
    
    static func createTeam(completionHandler: @escaping (UIAlertAction, UIAlertController) -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: "Create New Team", message: "Enter Team Name", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Team Name"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert in
            completionHandler(alert, alertController)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        
        saveAction.isEnabled = alertController.textFields?[0].text?.isEmpty ?? false

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        return alertController
    }
    
    static func inviteMember(completionHandler: @escaping (UIAlertAction, UIAlertController) -> ()) -> UIAlertController {
        let alertController = UIAlertController(title: "Invite Member", message: "Enter Username", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Username"
        }
        let saveAction = UIAlertAction(title: "Invite", style: .default, handler: { alert in
            completionHandler(alert, alertController)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action : UIAlertAction!) -> Void in })
        
        saveAction.isEnabled = alertController.textFields?[0].text?.isEmpty ?? false

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        return alertController
    }
}

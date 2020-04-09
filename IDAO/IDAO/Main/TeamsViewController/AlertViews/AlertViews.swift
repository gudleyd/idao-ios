//
//  AlertViews.swift
//  IDAO
//
//  Created by Ivan Lebedev on 08.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation
import UIKit

class AlertViewsFactory {
    
    static func unknownError() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController
    }
    
    static func creatingTeam() -> UIAlertController {
        let pending = UIAlertController(title: "Creating...", message: nil, preferredStyle: .alert)
        return pending
    }
    
    static func emptyTeamName() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Team name is empty", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController
    }
    
    static func teamAlreadyExists() -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: "Team with this name already exists", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alertController
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
}

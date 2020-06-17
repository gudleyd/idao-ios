//
//  AppDelegate.swift
//  IDAO
//
//  Created by Ivan Lebedev on 21.10.2019.
//  Copyright © 2019 Ivan Lebedev. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var connectionUpdater: ConnectionUpdater!
    var noConnectionLabel: UILabel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.connectionUpdater = ConnectionUpdater(delegate: self)
        
        self.noConnectionLabel = UILabel(frame: CGRect(x: 0, y: -80, width: self.window?.frame.width ?? 0, height: 80))
        self.noConnectionLabel.numberOfLines = 0
        self.noConnectionLabel.text = "\n\nNo internet connection"
        self.noConnectionLabel.textColor = .white
        self.noConnectionLabel.textAlignment = .center
        self.noConnectionLabel.backgroundColor = .red
        self.window?.addSubview(self.noConnectionLabel)
        
        return true
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "IDAO")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: ConnectionUpdaterDelegate {
    
    func lostConnection() {
        DispatchQueue.main.async {
            self.window?.bringSubviewToFront(self.noConnectionLabel)
            UIView.animate(withDuration: 1.0, animations: {
                self.noConnectionLabel.frame = CGRect(x: 0, y: 0, width: self.window?.frame.width ?? 0, height: 80)
            })
        }
    }
    
    func foundConnection() {
        DispatchQueue.main.async {
            self.window?.bringSubviewToFront(self.noConnectionLabel)
            UIView.animate(withDuration: 1.0, animations: {
                self.noConnectionLabel.frame = CGRect(x: 0, y: -80, width: self.window?.frame.width ?? 0, height: 80)
            })
            IdaoStorage.news.update(forceUpdate: true) { }
            IdaoStorage.teams.update(forceUpdate: true) { }
            IdaoStorage.invites.update(forceUpdate: true) { }
            IdaoStorage.contests.update(forceUpdate: true) { }
            IdaoStorage.appUser.update(forceUpdate: true) { }
        }
    }
    
    
}

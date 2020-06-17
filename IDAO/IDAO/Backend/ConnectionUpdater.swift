//
//  ConnectionViewControllerUpdate.swift
//  IDAO
//
//  Created by Ivan Lebedev on 16.06.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import UIKit
import Foundation

protocol ConnectionUpdaterDelegate {
    
    func lostConnection()
    func foundConnection()
}


class ConnectionUpdater {
    
    let reachability: Reachability?
    public var delegate: ConnectionUpdaterDelegate?
    
    init(delegate: ConnectionUpdaterDelegate?) {
        self.delegate = delegate
        self.reachability = try? Reachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        try? self.reachability?.startNotifier()
    }
    
    @objc
    func reachabilityChanged(notification:NSNotification) {

        if let networkReachability = notification.object as? Reachability {
            if networkReachability.connection == .unavailable {
                self.delegate?.lostConnection()
            } else {
                self.delegate?.foundConnection()
            }
        }
    }
}

//
//  TeamsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 04.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

class IdaoStorage {

    internal let teamsQueue = DispatchQueue(label: "teams-queue-\(UUID())", attributes: .concurrent)
    internal var teamsArray = [Team]()
    
    internal let newsQueue = DispatchQueue(label: "news-queue-\(UUID())", attributes: .concurrent)
    internal var newsArray = [News]()
    
    internal let invitesQueue = DispatchQueue(label: "invites-queue-\(UUID())", attributes: .concurrent)
    internal var invitesArray = [Int]()
    
    internal weak var teamsTableDelegate: TeamsTableDelegate?
    internal weak var newsTableDelegate: NewsTableDelegate?
    internal weak var invitesTableDelegate: InvitesTableDelegate?
    
    init() {
        self.updateTeams(completionHandler: {})
        self.updateNews(completionHandler: {})
        self.updateInvites(completionHandler: {})
    }
    
    func setTeamsTableDelegate(delegate: TeamsTableDelegate) {
        self.teamsTableDelegate = delegate
    }
    
    func setNewsTableDelegate(delegate: NewsTableDelegate) {
        self.newsTableDelegate = delegate
    }
    
    func setInvitesTableDelegate(delegate: InvitesTableDelegate) {
        self.invitesTableDelegate = delegate
    }
}


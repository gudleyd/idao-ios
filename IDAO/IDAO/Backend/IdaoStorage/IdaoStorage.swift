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
    
    weak var teamsTableDelegate: TeamsTableDelegate?
    weak var newsTableDelegate: NewsTableDelegate?
    weak var invitesTableDelegate: InvitesTableDelegate?
    
    init() {
        self.updateTeams(completionHandler: {})
        self.updateNews(completionHandler: {})
        self.updateInvites(completionHandler: {})
    }
}


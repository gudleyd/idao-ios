//
//  TeamsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 04.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

class IdaoStorage {
    
    static let shared: IdaoStorage = IdaoStorage()
    
    static private(set) var news = NewsStorage()
    static private(set) var teams = TeamsStorage()
    static private(set) var invites = InvitesStorage()
    
    private init() { }
}


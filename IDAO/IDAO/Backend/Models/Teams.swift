//
//  Teams.swift
//  IDAO
//
//  Created by Ivan Lebedev on 03.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


struct Team: Codable {
    struct TeamMember: Codable {
        var userId: Int
        var username: String
        var name: String
        var role: String
        var status: String
        
        func isLeader() -> Bool {
            return self.role == "LEADER"
        }
        
        func isInvited() -> Bool {
            return self.status == "INVITED"
        }
    }
    var id: Int
    var name: String
    var status: String
    var registrationDate: Date
    var teamMembers: [TeamMember]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case registrationDate
    }
    
    func amILeader() -> Bool {
        var leader: Bool = false
        IdaoStorage.appUser.get { users in
            let me = users[0]
            leader = (self.teamMembers?.filter({ $0.userId == me.account.id }).count != 0)
        }
        return leader
    }
}

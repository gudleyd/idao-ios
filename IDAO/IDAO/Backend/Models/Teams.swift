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
        var id: Int
        var teamId: Int
        var userId: Int
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
    
    func isLocked() -> Bool {
        return self.status == "LOCKED"
    }
    
    func isOpen() -> Bool {
        return self.status == "OPEN"
    }
    
    func amILeader() -> Bool {
        return (self.teamMembers?.filter({ $0.userId == IdaoManager.shared.myUserId() && $0.role == "LEADER"}).count != 0)
    }
}

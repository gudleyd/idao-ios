//
//  Users.swift
//  IDAO
//
//  Created by Ivan Lebedev on 02.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

struct User: Codable {
    struct Account: Codable {
        struct Role: Codable {
            var id: Int
            var name: String
        }

        var id: Int
        var name: String
        var username: String
        var roles: [Role]?
    }
    
    struct PersonalData: Codable {
        var userId: Int
        var email: String?
        var birthday: Date?
        var phoneNumber: String?
        var gender: String?
        var countryOfResidence: String?
        var university: String?
        var studyProgram: String?
        var levelOfStudy: String?
        var company: String?
        var registrationDate: Date?
    }
    
    var account: Account
    var personalData: PersonalData
}

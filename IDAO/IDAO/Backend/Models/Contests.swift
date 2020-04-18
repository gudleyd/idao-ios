//
//  Contests.swift
//  IDAO
//
//  Created by Ivan Lebedev on 16.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

struct Contest: Codable {
    struct Settings: Codable {
    
    }

    var id: Int
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date
    var status: String
    var settings: Settings?
}

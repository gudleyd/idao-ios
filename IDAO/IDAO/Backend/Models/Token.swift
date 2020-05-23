//
//  Token.swift
//  IDAO
//
//  Created by Ivan Lebedev on 19.05.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

struct Token: Decodable {
    var accessToken: String
    var tokenType: String
}

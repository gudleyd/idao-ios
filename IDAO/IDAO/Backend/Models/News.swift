//
//  News.swift
//  IDAO
//
//  Created by Ivan Lebedev on 02.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation

struct News: Decodable {
    
    var id: Int
    var header: String
    var body: String
    var publicationDate: Date
    var authorId: Int
}

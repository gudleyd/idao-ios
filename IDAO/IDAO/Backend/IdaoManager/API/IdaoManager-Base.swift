//
//  IdaoManager-Api.swift
//  IDAO
//
//  Created by Ivan Lebedev on 04.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation
import KeychainSwift


extension IdaoManager {
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }
    
    func getJsonEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(self.getDateFormatter())
        
        return encoder
    }
    
    func getJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(self.getDateFormatter())
        
        return decoder
    }
    
    func baseRequest(mapping: String) -> URLRequest {
        var request = URLRequest(url: URL(string: self.baseUrl + mapping)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(AppKeys.apptoken)", forHTTPHeaderField: "App-Token")
        if let token = self.token {
            request.addValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    enum SimpleRequestStatus {
        case success
        case unknownError
    }
}

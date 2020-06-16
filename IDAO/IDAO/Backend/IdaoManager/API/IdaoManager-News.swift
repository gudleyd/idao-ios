//
//  IdaoManager-News.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoManager {
    func getNews(completionHandler: @escaping (SimpleRequestResult, [News]) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/news/")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data,
                let news = try? self.getJsonDecoder().decode([News].self, from: data) {
                
                completionHandler(.success, news)
            } else {
                completionHandler(.unknownError, [])
            }
        }
        task.resume()
    }
}

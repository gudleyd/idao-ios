//
//  IdaoManager-News.swift
//  IDAO
//
//  Created by Ivan Lebedev on 09.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoManager {
    func getNews(completionHandler: @escaping ([News]) -> ()) {
        
        let request = self.baseRequest(mapping: "/api/news/")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            //print(String(data: data, encoding: .utf8)!)
            let news = try! self.getJsonDecoder().decode([News].self, from: data)
            completionHandler(news)
        }
        task.resume()
    }
}

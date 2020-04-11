//
//  NewsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class NewsStorage: BaseStorage<News> {
    
    override func update(completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            IdaoManager.shared.getNews { news in
                self.set(news) {
                    completionHandler()
                }
            }
        }
    }
}

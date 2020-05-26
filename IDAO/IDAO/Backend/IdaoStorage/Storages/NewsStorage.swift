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
            IdaoManager.shared.getNews { [weak self] news in
                self?.set(news.sorted(by: {n1, n2 in return n1.publicationDate > n2.publicationDate})) {
                    completionHandler()
                }
            }
        }
    }
}

//
//  IdaoStorage-News.swift
//  IDAO
//
//  Created by Ivan Lebedev on 07.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


extension IdaoStorage {
    
    func updateNews(completionHandler: @escaping () -> ()) {
        self.newsQueue.async(flags: .barrier) {
            IdaoManager.shared.getNews { news in
                self.setNews(news: news) {
                    completionHandler()
                }
            }
        }
    }

    func getNews(completionHandler: @escaping ([News]) -> ()) {
        self.newsQueue.sync() {
            completionHandler(self.newsArray)
        }
    }

    func setNews(news: [News], completionHandler: @escaping () -> ()) {
        self.newsQueue.async(flags: .barrier) {
            self.newsArray = news
            self.newsTableDelegate?.setNews(news: self.newsArray)
            self.newsTableDelegate?.reloadTable()
            completionHandler()
        }
    }
}

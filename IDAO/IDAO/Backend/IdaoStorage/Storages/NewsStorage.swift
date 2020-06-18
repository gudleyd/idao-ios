//
//  NewsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class INewsStorage: BaseStorage<News> {
    
}


class NewsStorage: INewsStorage {
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        if self.isUpdating {
            return
        }
        self.queue.async(flags: .barrier) {
            self.isUpdating = true
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            IdaoManager.shared.getNews { status, news in
                if status == .success {
                    self.items = news
                    print(news)
                }
                mainGroup.leave()
            }
            mainGroup.wait()
            self.notify()
            self.isUpdating = false
            self.queue.async {
                completionHandler()
            }
        }
    }
}

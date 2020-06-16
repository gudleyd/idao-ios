//
//  NewsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class NewsStorage: BaseStorage<News> {
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        if self.isUpdating {
            return
        }
        self.queue.async(flags: .barrier) {
            self.isUpdating = true
            let mainGroup = DispatchGroup()
            mainGroup.enter()
            IdaoManager.shared.getNews { news in
                self.items = news
                mainGroup.leave()
            }
            mainGroup.wait()
            self.notify()
            self.queue.async {
                completionHandler()
            }
            self.isUpdating = false
        }
    }
}

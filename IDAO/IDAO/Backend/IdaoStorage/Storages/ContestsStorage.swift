//
//  ContestsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 24.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class ContestsStorage: BaseStorage<Contest> {
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        if self.isUpdating {
            return
        }
        self.queue.async(flags: .barrier) {
            self.isUpdating = true
            let parentGroup = DispatchGroup()
            parentGroup.enter()
            var contests = [Contest]()
            IdaoManager.shared.getPublishedContests { status, pContests in
                contests = pContests
                for i in 0..<contests.count {
                    parentGroup.enter()
                    parentGroup.enter()
                    IdaoManager.shared.getContestSettings(id: contests[i].id) { status, settings in
                        if let settings = settings {
                            contests[i].settings = settings
                        }
                        parentGroup.leave()
                    }
                    IdaoManager.shared.getContestStages(id: contests[i].id) { status, stages in
                        contests[i].stages = stages
                        parentGroup.leave()
                    }
                }
                parentGroup.leave()
            }
            parentGroup.wait()
            self.items = contests
            self.notify()
            self.queue.async {
                completionHandler()
            }
            self.isUpdating = false
        }
    }
}

//
//  ContestsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 24.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class ContestsStorage: BaseStorage<Contest> {
    
    override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            var contests: [Contest] = []
            let parentGroup = DispatchGroup()
            parentGroup.enter()
            IdaoManager.shared.getPublishedContests { pContests in
                contests = pContests
                for i in 0..<contests.count {
                    parentGroup.enter()
                    parentGroup.enter()
                    IdaoManager.shared.getContestSettings(id: contests[i].id) { settings in
                        contests[i].settings = settings
                        parentGroup.leave()
                    }
                    IdaoManager.shared.getContestStages(id: contests[i].id) { stages in
                        contests[i].stages = stages
                        parentGroup.leave()
                    }
                }
                parentGroup.leave()
            }
            parentGroup.wait()
            self.items = contests
            self.notify()
            completionHandler()
        }
    }
}

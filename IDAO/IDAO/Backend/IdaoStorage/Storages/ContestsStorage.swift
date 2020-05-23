//
//  ContestsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 24.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class ContestsStorage: BaseStorage<Contest> {
    
    override func update(completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            var contests: [Contest] = []
            IdaoManager.shared.getPublishedContests { pContests in
                contests = pContests
                let mainGroup = DispatchGroup()
                for i in 0..<contests.count {
                    mainGroup.enter()
                    IdaoManager.shared.getContestSettings(id: contests[i].id) { settings in
                        contests[i].settings = settings
                        mainGroup.leave()
                    }
                    mainGroup.enter()
                    IdaoManager.shared.getContestStages(id: contests[i].id) { stages in
                        contests[i].stages = stages
                        mainGroup.leave()
                    }
                }
                self.queue.async {
                    mainGroup.wait()
                    self.set(contests) {
                        completionHandler()
                    }
                }
            }
        }
    }
}

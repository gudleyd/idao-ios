//
//  ContestsStorage.swift
//  IDAO
//
//  Created by Ivan Lebedev on 24.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


class IContestsStorage: BaseStorage<Contest> {
    
}


class ContestsStorage: IContestsStorage {
    
    final override func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        if self.isUpdating {
            return
        }
        self.queue.async(flags: .barrier) {
            self.isUpdating = true
            let parentGroup = DispatchGroup()
            var contests = [Contest]()
            parentGroup.enter()
            IdaoManager.shared.getOpenedContests { status, pContests in
                contests = pContests
                for i in 0..<pContests.count {
                    parentGroup.enter()
                    parentGroup.enter()
                    IdaoManager.shared.getContestSettings(id: contests[i].id) { status, settings in
                        if let settings = settings {
                            contests[i].settings = settings
                        }
                        parentGroup.leave()
                    }
                    IdaoManager.shared.getContestStages(id: contests[i].id) { status, stages in
                        if status == .success {
                            contests[i].stages = stages
                        }
                        parentGroup.leave()
                    }
                }
                parentGroup.leave()
            }
            parentGroup.wait()
            parentGroup.enter()
            IdaoManager.shared.getClosedContests { status, pContests in
                let size = contests.count
                contests.append(contentsOf: pContests)
                for i in 0..<pContests.count {
                    parentGroup.enter()
                    parentGroup.enter()
                    IdaoManager.shared.getContestSettings(id: contests[size + i].id) { status, settings in
                        if let settings = settings {
                            contests[size + i].settings = settings
                        }
                        parentGroup.leave()
                    }
                    IdaoManager.shared.getContestStages(id: contests[size + i].id) { status, stages in
                        if status == .success {
                            contests[size + i].stages = stages
                        }
                        parentGroup.leave()
                    }
                }
                parentGroup.leave()
            }
            parentGroup.wait()
            self.items = contests
            self.notify()
            self.isUpdating = false
            self.queue.async {
                completionHandler()
            }
        }
    }
}

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
                var localContests = pContests
                for i in 0..<localContests.count {
                    parentGroup.enter()
                    parentGroup.enter()
                    IdaoManager.shared.getContestSettings(id: localContests[i].id) { status, settings in
                        if let settings = settings {
                            localContests[i].settings = settings
                        }
                        parentGroup.leave()
                    }
                    IdaoManager.shared.getContestStages(id: localContests[i].id) { status, stages in
                        if status == .success {
                            localContests[i].stages = stages
                        }
                        parentGroup.leave()
                    }
                }
                contests += localContests
                parentGroup.leave()
            }
            parentGroup.wait()
            parentGroup.enter()
            IdaoManager.shared.getClosedContests { status, pContests in
                var localContests = pContests
                for i in 0..<localContests.count {
                    parentGroup.enter()
                    parentGroup.enter()
                    IdaoManager.shared.getContestSettings(id: localContests[i].id) { status, settings in
                        if let settings = settings {
                            localContests[i].settings = settings
                        }
                        parentGroup.leave()
                    }
                    IdaoManager.shared.getContestStages(id: localContests[i].id) { status, stages in
                        if status == .success {
                            localContests[i].stages = stages
                        }
                        parentGroup.leave()
                    }
                }
                contests += localContests
                parentGroup.leave()
            }
            parentGroup.wait()
            print(contests)
            self.items = contests
            self.notify()
            self.isUpdating = false
            self.queue.async {
                completionHandler()
            }
        }
    }
}

//
//  StorageInterface.swift
//  IDAO
//
//  Created by Ivan Lebedev on 11.04.2020.
//  Copyright © 2020 Ivan Lebedev. All rights reserved.
//

import Foundation


protocol StorageObserverDelegate: class {
    func update(_ sender: Any?, _ data: Any?)
}

class BaseStorage<Item> {
    
    class StorageObserver {
        var id = UUID()
        weak var delegate: StorageObserverDelegate?
        
        init(delegate: StorageObserverDelegate?) {
            self.delegate = delegate
        }
    }
    
    internal let queue = DispatchQueue(label: "base-queue-\(UUID())", qos: .userInitiated, attributes: .concurrent)
    internal var items = [Item]()
    
    internal var observersQueue = DispatchQueue(label: "observers-queue-\(UUID())", attributes: .concurrent)
    internal lazy var observers = [StorageObserver]()
    
    init() {
        self.update(completionHandler: {})
    }

    func subscribe(_ observer: StorageObserver) {
        self.observersQueue.async(flags: .barrier) { [weak self] in
            guard self?.observers.contains(where: { $0.id == observer.id }) == false else {
                return
            }
            self?.observers.append(observer)
        }
    }

    func unsubscribe(_ observer: StorageObserver) {
        self.observersQueue.async(flags: .barrier) { [weak self] in
            if let idx = self?.observers.firstIndex(where: { $0 === observer }) {
                self?.observers.remove(at: idx)
            }
        }
    }

    func notify() {
        self.observersQueue.async(flags: .barrier) { [weak self] in
            self?.observers = self?.observers.filter { observer in return observer.delegate != nil } ?? []
            self?.observers.forEach { observer in
                if let items = self?.items {
                    observer.delegate?.update(self, items)
                }
            }
        }
    }

    func get(completionHandler: @escaping ([Item]) -> ()) {
        self.queue.sync() {
            completionHandler(self.items)
        }
    }

    func set(_ newItems: [Item], completionHandler: @escaping () -> ()) {
        self.queue.async(flags: .barrier) {
            self.items = newItems
            self.notify()
            completionHandler()
        }
    }

    func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        print("Update method should be overriden")
    }
}

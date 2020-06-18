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


class Subscriable {
    
    class StorageObserver {
        var id = UUID()
        weak var delegate: StorageObserverDelegate?
        
        init(delegate: StorageObserverDelegate?) {
            self.delegate = delegate
        }
    }
    
    internal var observersQueue = DispatchQueue(label: "observers-queue-\(UUID())", qos: .userInitiated, attributes: .concurrent)
    internal lazy var observers = [StorageObserver]()
    
    final func subscribe(_ observer: StorageObserver) {
        self.observersQueue.async(flags: .barrier) { [weak self] in
            guard self?.observers.contains(where: { $0.id == observer.id }) == false else {
                return
            }
            self?.observers.append(observer)
        }
    }

    final func unsubscribe(_ observer: StorageObserver) {
        self.observersQueue.async(flags: .barrier) { [weak self] in
            if let idx = self?.observers.firstIndex(where: { $0 === observer }) {
                self?.observers.remove(at: idx)
            }
        }
    }
    
    func notify() {
        fatalError("notify should be overwritten")
    }
}


protocol IBaseStorage {
    associatedtype T
    
    func get(completionHandler: @escaping ([T]) -> ())
    func clear()
    func update(forceUpdate: Bool, completionHandler: @escaping () -> ())
}


class BaseStorage<Item>: Subscriable, IBaseStorage {
    typealias T = Item
    
    internal let queue = DispatchQueue(label: "base-queue-\(UUID())", qos: .userInitiated, attributes: .concurrent)
    internal var items = [Item]()
    internal var isUpdating: Bool = false
    
    init(makeUpdate: Bool = true) {
        super.init()
        
        if makeUpdate {
            self.update(completionHandler: {})
        }
    }

    final override func notify() {
        self.observersQueue.async(flags: .barrier) { [weak self] in
            self?.observers = self?.observers.filter { observer in return observer.delegate != nil } ?? []
            if let items = self?.items {
                self?.observers.forEach { observer in
                    observer.delegate?.update(self, items)
                }
            }
        }
    }

    final func get(completionHandler: @escaping ([Item]) -> ()) {
        self.queue.sync() {
            completionHandler(self.items)
        }
    }
    
    func clear() {
        self.queue.async(flags: .barrier) {
            self.items = []
        }
    }

    func update(forceUpdate: Bool = false, completionHandler: @escaping () -> ()) {
        fatalError("Update method should be overriden")
    }
}

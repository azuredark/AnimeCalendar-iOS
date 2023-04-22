//
//  LocalStorageManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 3/04/23.
//

import Foundation

final actor LocalStorageManager {
    // MARK: State
    // UserDefaults
    private let storage = UserDefaults.standard
    
    nonisolated var timeNowSeconds: Double { Date().timeIntervalSince1970 }
    
    // Singleton
    static let shared = LocalStorageManager()

    // MARK: Initializers
    private init() {}

    // MARK: Methods

    /// Load an item from LocalStorage by key.
    /// - Parameter keyPath: The **LocalKeys** keypath.
    /// - Returns: Local stored data of T type.
    ///
    /// - Note: https://developer.apple.com/documentation/swift/keypath
    func load<T>(_ keyPath: KeyPath<LocalKeys, String>) -> T? {
        // Get the key
        let key = LocalKeys()[keyPath: keyPath]
        Logger.log(.local, msg: "Retrieving - Looking under: \(key)")

        // Get the value
        guard let value = storage.value(forKey: key) else {
            Logger.log(.local, .error, msg: "Retrieving - Error - Not found under: \(key)")
            return nil
        }
        
        // Downcast value
        guard let value = value as? T else {
            Logger.log(.local, .error, msg: "Retrieving - Error - Requested type was: \(T.self) but saved type was: \(type(of: value))")
            return nil
        }
        
        // Success
        Logger.log(.local, .success, msg: "Retrieving - Loaded from local: [\(key): \(value)]")
        
        return value
    }

    func save<T>(key keyPath: KeyPath<LocalKeys, String>, value: T) {
        let key = LocalKeys()[keyPath: keyPath]
        storage.set(value, forKey: key)
        
        Logger.log(.local, msg: "Saving - Saved to local: [\(key): \(value)] as \(T.self)")
    }

    func remove(_ keyPath: KeyPath<LocalKeys, String>) {
        let key = LocalKeys()[keyPath: keyPath]
        storage.removeObject(forKey: key)
        
        Logger.log(.local, msg: "Removing - Removed from local: \(key)")
    }

    /// Empties the UserDefaults storage.
    ///
    /// - Warning: Only use in specific-dangerous tasks or **debugging**.
    func deleteAll() {}
}

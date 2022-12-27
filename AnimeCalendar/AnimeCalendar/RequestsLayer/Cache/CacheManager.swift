//
//  CacheManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

// https://developer.apple.com/library/archive/documentation/General/Conceptual/CocoaEncyclopedia/Introspection/Introspection.html#//apple_ref/doc/uid/TP40010810-CH9-SW61
// MARK: - Cache Wrappers
/// Wrapper for NSCache **Key**.
final class CacheKey: NSObject {
    let key: String

    override var hash: Int { return key.hashValue }

    init(_ key: String) {
        self.key = key
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let cacheKey = object as? CacheKey else {
            return false
        }
        return cacheKey.key == self.key
    }
}

/// Wrapper for NSCache **Value** hasahble model.
final class CacheValue {
    let value: AnyHashable
    init(_ value: AnyHashable) {
        self.value = value
    }
}

// MARK: - Cache protocols & extensions
/// # Docs.
/// https://developer.apple.com/documentation/foundation/nscache
protocol CacheManagable {
    /// Retrieves a cache object **reference** from a specific screen.
    /// - Parameter screen: ScreenType to retrieve cache from.
    /// - Returns: ScreenCachable (Screen's cache) object reference.
    func getCache(from screen: ScreenType) -> Cacheable?

    /// Retrieves the cache object **reference** for External Resources (i.e.: Images).
    /// - Returns: ScreenCachable (External Resource cache) object reference.
    func getExternalResourceCache() -> Cacheable?
}

protocol Cacheable {
    /// NSCache data structure which holds hashable data accessed by *key*.
    var storage: NSCache<CacheKey, CacheValue> { get }

    /// NSCache name
    var name: String { get }

    /// NSCache limit
    var countLimit: Int { get }

    /// Configure/update cache storage settings
    func configureStorageInitialSettings()

    /// Updates the NSCache **max items capacity** limit
    func updateLimit(to newLimit: Int)

    /// Save a cache value by a Key.
    /// - Parameter key: The key which locates the value.
    /// - Parameter value: The value to store under the Key
    func save(key: String, value: AnyHashable)

    /// Load value from the cache.
    /// - Parameter key: The key which to look up for the value.
    /// - Returns: A CacheValue, the Cache's value for the key
    func load(from key: String) -> CacheValue?

    /// Deletes all cached values in **storage**
    func deleteAllObjects()
}

extension Cacheable {
    func save(key: String, value: AnyHashable) {
        let cacheKey = CacheKey(key)
        let cacheValue = CacheValue(value)
        storage.setObject(cacheValue, forKey: cacheKey)
    }

    func load(from key: String) -> CacheValue? {
        let cacheKey = CacheKey(key)
        return storage.object(forKey: cacheKey)
    }

    func updateLimit(to newLimit: Int) {
        storage.countLimit = newLimit
    }

    func deleteAllObjects() {
        print("senku [DEBUG] \(String(describing: type(of: self))) - DELETED CACHE FROM: \(name)")
        storage.removeAllObjects()
    }
}

// MARK: - Cache Screen Objects

// MARK: Cache Manager
final class CacheManager: CacheManagable {
    /// # Cache modules
    private lazy var externalResourceCache = ExternalResourceCache()
    private lazy var homeCache = HomeCache()
    private lazy var discoverCache = DiscoverCache()

    /// # Singleton instance
    static let shared: CacheManagable = CacheManager()
    
    // MARK: Initializers
    private init() {}

    func getCache(from screen: ScreenType) -> Cacheable? {
        switch screen {
            case .homeScreen:
                return homeCache
            case .discoverScreen:
                return discoverCache
            default: return nil
        }
    }

    func getExternalResourceCache() -> Cacheable? {
        return externalResourceCache
    }
}

// MARK: External Resource Cache
final class ExternalResourceCache: Cacheable {
    private(set) lazy var storage = NSCache<CacheKey, CacheValue>()

    private(set) var name: String {
        get  { storage.name }
        set { storage.name = newValue }
    }

    private(set) var countLimit: Int {
        get  { storage.countLimit }
        set { storage.countLimit = newValue }
    }

    func configureStorageInitialSettings() {
        storage.name = "cache_external_resource"
        storage.countLimit = 50
    }

    // Initializers
    init() {
        configureStorageInitialSettings()
    }
}

// MARK: Home Cache
final class HomeCache: Cacheable {
    private(set) lazy var storage = NSCache<CacheKey, CacheValue>()

    private(set) var name: String {
        get  { storage.name }
        set { storage.name = newValue }
    }

    private(set) var countLimit: Int {
        get  { storage.countLimit }
        set { storage.countLimit = newValue }
    }

    func configureStorageInitialSettings() {
        storage.name = "cache_home"
        storage.countLimit = 20
    }

    /// # Initializers
    init() {
        configureStorageInitialSettings()
    }
}

// MARK: Discover Cache
final class DiscoverCache: Cacheable {
    private(set) lazy var storage = NSCache<CacheKey, CacheValue>()

    private(set) var name: String {
        get  { storage.name }
        set { storage.name = newValue }
    }

    private(set) var countLimit: Int {
        get  { storage.countLimit }
        set { storage.countLimit = newValue }
    }

    func configureStorageInitialSettings() {
        storage.name = "cache_discover"
        storage.countLimit = 100
    }

    /// # Initializers
    init() {
        configureStorageInitialSettings()
    }
}

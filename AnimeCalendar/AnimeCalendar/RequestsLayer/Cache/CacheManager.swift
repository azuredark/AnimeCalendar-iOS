//
//  CacheManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class CacheKey {
    let key: String
    init(_ key: String) {
        self.key = key
    }
}

final class CacheValue {
    let value: AnyHashable
    init(_ value: AnyHashable) {
        self.value = value
    }
}

/// # Docs.
/// https://developer.apple.com/documentation/foundation/nscache
class CacheManager: NSCache<CacheKey, CacheValue> {
    // MARK: State

    // MARK: Initializers
    init(name: String, maxCount: Int) {
        // (Superclass) NSCache's Initialzier & properties
        super.init()
        self.name = name
        self.countLimit = countLimit
    }

    // MARK: Methods
    /// Save a cache value by a Key.
    /// - Parameter key: The key which locates the value.
    /// - Parameter value: The value to store under the Key
    func save(key: String, value: AnyHashable) {
        let cacheKey = CacheKey(key)
        let cacheValue = CacheValue(value)
        setObject(cacheValue, forKey: cacheKey)
    }
    
    /// Load value from the cache.
    /// - Parameter key: The key which to look up for the value.
    /// - Returns: A CacheValue, the Cache's value for the key
    func load(from key: String) -> CacheValue? {
        let cacheKey = CacheKey(key)
        return object(forKey: cacheKey)
    }
}

protocol ScreenCacheable {
    var cacheName: String { get }
    var cacheMaxItems: Int { get }
}

final class HomeCache: CacheManager, ScreenCacheable {
    let cacheName: String = "home_cache"
    let cacheMaxItems: Int = 50
    
    init() {
        super.init(name: cacheName, maxCount: cacheMaxItems)
    }
}

final class NewAnimeCache: CacheManager, ScreenCacheable {
    let cacheName: String = "new_anime_cache"
    let cacheMaxItems: Int = 50
    
    init() {
        super.init(name: cacheName, maxCount: cacheMaxItems)
    }
}

final class CalendarCache: CacheManager, ScreenCacheable {
    let cacheName: String = "calendar_cache"
    var cacheMaxItems: Int = 50
    
    init() {
        super.init(name: cacheName, maxCount: cacheMaxItems)
    }
}

final class DiscoverCache: CacheManager, ScreenCacheable {
    let cacheName: String = "discover_cache"
    var cacheMaxItems: Int = 50
    
    init() {
        super.init(name: cacheName, maxCount: cacheMaxItems)
    }
}


final class CacheFactory {
    func getCacheModule(from screen: ScreenType) -> CacheManager {
        switch screen {
            case .homeScreen:
                return HomeCache()
            case .newAnimeScreen:
                return NewAnimeCache()
            case .calendarScreen:
                return CalendarCache()
            case .discoverScreen:
                return DiscoverCache()
        }
    }
}

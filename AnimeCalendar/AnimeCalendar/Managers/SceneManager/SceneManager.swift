//
//  SceneManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 3/04/23.
//

import UIKit
import Nuke

final class SceneManager {
    // MARK: State
    /// 2 minutes.
    private let ANIME_DETAIL_SHOULD_RESET_THRESHOLD_SECONDS: Double = 2 * 60
    private let local = LocalStorageManager.shared
    
    private let rootVC: UIViewController
    
    // MARK: Initializers
    init(rootVC: UIViewController) {
        self.rootVC = rootVC
    }

    // MARK: Methods
    func resetPresentedDetailAnimeScreen() async {
        // 1. Get time-elapsed-since-log-out
        guard let timeUserLoggedOutSeconds: Double = await local.load(\.timeUserLoggedOutSeconds) else { return }
        /// Time elapsed since app was sent to **background** to go back to **foreground**
        let timeElapsed = local.timeNowSeconds - timeUserLoggedOutSeconds
        Logger.log(.info, msg: "Time background: \(timeUserLoggedOutSeconds)")
        Logger.log(.info, msg: "Time now: \(local.timeNowSeconds)")
        Logger.log(.info, msg: "Time elapsed: \(timeElapsed)")
        
        // 2. If threshold is met then look for the AnimeDetailScreen and dismiss it.
        guard timeElapsed >= ANIME_DETAIL_SHOULD_RESET_THRESHOLD_SECONDS else { return }
        
        if let animeDetailScreen = await getScreen(.animeDetailScreen()) {
            // Dismiss screen
            await dismissController(animeDetailScreen)
        }
        
        // 3. Reset the TrailerComponent
        TrailerComponent.shared.configureComponent(preheated: false)
    }
    
    func deleteImagesCache() {
        // Cleack image cache
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        
        if let imageCache = ImagePipeline.shared.configuration.imageCache as? ImageCache {
            Logger.log(.info, msg: "1. Total cache to remove cost: \(formatter.string(fromByteCount: Int64(imageCache.totalCost))) / \(formatter.string(fromByteCount: Int64(imageCache.costLimit)))")
            ImagePipeline.shared.cache.removeAll(caches: .all)
        }
    }
}

private extension SceneManager {
    @MainActor
    func getScreen(_ screen: ScreenType) async -> Screen? {
        switch screen {
            case .animeDetailScreen:
                return getAnimeDetailScreen()
            default: return nil
        }
    }
    
    @MainActor
    func dismissController(_ vc: UIViewController, animated: Bool = false) {
        vc.dismiss(animated: animated)
    }
}

// MARK: - AnimeDetailScreen (Flow)
private extension SceneManager {
    /// Get **AnimeDetailScreen**
    func getAnimeDetailScreen() -> AnimeDetailScreen? {
        // Root VC is UINavigation
        if rootVC is UINavigationController {
            return getAnimeDetailScreen(from: rootVC)
        }
        
        // Root VC is UITabBar
        guard let rootTabBar = rootVC as? UITabBarController else { return nil }
        guard let discoverScreen = getNavigationFromTabBar(rootTabBar, for: .discoverScreen) else { return nil }
        
        return getAnimeDetailScreen(from: discoverScreen)
    }
    
    func getAnimeDetailScreen(from rootController: UIViewController) -> AnimeDetailScreen? {
        guard let detailNavigation = rootController.presentedViewController as? UINavigationController else { return nil }
        guard let animeDetailScreen = detailNavigation.topViewController as? AnimeDetailScreen else { return nil }
        return animeDetailScreen
    }
}

private extension SceneManager {
    func getNavigationFromTabBar(_ tabBar: UITabBarController, for screen: ScreenType) -> UINavigationController? {
        guard let navigationControllers = tabBar.viewControllers?.compactMap({ $0 as? UINavigationController }) else {
            return nil
        }
        
        let navigationControllersRoots = navigationControllers.compactMap { $0.viewControllers.first }
        
        let getNavigationFor: (_ firstController: UIViewController, _ screenType: ScreenType) -> Bool = { (firstController, _) in
            switch screen {
                case .homeScreen:
                    return firstController is HomeScreen
                case .newAnimeScreen:
                    return firstController is NewAnimeScreen
                case .calendarScreen:
                    return firstController is AnimeCalendarScreen
                case .discoverScreen:
                    return firstController is DiscoverScreen
                case .animeDetailScreen:
                    return firstController is AnimeDetailScreen
            }
        }
        
        for (navigationController, navigationFirstController) in zip(navigationControllers, navigationControllersRoots) {
            if getNavigationFor(navigationFirstController, screen) { return navigationController }
        }
        
        return nil
    }
}

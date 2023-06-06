//
//  AppDelegate.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/04/22.
//

import UIKit
import Nuke

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Setting-up Nuke PipeLine
        // Disable default disk-cache. Prevent caching an image twice.
        DataLoader.sharedUrlCache.diskCapacity = 0
        DataLoader.sharedUrlCache.memoryCapacity = 50 * 1024 * 1024
        
        // Create new pipeline
        let pipeline = ImagePipeline { config in
            // Create new Cache
            let dataCache = try? DataCache(name: "net.estremadoyro.Anime-Calendar.image-cache")

            // Size limit -> Default 150MB
            dataCache?.sizeLimit = 50 * 1024 * 1024
            // Update DataCache in config
            config.dataCache = dataCache
        }
        /// # Override ImagePipeline
        ImagePipeline.shared = pipeline

        // MARK: Setting-up Nuke ImageLoadingOptions
        let options = ImageLoadingOptions(placeholder: UIImage(named: "dark-placeholder"),
                                          transition: .fadeIn(duration: 0.4, options: .layoutSubviews),
                                          failureImage: UIImage(named: "new-anime-item-placeholder"),
                                          contentModes: .init(success: .scaleAspectFill,
                                                              failure: .scaleAspectFit,
                                                              placeholder: .scaleAspectFill))
        /// # Override ImageLoadingOptions
        ImageLoadingOptions.shared = options
        
        // MARK: Setting up filters.
        let filterSource = ACFilterSource.shared
        filterSource.preloadFilters([.areaAverage])
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

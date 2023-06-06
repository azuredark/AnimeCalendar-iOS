//
//  SceneDelegate.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/04/22.
//

import UIKit
import Nuke

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var sceneManager: SceneManager?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let bootManager = BootManager()

        /// Bootable screens
        ///
        /// Every new screen created **must** conform to **RootViewController** and be added to the **ScreenFactory** class in order by be *bootable* from. As the project grows, modules should start to become as independant as possible.
        ///
        /// .rootTabBar (Main, for intializing all the app's modules)
        /// i.e.: bootManager.getRootController(.rootTabBar(screens: [.discoverScreen]))
        /// Screen types (Directly load a specific module only):
        /// - .home
        /// - .newAnime
        /// - .calendar
        /// - .discover
        /// i.e.: bootManager.getRootController(.rootScreen(screen: .discoverScreen))
        let rootController = bootManager.getRootController(.rootTabBar(screens: [.discoverScreen, .newAnimeScreen]))

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()

        // Scene Manager
        sceneManager = SceneManager(rootVC: rootController)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        Task(priority: .background) { await saveLocalParameters() }
        sceneManager?.deleteImagesCache()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    // MARK: App -> Foreground
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        /// # Manage scene updates
        Task {
            await sceneManager?.resetPresentedDetailAnimeScreen()
        }
    }

    // MARK: App -> Background
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        // Local parameters to save.
        Task(priority: .background) { await saveLocalParameters() }
        sceneManager?.deleteImagesCache()
    }
}

private extension SceneDelegate {
    func saveLocalParameters() async {
        let timeNow = Date().timeIntervalSince1970
        await LocalStorageManager.shared.save(key: \.timeUserLoggedOutSeconds, value: timeNow)
    }
}

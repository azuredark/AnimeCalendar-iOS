//
//  BootProduct.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import UIKit.UIViewController

protocol Boot {
  var requestsManager: RequestProtocol { get set }
  var rootVC: ScreenProtocol { get set }
  func createRootScreen() -> UIViewController
}

/// # Sandbox

protocol TabBarBuilderProtocol {
  func configureTabTitle() -> String
  func configureTabBadge() -> UIImage
  func tabImage() -> UIImage
}

final class TabBarManager {
  private let requestsManager = RequestsManager()
  private let tabBarController = UITabBarController()

  private var tabBarItems = [TabBarItem]()

  func configureTabScreens() {
    let tabFactory = TabBarFactory(requestsManager)

    let homeTabItem = tabFactory.getTabBarScreen(.homeTab)
    let newScheduledAnimeTabItem = tabFactory.getTabBarScreen(.newAnimeTab)
    let animeCalendarTabItem = tabFactory.getTabBarScreen(.animeCalendarTab)
    tabBarItems = [homeTabItem, newScheduledAnimeTabItem, animeCalendarTabItem]
  }

  func configureTabController() {
    tabBarController.viewControllers = tabBarItems.map { $0.wrapNavigation() }
  }

  func configureTabs() {
    guard let items = tabBarController.tabBar.items else { return }
    for (tabBarItem, item) in zip(tabBarItems, items) {
      item.badgeValue = tabBarItem.tabBadge
      item.title = tabBarItem.tabTitle
      item.image = tabBarItem.tabImage
    }
  }
}

final class TabBarFactory {
  private let requestsManager: RequestProtocol

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }

  func getTabBarScreen(_ tabBar: TabBarItemTypes) -> TabBarItem {
    switch tabBar {
      case .homeTab:
        return HomeScreenTabItem(requestsManager)
      case .newAnimeTab:
        return NewScheduledAnimeTabItem(requestsManager)
      case .animeCalendarTab:
        return AnimeCalendarTabItem(requestsManager)
    }
  }
}

// Creation types (1 tab, 2 tabs, etc)
enum TabBarItemTypes {
  case homeTab
  case newAnimeTab
  case animeCalendarTab
}

// ViewControllers
final class NewScheduledAnimeScreen: UIViewController, ScreenProtocol {
  var requestsManager: RequestProtocol
  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: "NewScheduledAnimeScreen", bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureNavigationItems() {}

  func configureRightNavigationItems() {}

  func configureLeftNavigationItems() {}
}

final class AnimeCalendarScreen: UIViewController, ScreenProtocol {
  var requestsManager: RequestProtocol

  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: "AnimeCalendarScreen", bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureNavigationItems() {}

  func configureRightNavigationItems() {}

  func configureLeftNavigationItems() {}
}

// Contract - TabBarItem
protocol TabBarItem {
  var requestsManager: RequestProtocol { get }
  var screen: ScreenProtocol { get }
  var tabBadge: String { get }
  var tabImage: UIImage { get }
  var tabTitle: String { get }
}

extension TabBarItem {
  func wrapNavigation() -> UINavigationController {
    return UINavigationController(rootViewController: screen)
  }
}

// TabBarItems
final class HomeScreenTabItem: TabBarItem {
  public private(set) var requestsManager: RequestProtocol
  public private(set) lazy var screen: ScreenProtocol = HomeScreenVC(requestsManager: requestsManager)
  public private(set) var tabBadge: String = "1"
  public private(set) var tabImage = UIImage(systemName: "house")!
  public private(set) var tabTitle: String = "Home"

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }
}

final class NewScheduledAnimeTabItem: TabBarItem {
  public private(set) var requestsManager: RequestProtocol
  public private(set) lazy var screen: ScreenProtocol = NewScheduledAnimeScreen(requestsManager: requestsManager)
  public private(set) var tabBadge: String = "1"
  public private(set) var tabImage = UIImage(systemName: "plus")!
  public private(set) var tabTitle: String = "New Anime"

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }
}

final class AnimeCalendarTabItem: TabBarItem {
  public private(set) var requestsManager: RequestProtocol

  public private(set) lazy var screen: ScreenProtocol = AnimeCalendarScreen(requestsManager: requestsManager)
  public private(set) var tabBadge: String = "3"
  public private(set) var tabImage = UIImage(systemName: "calendar")!
  public private(set) var tabTitle: String = "Calendar"

  init(_ requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
  }
}

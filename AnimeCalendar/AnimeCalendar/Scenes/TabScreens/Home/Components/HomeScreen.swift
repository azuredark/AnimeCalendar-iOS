//
//  HomeScreenVC.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import UIKit

final class HomeScreen: UIViewController, ScreenProtocol {
  // Protocol properties
  var requestsManager: RequestProtocol

  /// # NavigationBar
  lazy var navigationBar: ScreenNavigationBar = HomeScreenNavigationBar(self)

  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: Xibs.homeScreenView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureScreen()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("Screen dimensions")
    print("height: \(view.frame.size.height)")
    print("width: \(view.frame.size.width)")
  }
}

extension HomeScreen {
  func configureScreen() {
    configureNavigationItems()
    configureScreenComponents()
  }
}

extension HomeScreen {
  func configureScreenComponents() {
    let homeHeaderComponent = HomeHeaderComponent()
    addChildVC(homeHeaderComponent)
    configureComponentsConstraints(homeHeaderComponent)
  }

  func configureComponentsConstraints(_ homeHeader: UIViewController) {
    // HomeHeaderComponent
    let homeHeaderView: UIView = homeHeader.view
    homeHeaderView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      homeHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
      homeHeaderView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.09),
      homeHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      homeHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
    ])
  }
}

extension HomeScreen {
  func configureNavigationItems() {
    configureLeftNavigationItems()
    configureRightNavigationItems()
  }

  func configureLeftNavigationItems() {
    navigationBar.configureLeftNavigationItems()
  }

  func configureRightNavigationItems() {
    navigationBar.configureRightNavigationItems()
  }
}

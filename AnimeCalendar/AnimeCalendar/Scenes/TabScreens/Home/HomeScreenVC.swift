//
//  HomeScreenVC.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import UIKit

final class HomeScreenVC: UIViewController, ScreenProtocol {
  var requestsManager: RequestProtocol

  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: "HomeScreenVC", bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemIndigo
  }
}

extension HomeScreenVC {
  func configureScreen() {
    configureNavigationItems()
  }

  func configureNavigationItems() {
    configureLeftNavigationItems()
    configureRightNavigationItems()
  }

  func configureLeftNavigationItems() {}
  func configureRightNavigationItems() {}
}

//
//  NewScheduledAnimeScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit

final class NewAnimeScreen: UIViewController, ScreenProtocol {
  /// # IBOutlets
  @IBOutlet private weak var newAnimeContainerView: UIView!

  /// # Properties
  var requestsManager: RequestProtocol

  /// # NavigationBar
  lazy var navigationBar: ScreenNavigationBar = NewAnimeNavigationBar(self)

  /// # Init
  init(requestsManager: RequestProtocol) {
    self.requestsManager = requestsManager
    super.init(nibName: Xibs.newAnimeScreenView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NewAnimeScreen {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureScreen()
    print("Height: \(view.frame.size.height)")
    print("Width: \(view.frame.size.width)")
  }
}

extension NewAnimeScreen {
  func configureScreen() {
    configureNavigationItems()
    configureScreenComponents()
  }
}

private extension NewAnimeScreen {
  // TODO: Configure UIScrollView
  func configureScreenComponents() {
    /// # Components
    let newAnimeSearchBarComponent: ScreenComponent = NewAnimeSearchBarComponent()
    let newAnimeSearchResultsComponent: ScreenComponent = NewAnimeSearchResultsComponent()

    /// # Add Screen's Components
    addChildVC(newAnimeSearchBarComponent)
    addChildVC(newAnimeSearchResultsComponent)
    print("Child VCs: \(children)")

    /// # Configure Component's constraints
    configureComponentsConstraints(
      newAnimeSearchBarComponent,
      newAnimeSearchResultsComponent
    )
  }

  func configureComponentsConstraints(
    _ newAnimeSearchBar: ScreenComponent,
    _ newAnimeSearchResults: ScreenComponent
  ) {
    /// # NewAnimeSearchBarComponent
    let newAnimeSearchBarView: UIView = newAnimeSearchBar.view
    newAnimeSearchBarView.translatesAutoresizingMaskIntoConstraints = false
    /// Constraints
    NSLayoutConstraint.activate([
      newAnimeSearchBarView.topAnchor.constraint(equalTo: newAnimeContainerView.topAnchor, constant: 20),
      newAnimeSearchBarView.heightAnchor.constraint(equalTo: newAnimeContainerView.heightAnchor, multiplier: 0.09),
      newAnimeSearchBarView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
      newAnimeSearchBarView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
    ])

    /// # NewAnimeSearchResultsComponent
    let newAnimeSearchResultsView: UIView = newAnimeSearchResults.view
    newAnimeSearchResultsView.translatesAutoresizingMaskIntoConstraints = false
    /// Constraints
    NSLayoutConstraint.activate([
      newAnimeSearchResultsView.topAnchor.constraint(equalTo: newAnimeSearchBarView.bottomAnchor, constant: 20),
      newAnimeSearchResultsView.heightAnchor.constraint(equalTo: newAnimeContainerView.heightAnchor, multiplier: 0.35),
      newAnimeSearchResultsView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
      newAnimeSearchResultsView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
    ])
  }
}

extension NewAnimeScreen {
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

extension NewAnimeScreen: RootViewController {
  func getRootViewController() -> UIViewController {
    return CustomNavigationController(self)
  }
}

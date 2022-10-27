//
//  NewScheduledAnimeScreen.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/04/22.
//

import Foundation
import UIKit

// TODO: Conform ComponentContainer protocol
final class NewAnimeScreen: UIViewController, Screen {
  /// # IBOutlets
  @IBOutlet private weak var newAnimeContainerView: UIView!
  @IBOutlet private weak var newAnimeScrollView: UIScrollView!

  /// # Components
  private lazy var newAnimeSearchResultsComponent: NewAnimeSearchResultsComponent = {
    let searchResults = NewAnimeSearchResultsComponent()
    return searchResults
  }()

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
//    print("Height: \(view.frame.size.height)")
//    print("Width: \(view.frame.size.width)")
  }
}

private extension NewAnimeScreen {
  func configureScreen() {
    configureNavigationItems()
    configureScreenComponents()
    newAnimeScrollView.delegate = self
  }
}

// MARK: - Configure child components
private extension NewAnimeScreen {
  func configureScreenComponents() {
    /// # Components
    let newAnimeSearchBarComponent: ScreenComponent = NewAnimeSearchBarComponent()
    let newAnimeSelectedTitleComponent: ScreenComponent = NewAnimeSelectedTitleComponent()
    let newAnimeSelectedDetailsComponent: ScreenComponentContainer = NewAnimeSelectedDetailsComponentContainer()

    /// # Add Screen's Components
    addChildVC(newAnimeSearchBarComponent)
    addChildVC(newAnimeSearchResultsComponent)
    addChildVC(newAnimeSelectedTitleComponent)
    addChildVC(newAnimeSelectedDetailsComponent)
    print("NewAnimeScreen children VCs: \(children)")

    /// # Configure Component's constraints
    configureComponentsConstraints(
      newAnimeSearchBarComponent,
      newAnimeSearchResultsComponent,
      newAnimeSelectedTitleComponent,
      newAnimeSelectedDetailsComponent
    )
  }
}

// MARK: - Constraints
private extension NewAnimeScreen {
  func configureComponentsConstraints(
    _ newAnimeSearchBar: ScreenComponent,
    _ newAnimeSearchResults: ScreenComponent,
    _ newAnimeSelectedTitle: ScreenComponent,
    _ newAnimeSelectedDetails: ScreenComponentContainer
  ) {
    /// # NewAnimeSearchBarComponent
    let newAnimeSearchBarView: UIView = newAnimeSearchBar.view
    newAnimeSearchBarView.translatesAutoresizingMaskIntoConstraints = false
    /// Constraints
    NSLayoutConstraint.activate([
      newAnimeSearchBarView.topAnchor.constraint(equalTo: newAnimeContainerView.topAnchor, constant: 15),
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
      newAnimeSearchResultsView.heightAnchor.constraint(equalToConstant: 300.0),
      newAnimeSearchResultsView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
      newAnimeSearchResultsView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
    ])

    /// # NewAnimeSeletedTitleComponent
    let newAnimeSelectedTitleView: UIView = newAnimeSelectedTitle.view
    newAnimeSelectedTitleView.translatesAutoresizingMaskIntoConstraints = false
    /// Constraints
    NSLayoutConstraint.activate([
      newAnimeSelectedTitleView.topAnchor.constraint(equalTo: newAnimeSearchResultsView.bottomAnchor, constant: 20),
      newAnimeSelectedTitleView.heightAnchor.constraint(equalTo: newAnimeContainerView.heightAnchor, multiplier: 0.1),
      newAnimeSelectedTitleView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
      newAnimeSelectedTitleView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
    ])

    /// # NewAnimeDetailsComponent
    let newAnimeSelectedDetailsView: UIView = newAnimeSelectedDetails.view
    newAnimeSelectedDetailsView.translatesAutoresizingMaskIntoConstraints = false
    /// Constraints
    NSLayoutConstraint.activate([
      newAnimeSelectedDetailsView.topAnchor.constraint(equalTo: newAnimeSelectedTitleView.bottomAnchor, constant: 20),
      newAnimeSelectedDetailsView.heightAnchor.constraint(equalTo: newAnimeContainerView.heightAnchor, multiplier: 0.1),
      newAnimeSelectedDetailsView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
      newAnimeSelectedDetailsView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
    ])
  }
}

// MARK: - ScrollView delegate & datasource
extension NewAnimeScreen: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // cancel scrollview scrolling
    print("new-anime: scrollViewDidScroll")
    newAnimeSearchResultsComponent.resetCollectionOffset()
  }
}

// MARK: - Navigation Items
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

// MARK: - RootViewController
extension NewAnimeScreen: RootViewController {
  func getRootViewController() -> UIViewController {
    return CustomNavigationController(self)
  }
}

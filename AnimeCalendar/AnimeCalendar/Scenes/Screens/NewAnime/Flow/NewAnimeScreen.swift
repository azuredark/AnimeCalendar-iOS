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
    // MARK: State
    /// # IBOutlets
    @IBOutlet private weak var newAnimeContainerView: UIView!
    @IBOutlet private weak var newAnimeScrollView: UIScrollView!

    /// # Presenter
    private weak var presenter: NewAnimePresentable?

    /// # NavigationBar
    private lazy var navigationBar: ScreenNavigationBar = NewAnimeNavigationBar(self)

    /// # Components
    private lazy var searchBarComponent: NewAnimeSearchBarComponent = {
        let component = NewAnimeSearchBarComponent(presenter: presenter)
        return component
    }()

    private lazy var searchResultsComponent: NewAnimeSearchResultsComponent = {
        let component = NewAnimeSearchResultsComponent(presenter: presenter)
        return component
    }()

    private lazy var selectedTitleComponent: NewAnimeSelectedTitleComponent = {
        let component = NewAnimeSelectedTitleComponent()
        return component
    }()
    
    private lazy var selectedDetailsComponent: NewAnimeSelectedDetailsComponentContainer = {
        let component = NewAnimeSelectedDetailsComponentContainer()
        return component
    }()

    // MARK: Initializers
    init(presenter: NewAnimePresentable) {
        super.init(nibName: Xibs.newAnimeScreenView, bundle: Bundle.main)
        configureTabItem()
        self.presenter = presenter
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
    // TODO: Refactor, add them directly as lazy components
    func configureScreenComponents() {

        /// # Add Screen's Components
        addChildVC(searchBarComponent)
        addChildVC(searchResultsComponent)
        addChildVC(selectedTitleComponent)
        addChildVC(selectedDetailsComponent)

        /// # Configure Component's constraints
        configureComponentsConstraints()
    }
}

// MARK: - Constraints
private extension NewAnimeScreen {
    func configureComponentsConstraints() {
        /// # NewAnimeSearchBarComponent
        let newAnimeSearchBarView: UIView = searchBarComponent.view
        newAnimeSearchBarView.translatesAutoresizingMaskIntoConstraints = false
        /// Constraints
        NSLayoutConstraint.activate([
            newAnimeSearchBarView.topAnchor.constraint(equalTo: newAnimeContainerView.topAnchor, constant: 15),
            newAnimeSearchBarView.heightAnchor.constraint(equalTo: newAnimeContainerView.heightAnchor, multiplier: 0.09),
            newAnimeSearchBarView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
            newAnimeSearchBarView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
        ])

        /// # NewAnimeSearchResultsComponent
        let newAnimeSearchResultsView: UIView = searchResultsComponent.view
        newAnimeSearchResultsView.translatesAutoresizingMaskIntoConstraints = false
        /// Constraints
        NSLayoutConstraint.activate([
            newAnimeSearchResultsView.topAnchor.constraint(equalTo: newAnimeSearchBarView.bottomAnchor, constant: 20),
            newAnimeSearchResultsView.heightAnchor.constraint(equalToConstant: 300.0),
            newAnimeSearchResultsView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
            newAnimeSearchResultsView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
        ])

        /// # NewAnimeSeletedTitleComponent
        let newAnimeSelectedTitleView: UIView = selectedTitleComponent.view
        newAnimeSelectedTitleView.translatesAutoresizingMaskIntoConstraints = false
        /// Constraints
        NSLayoutConstraint.activate([
            newAnimeSelectedTitleView.topAnchor.constraint(equalTo: newAnimeSearchResultsView.bottomAnchor, constant: 20),
            newAnimeSelectedTitleView.heightAnchor.constraint(equalTo: newAnimeContainerView.heightAnchor, multiplier: 0.1),
            newAnimeSelectedTitleView.leadingAnchor.constraint(equalTo: newAnimeContainerView.leadingAnchor),
            newAnimeSelectedTitleView.trailingAnchor.constraint(equalTo: newAnimeContainerView.trailingAnchor),
        ])

        /// # NewAnimeDetailsComponent
        let newAnimeSelectedDetailsView: UIView = selectedDetailsComponent.view
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
        searchResultsComponent.resetCollectionOffset()
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

// MARK: - TabBar item
extension NewAnimeScreen: ScreenWithTabItem {
    func configureTabItem() {
        let configuration = UIImage.SymbolConfiguration(weight: UIImage.SymbolWeight.medium)
        let icon = ACIcon.magnifyingglass
            .withConfiguration(configuration)
        
        tabBarItem = UITabBarItem(title: "Search", image: icon, selectedImage: icon)
    }
}

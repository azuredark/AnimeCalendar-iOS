//
//  NewAnimeSelectedDetailsContainer.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 16/06/22.
//

import UIKit

final class NewAnimeSelectedDetailsComponentContainer: UIViewController, ScreenComponentContainer {
  /// # Components
  internal var components = [ScreenComponent?]()

  private var newAnimeSelectedEpisodesComponent: ScreenComponent?
  private var newAnimeSelectedTimeComponent: ScreenComponent?
  private var newAnimeSelectedTypeComponent: ScreenComponent?

  /// # Init
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - LifeCycle
extension NewAnimeSelectedDetailsComponentContainer {
  override func viewDidLoad() {
    configureComponent()
  }
}

// MARK: - Configure child components
extension NewAnimeSelectedDetailsComponentContainer {
  func configureChildComponents(_ children: [ScreenComponent?]) {
    children.forEach { component in
      guard let component = component else { return }
      component.view.translatesAutoresizingMaskIntoConstraints = false
      self.addChildVC(component)
    }
  }
}

// MARK: - Component
extension NewAnimeSelectedDetailsComponentContainer: Component {
  /// # Configure child components
  func configureComponent() {
    newAnimeSelectedEpisodesComponent = NewAnimeSelectedEpisodesComponent()
    newAnimeSelectedTimeComponent = NewAnimeSelectedTimeComponent()
    newAnimeSelectedTypeComponent = NewAnimeSelectedTypeComponent()

    components = [
      newAnimeSelectedEpisodesComponent,
      newAnimeSelectedTimeComponent,
      newAnimeSelectedTypeComponent
    ]

    configureChildComponents(components)
    configureView()
  }

  func configureView() {
    view.backgroundColor = Color.pink
    configureSubviews()
  }

  // MARK: - Configure Subviews
  func configureSubviews() {
    guard let newAnimeEpisodesView = newAnimeSelectedEpisodesComponent?.view else { return }
    guard let newAnimeTimeView = newAnimeSelectedTimeComponent?.view else { return }
    guard let newAnimeTypeView = newAnimeSelectedTypeComponent?.view else { return }

    newAnimeEpisodesView.backgroundColor = .systemGreen
    newAnimeTimeView.backgroundColor = .systemBlue
    newAnimeTypeView.backgroundColor = .systemRed

    /// # NewAnimeEpisodes
    NSLayoutConstraint.activate([
      newAnimeEpisodesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      newAnimeEpisodesView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
      newAnimeEpisodesView.topAnchor.constraint(equalTo: view.topAnchor),
      newAnimeEpisodesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    /// # NewAnimeTime
    NSLayoutConstraint.activate([
      newAnimeTimeView.leadingAnchor.constraint(equalTo: newAnimeEpisodesView.trailingAnchor),
      newAnimeTimeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
      newAnimeTimeView.topAnchor.constraint(equalTo: view.topAnchor),
      newAnimeTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    /// # NewAnimeType
    NSLayoutConstraint.activate([
      newAnimeTypeView.leadingAnchor.constraint(equalTo: newAnimeTimeView.trailingAnchor),
      newAnimeTypeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      newAnimeTypeView.topAnchor.constraint(equalTo: view.topAnchor),
      newAnimeTypeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

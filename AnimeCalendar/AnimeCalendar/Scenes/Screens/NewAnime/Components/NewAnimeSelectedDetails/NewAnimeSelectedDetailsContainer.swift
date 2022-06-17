//
//  NewAnimeSelectedDetailsContainer.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 16/06/22.
//

import UIKit

final class NewAnimeSelectedDetailsComponentContainer: UIViewController, ScreenComponentContainer {
  /// # Components
  internal var components = [ScreenComponent]()

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
  func configureChildComponents(_ children: [ScreenComponent]) {
    children.forEach { self.addChildVC($0) }
  }
}

// MARK: - Component
extension NewAnimeSelectedDetailsComponentContainer: Component {
  /// # Configure child components
  func configureComponent() {
    let newAnimeSelectedEpisodesComponent: ScreenComponent = NewAnimeSelectedEpisodesComponent()
    let newAnimeSelectedTimeComponent: ScreenComponent = NewAnimeSelectedTimeComponent()
    let newAnimeSelectedTypeComponent: ScreenComponent = NewAnimeSelectedTypeComponent()

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

  // TODO: Room for improvement
  func configureSubviews() {
    guard let newAnimeEpisodes = components[0] as? NewAnimeSelectedEpisodesComponent,
          let newAnimeEpisodesView = newAnimeEpisodes.view else { return }

    guard let newAnimeTime = components[1] as? NewAnimeSelectedTimeComponent,
          let newAnimeTimeView = newAnimeTime.view else { return }

    guard let newAnimeType = components[2] as? NewAnimeSelectedTypeComponent,
          let newAnimeTypeView = newAnimeType.view else { return }

    newAnimeEpisodesView.backgroundColor = .systemGreen
    newAnimeTimeView.backgroundColor = .systemBlue
    newAnimeTypeView.backgroundColor = .systemRed

    /// # NewAnimeEpisodes
    newAnimeEpisodesView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newAnimeEpisodesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      newAnimeEpisodesView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),
      newAnimeEpisodesView.topAnchor.constraint(equalTo: view.topAnchor),
      newAnimeEpisodesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    /// # NewAnimeTime
    newAnimeTimeView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newAnimeTimeView.leadingAnchor.constraint(equalTo: newAnimeEpisodesView.trailingAnchor),
      newAnimeTimeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
      newAnimeTimeView.topAnchor.constraint(equalTo: view.topAnchor),
      newAnimeTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    /// # NewAnimeType
    newAnimeTypeView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      newAnimeTypeView.leadingAnchor.constraint(equalTo: newAnimeTimeView.trailingAnchor),
      newAnimeTypeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      newAnimeTypeView.topAnchor.constraint(equalTo: view.topAnchor),
      newAnimeTypeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

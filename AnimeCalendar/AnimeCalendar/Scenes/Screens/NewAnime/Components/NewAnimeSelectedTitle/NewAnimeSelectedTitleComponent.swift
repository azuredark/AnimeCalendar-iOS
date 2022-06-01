//
//  NewAnimeSelectedTitleComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 31/05/22.
//

import UIKit

final class NewAnimeSelectedTitleComponent: UIViewController, ScreenComponent {
  /// # Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var titleContainerView: UIView!
  @IBOutlet private weak var titleTextField: NewAnimeTitleTextField!
  @IBOutlet private weak var titleIconImage: UIImageView!
  /// # Properties
  /// # Observables
  /// # Init
  init() {
    super.init(nibName: Xibs.newAnimeSelectedTitleComponentView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit { print("\(self) deinited") }
}

extension NewAnimeSelectedTitleComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureComponent()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("Title Height: \(view.frame.size.height)")
    print("Title Width: \(view.frame.size.width)")
  }
}

extension NewAnimeSelectedTitleComponent: Component {
  func configureComponent() {
    configureView()
  }

  func configureView() {
    view.backgroundColor = Color.cream
    configureSubviews()
  }

  func configureSubviews() {
    titleLabel.textColor = Color.black
    titleTextField.backgroundColor = Color.white

    titleContainerView.backgroundColor = Color.white
    titleContainerView.addCornerRadius(radius: 5)
  }
}

//
//  HomeDateComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/05/22.
//

import UIKit

final class HomeDateComponent: UIViewController {
  /// # Outlets
  @IBOutlet private weak var currentDateView: UIView!
  @IBOutlet private weak var currentDateLabel: UILabel!
  @IBOutlet private weak var dayBeforeView: UIView!
  @IBOutlet private weak var dayBeforeImage: UIImageView!
  @IBOutlet private weak var dayAfterView: UIView!
  @IBOutlet private weak var dayAfterImage: UIImageView!

  init() {
    super.init(nibName: Xibs.homeDateComponentView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeDateComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
}

extension HomeDateComponent: ScreenComponent {
  func configureView() {
    let currentDateShadow = Shadow(
      radius: 3,
      offset: CGSize(width: -0.5, height: 5),
      opacity: 0.8,
      color: Color.pink)

    currentDateView.addShadowLayer(shadow: currentDateShadow, layerRadius: 15)
  }

  func configureSubviews() {}
}

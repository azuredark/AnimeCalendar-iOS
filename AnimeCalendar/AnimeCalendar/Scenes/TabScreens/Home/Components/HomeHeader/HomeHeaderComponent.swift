//
//  HomeHeaderComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/04/22.
//

import UIKit

final class HomeHeaderComponent: UIViewController {
  /// # Outlets
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var animesToWatchLabel: UILabel!
  @IBOutlet private weak var dateLabel: UILabel!
  @IBOutlet private weak var pictureImage: UIImageView!
  @IBOutlet private weak var pictureView: UIView!

  /// # Flags
  private var shadowFlag: Bool = false

  let cornerRadius: CGFloat = 15

  init() {
    super.init(nibName: Xibs.homeHeaderComponentView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeHeaderComponent {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !shadowFlag {
      configureShadows()
      shadowFlag = true
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    shadowFlag = false
  }
}

private extension HomeHeaderComponent {
  func configureView() {
    view.backgroundColor = Color.cream
    configureSubviews()
  }

  func configureSubviews() {
    /// # Working with 2 UIViews
    configurePictureView()
    configurePictureImage()
  }

  func configurePictureView() {
    // PictureView
    let pictureViewShadow = Shadow()
    pictureView.addShadowLayer(shadow: pictureViewShadow, layerRadius: cornerRadius)
  }

  func configurePictureImage() {
    // PictureImage
    pictureImage.addCornerRadius(radius: cornerRadius)
  }

  func configureShadows() {
//    let pictureViewShadow = Shadow()
//    pictureView.superview?.layoutIfNeeded()
//    pictureView.addShadowAndCornerRadius(shadow: pictureViewShadow, cornerRadius: 15, fillColor: .clear)
  }
}

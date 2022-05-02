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

  private let cornerRadius: CGFloat = 15

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
}

extension HomeHeaderComponent: ScreenComponent {
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
}

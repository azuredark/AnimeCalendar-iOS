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
    configureAnimesToWatchLabel()
    configurePictureView()
    configurePictureImage()
  }
}

extension HomeHeaderComponent {
  func configureAnimesToWatchLabel() {
    guard let text = animesToWatchLabel.text else { fatalError("AnimesToWatchLabel is empty") }

    let animesCountColorAttribute: UIColor = Color.pink
    let animesCountFontAttribute = UIFont.systemFont(ofSize: 14, weight: .heavy)

    let animesCountAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: animesCountColorAttribute,
      .font: animesCountFontAttribute
    ]

    let animesCountMutableText = NSMutableAttributedString(string: text)
    animesCountMutableText.addAttributes(animesCountAttributes, range: NSRange(location: 11, length: 8))
    animesToWatchLabel.attributedText = animesCountMutableText
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

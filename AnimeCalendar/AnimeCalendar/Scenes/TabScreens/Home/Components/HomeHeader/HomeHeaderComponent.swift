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
//  @IBOutlet private weak var pictureView: UIView!

  /// # Flags
  private var shadowFlag: Bool = false

  let backgroundColor: UIColor = Color.hex("#F7F5F2")

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
    view.backgroundColor = backgroundColor
    configureSubviews()

//    pictureView.clipsToBounds = true
//    pictureView.layer.cornerRadius = 15
//    view.layer.cornerRadius = 15
  }

  func configureSubviews() {
    /// # Working with 2 UIViews
    // PictureImage
    pictureImage.isHidden = false
    pictureImage.image
//    pictureImage.image = nil
//    pictureImage.clipsToBounds = true
//    pictureImage.layer.cornerRadius = 15
//
//    // PictureView
//    pictureView.backgroundColor = UIColor.systemPink
//    pictureView.layer.cornerRadius = 15
//    pictureView.layer.shadowColor = UIColor.darkGray.cgColor
//    pictureView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
//    pictureView.layer.shadowRadius = 5
//    pictureView.layer.shadowOpacity = 0.5
//    pictureView.layer.shadowPath = UIBezierPath(roundedRect: pictureImage.bounds, cornerRadius: 15).cgPath
  }

  func configureShadows() {
    let pictureViewShadow = Shadow()
    pictureImage.superview?.layoutIfNeeded()
    pictureImage.addShadowAndCornerRadius(shadow: pictureViewShadow, cornerRadius: 15, fillColor: .systemPink)
  }
}

//
//  TopAnimeCellV2.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 2/06/23.
//

import UIKit

final class TopAnimeCellV2: UICollectionViewCell, FeedCell {
    // MARK: State
    private let borderWidth: CGFloat = 2.0
    private var needsUpdate: Bool = false
    
    private var themeColor: UIColor? {
        didSet {
            Task { @MainActor in
                needsUpdate = true
                
                contentView.layer.borderColor = themeColor?.cgColor
                
                gradientLayer?.removeFromSuperlayer()
                gradientLayer = nil
                applyOverlay(gradientColor: themeColor ?? Color.white)
                
                contentView.layoutIfNeeded()
                contentView.layer.layoutIfNeeded()
            }
        }
    }
    
    private var gradientLayer: CAGradientLayer?
    private var titleShadowLayer: CALayer?
    
    weak var anime: Anime?
    
    private lazy var coverImageContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        contentView.addSubview(view)
        return view
    }()

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        
        coverImageContainerView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ACFont.normal
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = Color.staticWhite
        
        // Shadow
        label.layer.shadowColor = Color.staticBlack.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false

        contentView.insertSubview(label, aboveSubview: coverImageContainerView)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        coverImageView.image = nil
        
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.layoutIfNeeded()
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard needsUpdate else { return }
        needsUpdate = false
    }
    
    // MARK: Methods
    func setup() {
        titleLabel.text = anime?.titleEng
        
        let imgPath = anime?.imageType?.webpImage.attemptToGetImageByResolution(.large)
        coverImageView.loadImage(from: imgPath, cellType: self) { [weak self] (img, _) in
            if let themeColor = self?.anime?.imageType?.themeColor {
                self?.themeColor = themeColor; return
            }
            
            img?.getThemeColor(completion: { color in
                self?.anime?.imageType?.themeColor = color
                self?.themeColor = color
            })
        }
    }
    
    func getCoverImage() -> UIImage? {
        return coverImageView.image
    }
}

private extension TopAnimeCellV2 {
    func layoutUI() {
        backgroundColor = .clear
        
        layoutContentView()
        
        layoutCoverImageViewContainer()
        layoutCoverImageView()
        
        layoutTitleLabel()
    }
    
    func layoutContentView() {
        contentView.addCornerRadius(radius: 10.0)
        contentView.backgroundColor = Color.white
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = borderWidth
        contentView.layer.borderColor = Color.white.cgColor
    }
    
    func layoutCoverImageViewContainer() {
        coverImageView.fitViewTo(coverImageContainerView)
    }
    
    func layoutCoverImageView() {
        coverImageContainerView.fitViewTo(contentView)
    }

    func layoutTitleLabel() {
        let padding: CGFloat = 5.0 + borderWidth
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
}

extension TopAnimeCellV2 {
    func applyOverlay(gradientColor: UIColor) {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.clear.cgColor, gradientColor.cgColor]
        gradient.locations = [0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = contentView.bounds
        
        contentView.layer.insertSublayer(gradient, above: coverImageContainerView.layer)
        
        gradientLayer = gradient
    }
}

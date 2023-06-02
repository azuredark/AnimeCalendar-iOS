//
//  ACSectionLoaderCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/06/23.
//

import UIKit

final class ACSectionLoaderCell: UICollectionViewCell, CellReusable {
    // MARK: State
    private lazy var stackView: UIStackView = {
        let stack = ACStack(axis: .horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20.0
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .clear

        contentView.addSubview(stack)
        return stack
    }()

    private var spinnerView: UIActivityIndicatorView?
    private var iconImageView: UIImageView?
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        iconImageView?.removeFromSuperview()
        iconImageView = nil
        
//        spinnerView?.stopAnimating()
//        spinnerView = nil
    }

    // MARK: Methods
    func setup(with model: ACSectionLoaderModel) {
        configureContentView(with: model)
        configureStackView(with: model)
        configureIconImageView(with: model)
        
        startSpinner()
    }
}

// MARK: - Configure UI
private extension ACSectionLoaderCell {
    func configureContentView(with model: ACSectionLoaderModel) {
        if contentView.backgroundColor == nil { contentView.backgroundColor = model.bgColor }
        contentView.layer.cornerRadius = model.cornerRadius
    }
    
    func configureStackView(with model: ACSectionLoaderModel) {
        // Spinner
        layoutSpinnerView(with: model)
        
        // Text
        layoutTextLabel(with: model)
    }
    
    func configureIconImageView(with model: ACSectionLoaderModel) {
        layoutIconImageView(with: model)
    }
    
    func startSpinner() {
        guard let spinnerView else { return }
        if !spinnerView.isAnimating {
            spinnerView.startAnimating()
        }
    }

}

// MARK: - Layout UI
private extension ACSectionLoaderCell {
    func layoutUI() {
        backgroundColor = .clear
        layoutStackView()
    }

    func layoutStackView() {
        let xPadding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    func layoutTextLabel(with model: ACSectionLoaderModel) {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = model.font
        label.textColor = model.textColor
        label.text = model.text
        
        stackView.addArrangedSubview(label)
    }
    
    func layoutSpinnerView(with model: ACSectionLoaderModel) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = model.spinnerColor
        
        stackView.addArrangedSubview(spinner)
        
        spinnerView = spinner
    }
        
    func layoutIconImageView(with model: ACSectionLoaderModel) {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = model.icon
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        
        let width: CGFloat = 30.0
        let height: CGFloat = 20.0
        
        contentView.addSubview(imageView)
        
        let xPadding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -xPadding),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        iconImageView = imageView
    }
}

// MARK: - Model
struct ACSectionLoaderModel {
    var icon = UIImage()
    var text: String = ""
    var font: UIFont = ACFont.bold.sectionTitle2
    var iconColor: UIColor = Color.lightGray
    var textColor: UIColor = Color.lightGray
    var bgColor: UIColor = Color.cobalt.withAlphaComponent(0.2)
    var spinnerColor: UIColor = Color.lightGray
    var cornerRadius: CGFloat = 10.0

    init(detailSection: DetailFeedSection) {
        configureModel(with: detailSection)
    }
}

private extension ACSectionLoaderModel {
    mutating func configureModel(with section: DetailFeedSection) {
        switch section {
            case .animeCharacters:
                text = "Characters"
                icon = ACIcon.peopleFilled.withTintColor(iconColor, renderingMode: .alwaysOriginal)
            case .animeReviews:
                text = "Reviews"
                icon = ACIcon.textQuote.withTintColor(iconColor, renderingMode: .alwaysOriginal)
            case .animeRecommendations:
                text = "Recommendations"
                icon = ACIcon.tv.withTintColor(iconColor, renderingMode: .alwaysOriginal)
            default: break
        }
    }
}

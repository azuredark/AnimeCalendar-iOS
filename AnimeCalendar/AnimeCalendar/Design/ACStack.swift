//
//  ACStack.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 18/12/22.
//

import UIKit

final class ACStack: UIStackView {
    private var components = [ACStackItem]() {
        didSet { configure() }
    }

    init(axis: NSLayoutConstraint.Axis,
         frame: CGRect = .zero) {
        super.init(frame: frame)
        self.axis = axis
        self.contentMode = .center
        self.alignment = .center
        self.spacing = 2.0
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Setup with pre-defined components
    func setup(with components: [ACStackItem]) {
        self.components = components
    }
    
    /// Deletes the arranged superviews
    func reset() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: Private methods
private extension ACStack {
    func configure() {
        components.forEach { [weak self] component in
            guard let self = self else { return }
            switch component {
                case .icon(let image):
                    self.layoutImageView(with: image, color: Color.cream)
                case .text(let text):
                    self.layoutText(text: text, color: Color.cream, alignment: .center)
                case .image: break
                case .spacer:
                    self.layoutSpacer(size: CGSize(width: 8.0, height: 0))
            }
        }
    }

    /// Layout image view.
    @discardableResult
    func layoutImageView(with image: UIImage, color: UIColor) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = color
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 14.0)
        ])
        
        addArrangedSubview(imageView)
        return imageView
    }
    
    /// Layout text label.
    @discardableResult
    func layoutText(text: String, color: UIColor, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = color
        label.textAlignment = alignment
        label.font = .systemFont(ofSize: 12, weight: .medium)
        
        addArrangedSubview(label)
        return label
    }
    
    func layoutSpacer(size: CGSize) {
        let view = UIView(frame: .zero)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: size.width)
        ])
        
        addArrangedSubview(view)
    }
}

/// Closure alias for async images.
typealias AsyncImage = (UIImage?) -> Void

/// Items for the ACStack component
enum ACStackItem {
    case icon(UIImage)
    case text(String)
    case image(AsyncImage)
    case spacer
}

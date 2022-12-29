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
                case .text(let text, let style):
                    self.layoutText(text, style: style)
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
    func layoutText(_ value: String, style: Text) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = style.lines
        label.text = value
        label.textColor = style.textColor
        label.textAlignment = style.alignment
        label.font = style.font

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

extension ACStack {
    struct Text {
        var lines: Int = 0
        var alignment: NSTextAlignment = .left
        var textColor: UIColor = Color.cream
        var font: UIFont = .systemFont(ofSize: 12, weight: .medium)

        init(lines: Int, alignment: NSTextAlignment, textColor: UIColor, font: UIFont) {
            self.lines = lines
            self.alignment = alignment
            self.textColor = textColor
            self.font = font
        }

        init() {}
    }
}

/// Closure alias for async images.
typealias AsyncImage = (UIImage?) -> Void

/// Items for the ACStack component
enum ACStackItem {
    case icon(UIImage)
    case text(value: String, style: ACStack.Text)
    case image(AsyncImage)
    case spacer
}

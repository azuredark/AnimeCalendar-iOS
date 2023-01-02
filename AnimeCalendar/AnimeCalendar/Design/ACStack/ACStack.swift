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

    /// Setup with pre-defined components.
    func setup(with components: [ACStackItem]) {
        self.components = components
    }

    /// Deletes the arranged subviews.
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
                case .icon(let icon):
                    self.layoutImageView(with: icon)
                case .text(let text, let style):
                    self.layoutText(text, style: style)
                case .image: break
                case .spacer(let spacer, let space):
                    self.layoutSpacer(spacer, space: space)
            }
        }
        print("senku [DEBUG] \(String(describing: type(of: self))) - All arranged subviews #: \(arrangedSubviews.count)")
    }

    /// Layout image view.
    @discardableResult
    func layoutImageView(with icon: ACStack.Image) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        if let color = icon.tint {
            imageView.image = icon.image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        } else {
            imageView.image = icon.image
        }

        // Depending on the **axis** either the **height** or **width** will **not** be set.
        // As the **contentMode** is set to **.scaleAspectFit**.
        if let width = icon.size.width, width != .zero {
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = icon.size.height, height != .zero {
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

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

    /// Creates an empty view which serves as a *spacer*.
    ///
    /// - Warning: This will apply the **space** to both the **previous** and **next** neighbors.
    /// Meaning it will be applied **twice** in total, once per each **neighbor**.
    /// - Parameter size: Size of the spacer.
    func layoutSpacer(_ spacer: SpacerType, space: CGFloat) {
        var currentView: UIView?

        switch spacer {
            case .empty:
                currentView = layoutEmptySpacerView(space: space)
            case .circle(let tint):
                let image = ACStack.Image(image: ACIcon.circleFilled,
                                          tint: tint,
                                          size: .init(width: 5.0, height: 5.0))
                currentView = layoutImageView(with: image)
        }

        // Add custom spacing
        guard let currentView = currentView else { return }

        let neighbors: [SpacingNeighbor] = [.previous(spacing: space),
                                            .next(spacing: space)]
        addCustomSpacing(from: currentView, neighbors: neighbors)
    }

    /// Lays out an **empty** view with size **zero** as it will only be used to add custom spacing to it.
    @discardableResult
    func layoutEmptySpacerView(space: CGFloat) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(view)
        return view
    }
}

/// Closure alias for async images.
typealias AsyncImage = (UIImage?) -> Void

enum SpacerType {
    case empty
    case circle(tint: UIColor?)
}

/// Items for the ACStack component
enum ACStackItem {
    case icon(image: ACStack.Image)
    case text(value: String, style: ACStack.Text)
    case image(AsyncImage)
    /// Should always be in the **middle** of other 2 items.
    case spacer(type: SpacerType, space: CGFloat)
}

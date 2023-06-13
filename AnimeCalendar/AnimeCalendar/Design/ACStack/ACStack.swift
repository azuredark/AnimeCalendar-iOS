//
//  ACStack.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 18/12/22.
//

import UIKit

protocol ACStackable {
    var stack: ACStack { get }
    func getStack() -> ACStack
    func reset()
}

extension ACStackable {
    func reset() {
        stack.reset()
    }

    func getStack() -> ACStack {
        return stack
    }
}

final class ACStack: UIStackView, ACUIDesignable {
    private typealias AccessId = ACStackIdentifiers
    private var components = [ACStackItem]() {
        didSet { configure() }
    }

    init() {
        super.init(frame: .zero)
        self.accessibilityIdentifier = AccessId.stack
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
            guard let self else { return }
            switch component {
                case .icon(let icon):
                    self.layoutImageView(with: icon)
                case .text(let text, let style):
                    self.layoutText(text, style: style)
                case .image: break
                case .spacer(let spacer, let space):
                    self.layoutSpacer(spacer, space: space)
                case .customView(let view, let callback):
                    self.layoutCustomView(with: view, callback: callback)
            }
        }
    }

    /// Layout image view.
    @discardableResult
    func layoutImageView(with image: ACStack.Image) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = AccessId.imageView
        imageView.contentMode = .scaleAspectFit

        if let color = image.tint {
            imageView.image = image.image.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = color
        } else {
            imageView.image = image.image
        }
        
        var constraints: [NSLayoutConstraint] = []
        
        if let width = image.size.width {
            constraints.append(imageView.widthAnchor.constraint(equalToConstant: width))
        }
        
        if let height = image.size.height {
            constraints.append(imageView.heightAnchor.constraint(equalToConstant: height))
        }
        
        /// **This is important to prevent AutoLayout warnings.**
        constraints.forEach { $0.priority = .init(999) }
        
        NSLayoutConstraint.activate(constraints)
        
        addArrangedSubview(imageView)
        
        return imageView
    }

    /// Layout text label.
    @discardableResult
    func layoutText(_ value: String, style: Text) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = AccessId.text
        label.numberOfLines = style.lines
        label.text = value
        label.textColor = style.textColor
        label.textAlignment = style.alignment
        label.font = style.font

        addArrangedSubview(label)
        style.callback?(label, self)
        return label
    }

    /// Add custom view to the **arranged suviews** stack.
    ///
    /// - Warning: The customView **must** have either *intrinsic size* or *fixed height & width*.
    /// - Parameter view: The custom view to add to the stack.
    func layoutCustomView(with view: UIView, callback: ViewCallback? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessId.customView
        addArrangedSubview(view)
        callback?(view, self)
    }

    /// Creates an empty view which serves as a *spacer*.
    ///
    /// - Parameter size: Size of the spacer.
    /// - Parameter space: The space for **EACH** side (Left & Right).
    ///
    /// - Warning: This will apply the **space** to both the **previous** and **next** neighbors **1/2 on EACH**.
    /// If it's the **first** or **last** element of the stack then all the padding will be applied to one neighbor.
    func layoutSpacer(_ spacer: SpacerType, space: CGFloat) {
        var currentView: UIView?

        switch spacer {
            case .empty:
                currentView = layoutEmptySpacerView()
            case .circle(let tint):
                let image = ACStack.Image(image: ACIcon.circleFilled,
                                          tint: tint,
                                          size: .init(width: 5.0, height: 5.0))
                currentView = layoutImageView(with: image)
        }

        // Add custom spacing
        guard let currentView else { return }

        let neighbors: [SpacingNeighbor] = [.previous(spacing: space * 0.5),
                                            .next(spacing: space * 0.5)]
        addCustomSpacing(from: currentView, neighbors: neighbors)
    }

    /// Lays out an **empty** view with size **zero** as it will only be used to add custom spacing to it.
    @discardableResult
    func layoutEmptySpacerView() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = AccessId.spacer
        addArrangedSubview(view)
        return view
    }
}

/// Closure alias for async images.
typealias AsyncImage = (UIImage?) -> Void
typealias ViewCallback = (_ view: UIView, _ stackView: ACStack) -> Void

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
    case customView(UIView, callback: ViewCallback? = nil)
}

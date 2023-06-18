//
//  LabelBoxView.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 17/06/23.
//

import UIKit

final class LabelBoxView: UIView {
    // MARK: Public State
    
    // MARK: Private State
    private var boxConfig: BoxConfig
    private var textConfig: TextConfig
    
    // MARK: UI
    private lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text          = textConfig[\.text]
        label.textColor     = textConfig[\.color]
        label.font          = textConfig[\.font]
        label.numberOfLines = textConfig[\.lines]
        label.textAlignment = .center
        
        insertSubview(label, aboveSubview: self)
        return label
    }()

    // MARK: Initializers
    init(boxConfig: BoxConfig, textConfig: TextConfig) {
        self.boxConfig  = boxConfig
        self.textConfig = textConfig
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        configureBox()
        layoutText()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Config. & Layout
private extension LabelBoxView {
    func configureBox() {
        backgroundColor    = boxConfig[\.backgroundColor]
        layer.borderColor  = boxConfig[\.borderColor]?.cgColor
        layer.borderWidth  = boxConfig[\.borderWidth]
        
        addCornerRadius(radius: boxConfig[\.cornerRadius])
    }
    
    func layoutText() {
        let padding = textConfig[\.innerPadding]
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.left),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding.right),
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding.bottom)
        ])
    }
}

// MARK: - Configurations
extension LabelBoxView {
    struct BoxConfig: Configurable {
        var borderColor: UIColor?
        var borderWidth: CGFloat = .zero
        var cornerRadius: CGFloat = .zero
        var backgroundColor: UIColor?
    }
    
    struct TextConfig: Configurable {
        var text: String
        var color: UIColor?
        var font: UIFont = .systemFont(ofSize: 16.0, weight: .medium)
        var lines: Int = 1
        var innerPadding: UIEdgeInsets = .zero
    }
}

// MARK: - Configurable protocol
protocol Configurable {
    subscript<T>(_ path: KeyPath<Self, T>) -> T { get }
}
        
extension Configurable {
    subscript<T>(_ path: KeyPath<Self, T>) -> T {
        return self[keyPath: path]
    }
}

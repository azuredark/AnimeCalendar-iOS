//
//  BasicInfoCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/12/22.
//

import UIKit

private enum AccessId: String {
    case titleLabel = "title_label"
    case synopsisLabel = "synopsis_label"
}

final class BasicInfoCell: UICollectionViewCell, FeedCell {
    // MARK: State
    static var reuseIdentifier: String = "DETAIL_FEED_BASIC_INFO_CELL_REUSE_ID"

    var anime: Anime? {
        didSet { setupUI() }
    }

    /// Details (Year, score, community, studio, etc)
    ///  ...

    /// Synopsis label.
    private lazy var synopsisLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.textColor = Color.gray
        label.textAlignment = .left
        label.accessibilityIdentifier = AccessId.synopsisLabel.rawValue
        contentView.addSubview(label)
        return label
    }()

    private lazy var mainStack: ACStack = {
        let stack = ACStack(axis: .vertical)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        contentView.addSubview(stack)
        return stack
    }()
    
    // TODO: Add read more mechanisim? That will be banger.

    // MARK: Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        mainStack.reset()
    }

    func setup() {
        mainStack.setup(with: getStackComponents())
    }
}

private extension BasicInfoCell {
    func setupUI() {
        layoutStack()
    }

    func layoutStack() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func getStackComponents() -> [ACStackItem] {
        var components = [ACStackItem]()
        var textStyle = ACStack.Text()
        textStyle.alignment = .left

        if let synopsis = anime?.synopsis {
            textStyle.lines = 5
            textStyle.textColor = Color.gray
            textStyle.font = .systemFont(ofSize: 16, weight: .regular)
            components.append(.text(value: synopsis, style: textStyle))
        }

        return components
    }
}

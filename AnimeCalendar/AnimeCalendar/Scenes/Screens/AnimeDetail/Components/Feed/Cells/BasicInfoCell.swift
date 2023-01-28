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
    typealias AccessId = BasicInfoCellIdentifiers
    static var reuseIdentifier: String = "DETAIL_FEED_BASIC_INFO_CELL_REUSE_ID"
    private static let xPadding: CGFloat = 10.0

    var anime: Anime? {
        didSet { setupUI() }
    }

    /// Stack containing **snynopsis**.
    private lazy var mainStack: ACStack = {
        let stack = ACStack(axis: .vertical)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = AccessId.mainStack
        stack.backgroundColor = .clear
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 0
        contentView.addSubview(stack)
        return stack
    }()

    /// # Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Color.cream
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.xPadding),
        ])

        let constraints = [
            mainStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,
                                                constant: -Self.xPadding),
        ]

        mainStack.setPriorityForConstraints(constraints, with: .defaultHigh)
    }
}

private extension BasicInfoCell {
    func getStackComponents() -> [ACStackItem] {
        guard let anime = anime else { return [] }
        var components = [ACStackItem]()
        var textStyle = ACStack.Text()
        textStyle.alignment = .left

        let emptyView = getEmptyView()
        let spacer: ACStackItem = .customView(emptyView, callback: { [weak self] (view, _) in
            guard let self = self else { return }
            let constraints = [
                view.widthAnchor.constraint(equalTo: self.contentView.widthAnchor,
                                            constant: -Self.xPadding * 2),
            ]
            view.setPriorityForConstraints(constraints, with: .defaultHigh)
        })

        if !anime.studios.isEmpty {
            let producersStack = StudiosStack()
            producersStack.setup(with: anime.studios)

            let stack = producersStack.getStack()
            let scrollView = ACSCroll(axis: .horizontal)
            scrollView.setup(with: stack)
            components.append(.customView(scrollView, callback: { [weak self] (view, _) in
                guard let self = self else { return }
                let constraint = view.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor,
                                                             constant: -Self.xPadding * 2)
                view.setPriorityForConstraints([constraint], with: .defaultHigh)
            }))
        }

        if !anime.producers.isEmpty {
            textStyle.lines = 2
            textStyle.textColor = Color.gray
            textStyle.font = .systemFont(ofSize: 14, weight: .regular)
            let text: String = anime.producers.map { $0.name }.formatList(by: ",", endSeparator: "&")
            components.append(.text(value: text, style: textStyle))
        }

        // Line Separator
        if !anime.producers.isEmpty || !anime.studios.isEmpty {
            components.append(spacer)
        }

        if !anime.synopsis.isEmpty {
            textStyle.lines = 5
            textStyle.alignment = .justified
            textStyle.textColor = Color.gray
            textStyle.font = .systemFont(ofSize: 14, weight: .regular)
            textStyle.callback = { [weak self] (view, _) in
                guard let self = self else { return }
                let constraint = view.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor,
                                                             constant: -Self.xPadding * 2)
                view.setPriorityForConstraints([constraint], with: .defaultHigh)
            }
            components.append(.text(value: anime.synopsis, style: textStyle))
        }

        return components
    }

    func getEmptyView() -> UIView {
        let emptyView = UIView(frame: .zero)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.backgroundColor = Color.gray5

        let constraint = emptyView.heightAnchor.constraint(equalToConstant: 5.0)
        emptyView.setPriorityForConstraints([constraint], with: .defaultHigh)
        
        return emptyView
    }
}

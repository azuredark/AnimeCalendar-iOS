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

    var anime: Anime?

    /// Stack containing **snynopsis**.
    private lazy var mainStack: ACStack = {
        let stack = ACStack(axis: .vertical)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = AccessId.mainStack
        stack.backgroundColor = .clear
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 4
        contentView.addSubview(stack)
        return stack
    }()

    /// # Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        layoutUI()
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
    func layoutUI() {
        layoutStack()
    }

    func layoutStack() {
        let yPadding: CGFloat = 4.0
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            mainStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])

        let constraints = [
            mainStack.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -yPadding)
        ]

        mainStack.setPriorityForConstraints(constraints, with: .init(999))
    }
}

private extension BasicInfoCell {
    func getStackComponents() -> [ACStackItem] {
        guard let anime = anime else { return [] }
        var components = [ACStackItem]()
        let firstSpacer = getLineSpacerItem()
        let secondSpacer = getLineSpacerItem()

        /// # Studios & Producers
        let studiosAndProducersStack: ACStack = getStudiosAndProducerStack(with: anime)
        
        /// # Top initial spacer
        components.append(firstSpacer)
        
        components.append(.customView(studiosAndProducersStack, callback: { [weak self] (view, _) in
            guard let self = self else { return }
            let constraint = view.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -Self.xPadding * 2)
            view.setPriorityForConstraints([constraint], with: .init(999))
        }))

        /// # Synopsis
        if !anime.synopsis.isEmpty {
            // Line separator
            components.append(secondSpacer)
            
            let synopsisStack: ACStack = getSynopsisStack(with: anime.synopsis)
            components.append(.customView(synopsisStack, callback: { [weak self] (view, _) in
                guard let self = self else { return }
                let constraint = view.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -Self.xPadding * 2)
                view.setPriorityForConstraints([constraint], with: .init(999))
            }))
        }

        return components
    }
}

private extension BasicInfoCell {
    func getStudiosAndProducerStack(with anime: Anime) -> ACStack {
        /// # Stack Container
        // Components
        var components = [ACStackItem]()
        let container = ACStack(axis: .vertical)
        container.alignment = .leading
        container.distribution = .fill
        container.spacing = 0
        container.translatesAutoresizingMaskIntoConstraints = false
        
        /// # Studios
        if !anime.studios.isEmpty {
            let producersStack = StudiosStack()
            producersStack.setup(with: anime.studios)
            
            let stack = producersStack.getStack()
            stack.translatesAutoresizingMaskIntoConstraints = false
            let scrollView = ACSCroll(axis: .horizontal)
            scrollView.setup(with: stack)
            
            components.append(.customView(scrollView))
        }
        
        /// # Producers
        if !anime.producers.isEmpty {
            var textStyle = ACStack.Text()
            textStyle.lines = 2
            textStyle.textColor = Color.lightGray
            textStyle.font = .systemFont(ofSize: 14, weight: .regular)
            let text: String = anime.producers.map { $0.name }.formatList(by: ",", endSeparator: "&")
            
            components.append(.text(value: text, style: textStyle))
        }
        
        // Setup Stack Container's components
        container.setup(with: components)
        
        return container
    }
    
    func getSynopsisStack(with synopsis: String) -> ACStack {
        var components = [ACStackItem]()
        let container = ACStack(axis: .vertical)
        container.alignment = .leading
        container.distribution = .fill
        container.spacing = 0
        container.translatesAutoresizingMaskIntoConstraints = false
        
        var textStyle = ACStack.Text()
        // Synopsis title
        textStyle.lines = 1
        textStyle.alignment = .left
        textStyle.textColor = Color.black
        textStyle.font = ACFont.bold.sectionTitle2
        components.append(.text(value: "Synopsis", style: textStyle))

        // Synopsis content
        textStyle.lines = 0
        textStyle.alignment = .justified
        textStyle.textColor = Color.lightGray
        textStyle.font = .systemFont(ofSize: 14, weight: .regular)
        components.append(.text(value: synopsis, style: textStyle))
        
        container.setup(with: components)
        
        return container
    }
}

private extension BasicInfoCell {
    func getLineSpacerItem() -> ACStackItem {
        let emptyView = UIView(frame: .zero)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.backgroundColor = Color.gray5

        let constraint = emptyView.heightAnchor.constraint(equalToConstant: 5.0)
        emptyView.setPriorityForConstraints([constraint], with: .init(999))

        return .customView(emptyView, callback: { [weak self] (view, _) in
            guard let self = self else { return }
            let constraints = [
                view.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            ]
            view.setPriorityForConstraints(constraints, with: .init(999))
        })
    }
}

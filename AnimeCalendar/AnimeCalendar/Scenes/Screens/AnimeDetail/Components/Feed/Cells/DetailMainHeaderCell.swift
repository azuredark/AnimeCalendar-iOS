//
//  DetailMainHeaderCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 6/06/23.
//

import UIKit

final class DetailMainHeaderCell: UICollectionViewCell, FeedCell {
    // MARK: Public State
    weak var anime: Anime?
    
    // MARK: Private State
    private typealias AccessId = BasicInfoCellIdentifiers
    private var genresView: UIView?
    
    // MARK: UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = AccessId.title
        label.textColor = Color.black
        label.font = ACFont.bold.modalTitle
        label.numberOfLines = 0
        label.textAlignment = .left
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var basicInfoStack: ACStack = {
        let stack = ACStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.accessibilityIdentifier = AccessId.stack
        stack.spacing = 4.0
        stack.backgroundColor = .clear
        contentView.addSubview(stack)
        return stack
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        genresView = nil
        basicInfoStack.reset()
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
    
    // MARK: Methods
    func setup() {
        titleLabel.text = anime?.titleEng
        basicInfoStack.setup(with: getBasicInfoStackComponents())
    }
}

// MARK: - Layout UI
private extension DetailMainHeaderCell {
    func layoutUI() {
        layoutTitleLabel()
        layoutBasicInfoStack()
    }
    
    func layoutTitleLabel() {
        let xPadding: CGFloat = 10.0
        let yPadding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: xPadding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: yPadding)
        ])
        
        let trailingAnchor = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -xPadding)
        trailingAnchor.priority = .init(999)
        trailingAnchor.isActive = true
    }
    
    func layoutBasicInfoStack() {
        let width = UIScreen.main.bounds.size.width
        NSLayoutConstraint.activate([
            basicInfoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicInfoStack.widthAnchor.constraint(equalToConstant: width),
            basicInfoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        ])
        
        /// - Important: This must be set with a **LOW** priority as during .initalization **NOR** the *basicInfoStack*
        /// or the *cell* have their *intrinsic-content-size* defined.
        /// The *bacicInfoStack* will have its height defined by default *UISV* constraints.
        /// Having 2 constraints *bottomAnchor* & *UISV's* with 1000 prio. will launch a warning in Xcode and break one of them (The former's). Instead, making the *bottomAnchor* not required will then allow AutoLayout to satisfy *UISV's* constraint and allow the constraint system to try minimize the difference between *basicInfoStack.bottomAnchor & contentView.bottomAnchor* (Not use unnecessary space). Thus satisfying all constraints.
        let bottomAnchor = basicInfoStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        bottomAnchor.priority = .defaultLow
        bottomAnchor.isActive = true
    }
}

// MARK: - Basic Info. Stack
private extension DetailMainHeaderCell {
    func getBasicInfoStackComponents() -> [ACStackItem] {
        var components = [ACStackItem]()
        
        let detailsStack = DetailsStack()
        detailsStack.setup(with: anime)
        
        let stack = detailsStack.getStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setSize(height: 25.0)
        
        components.append(.customView(stack))
        
        // Genres
        guard let genres = anime?.genres, !genres.isEmpty else { return components }
        
        let genresStack = ACStack()
        genresStack.translatesAutoresizingMaskIntoConstraints = false
        genresStack.axis = .horizontal
        genresStack.distribution = .fill
        genresStack.alignment = .center
        genresStack.backgroundColor = .clear
        
        let themeColor = anime?.imageType?.themeColor ?? Color.red
        
        var stackItems: [ACStackItem] = anime?.genres.flatMap { genre -> [ACStackItem] in
            let textConfig = LabelBoxView.TextConfig(text: "\(genre.name)",
                                                     color: Color.black,
                                                     innerPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
            let boxConfig = LabelBoxView.BoxConfig(borderColor: themeColor,
                                                   borderWidth: 2.0,
                                                   cornerRadius: 5.0,
                                                   backgroundColor: themeColor.withAlphaComponent(0.2))
            
            let genreView = LabelBoxView(boxConfig: boxConfig, textConfig: textConfig)
            
            return [.customView(genreView), .spacer(type: .empty, space: 10.0)]
        } ?? []
        
        stackItems.insert(.spacer(type: .empty, space: 10.0), at: 0)
        stackItems.insert(.spacer(type: .empty, space: 10.0), at: stackItems.count - 1)
        
        genresStack.setup(with: stackItems)
        
        let genresScrollView = ACSCroll(axis: .horizontal)
        genresScrollView.setup(with: genresStack)
        
        components.append(.customView(genresScrollView))
        
        genresView = genresScrollView
        
        return components
    }
}

//
//  BasicInfoHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/12/22.
//

import UIKit

protocol FeedHeaderProtocol: UICollectionReusableView {
    static var sectionHeaderKind: String { get set }
    static var reuseIdentifier: String { get set }
    func setup()
}

extension FeedHeaderProtocol {
    static var sectionHeaderKind: String {
        get { "" }
        set {}
    }
}

final class BasicInfoHeader: UICollectionReusableView, FeedHeaderProtocol {
    // MARK: State
    static var reuseIdentifier = "HEADER_REUSE_IDENTIFIER"
    private typealias AccessId = BasicInfoCellIdentifiers
    
    var anime: Anime? {
        didSet { setupUI() }
    }
    
    /// ACCollection containing the anime's genres.
    private var genreCollection: GenreCollection?
    
    /// Item title.
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = AccessId.title
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Color.black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .left
        addSubview(label)
        return label
    }()
    
    /// Vertical stack with detail's and genres components.
    private lazy var basicInfoStack: ACStack = {
        let stack = ACStack()
        stack.axis = .vertical
        stack.spacing = 4.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.accessibilityIdentifier = AccessId.stack
        stack.backgroundColor = .clear
        stack.alignment = .leading
        addSubview(stack)
        return stack
    }()

    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
//        backgroundColor = Color.cream
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        genreCollection = nil
        basicInfoStack.reset()
    }

    // MARK: Methods
    func setup() {
        titleLabel.text = anime?.titleEng
        basicInfoStack.setup(with: getBasicInfoStackComponents())
    }
}

private extension BasicInfoHeader {
    func setupUI() {
        layoutTitleLabel()
        layoutBasicInfoStack()
    }
    
    func layoutTitleLabel() {
        let yInset: CGFloat = 5.0
        let xInset: CGFloat = 10.0
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -xInset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: yInset)
        ])
    }
    
    func layoutBasicInfoStack() {
        let xInset: CGFloat = 10.0
        NSLayoutConstraint.activate([
            basicInfoStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xInset),
            basicInfoStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -xInset),
            basicInfoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            basicInfoStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension BasicInfoHeader {
    func getBasicInfoStackComponents() -> [ACStackItem] {
        var components = [ACStackItem]()
        
        let detailsStack = DetailsStack()
        detailsStack.setup(with: anime)
        components.append(.customView(detailsStack.getStack()))
        
        guard let genres = anime?.genres, !genres.isEmpty else { return components }
        
        let genresCollection = GenreCollection(anime: anime)
        genresCollection.genres = genres
        genresCollection.setup()
        genresCollection.updateSnapshot()

        let collectionView = genresCollection.getCollectionView()
        let xInset: CGFloat = 20.0
        collectionView.setSize(width: bounds.size.width - xInset, height: 30.0)
        components.append(.customView(collectionView))
        
        genreCollection = genresCollection
        return components
    }
}

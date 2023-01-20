//
//  BasicInfoHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/12/22.
//

import UIKit

final class BasicInfoHeader: UICollectionReusableView {
    // MARK: State
    static let reuseIdentifier = "HEADER_REUSE_IDENTIFIER"
    
    var anime: Anime? {
        didSet { setupUI() }
    }
    
    private var genreCollection: GenreCollection?
    
    /// Item title.
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        let stack = ACStack(axis: .vertical)
        stack.spacing = 4.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        stack.alignment = .leading
        addSubview(stack)
        return stack
    }()
    
    private lazy var genreCollection2: GenreCollection = {
        return GenreCollection()
    }()

    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: yInset)
        ])
    }
    
    func layoutBasicInfoStack() {
        NSLayoutConstraint.activate([
            basicInfoStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicInfoStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            basicInfoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            basicInfoStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension BasicInfoHeader {
    func getBasicInfoStackComponents() -> [ACStackItem] {
        var components = [ACStackItem]()
        
        let detailsStack = DetailsStack()
        detailsStack.anime = anime
        detailsStack.setup()
        components.append(.customView(detailsStack.getStack()))
        
        guard let genres = anime?.genres,
              !genres.isEmpty else { return [] }
        
        let genresCollection = GenreCollection()
        genresCollection.genres = genres
        genresCollection.setup()
        genresCollection.updateSnapshot()

        let collectionView = genresCollection.getCollectionView()
        collectionView.setSize(width: bounds.size.width, height: 20.0)
        components.append(.customView(collectionView))
        
        genreCollection = genresCollection
        return components
    }
}

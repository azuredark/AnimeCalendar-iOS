//
//  TopAnimeCell.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/11/22.
//

import UIKit
import RxCocoa
import RxSwift

final class TopAnimeCell: UICollectionViewCell, FeedCell {
    static var reuseIdentifier: String = "TOP_ANIME_CELL_REUSE_ID"
    private var radius: CGFloat { 5.0 }

    // MARK: State
    weak var anime: Anime?
    var index: Int?
    weak var presenter: DiscoverPresentable?
    private var imageDisposable: Disposable?

    private lazy var mainContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.white
        contentView.addSubview(container)
        return container
    }()

    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addCornerRadius(radius: radius)
        mainContainer.addSubview(imageView)
        return imageView
    }()

    private lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.alpha = 0.7
        coverImageView.addSubview(view)
        return view
    }()

    private lazy var rankContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = Color.cream.withAlphaComponent(0.6)
        coverImageView.addSubview(container)
        return container
    }()

    private lazy var rankLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.staticWhite
        label.font = .systemFont(ofSize: 32.0, weight: .bold)
        label.numberOfLines = 1
        label.textAlignment = .center
        rankContainer.addSubview(label)
        return label
    }()

    /// Contains the title/details/genre elements
    private lazy var infoContainer: UIView = {
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        mainContainer.addSubview(container)
        return container
    }()

    private lazy var detailStack: ACStack = {
        let stack = ACStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        infoContainer.addSubview(stack)
        return stack
    }()

    private lazy var titleContainer: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        stack.axis = .vertical
        stack.alignment = .leading
        infoContainer.addSubview(stack)
        return stack
    }()

    private lazy var engTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.staticWhite
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.numberOfLines = 2
        
        // Shadow
        label.layer.shadowColor = Color.staticBlack.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        return label
    }()

    private lazy var japTilteLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.lightGray
        label.textAlignment = .left
        label.font = .italicSystemFont(ofSize: 12.0)
        label.numberOfLines = 1
        return label
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.staticWhite
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        label.numberOfLines = 1
        infoContainer.addSubview(label)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        presenter = nil
        coverImageView.image = nil
        rankLabel.text = nil
        engTitleLabel.text = nil
        detailStack.reset()
        japTilteLabel.text = nil
        genresLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    #warning("Rank should be related to the id")
    // MARK: Methods
    /// The setup is run for **every new cell dequed**. In contrast with **setupUI** which only configure constraints on each run and its UI elements are saved in the *new initialized cell's* memory.
    ///
    /// - Important: Only so many cells are ever **initialized** in a UICollectionView or UITableViewCell
    func setup() {
        setupBackgroundImage()
    }

    func getCoverImage() -> UIImage? {
        return coverImageView.image
    }
}

private extension TopAnimeCell {
    func setupBackgroundImage() {
        let path: String? = anime?.imageType?.webpImage.attemptToGetImageByResolution(.normal)
        coverImageView.loadImage(from: path, cellType: self) { [weak self] (_, _) in
            self?.setupRankLabel()
            self?.setupTitleLabel()
            self?.setupAnimeDetail()
            self?.setupJapTitleLabel()
            self?.setupGenresLabel()
        }
    }

    func setupRankLabel() {
        rankLabel.text = "\(index ?? 0)"
    }

    func setupAnimeDetail() {
        // Setup Detail stack
        let components: [ACStackItem] = Self.buildStackComponents(anime: anime)
        detailStack.setup(with: components)
    }

    func setupTitleLabel() {
        engTitleLabel.text = anime?.titleEng
    }

    func setupJapTitleLabel() {
        japTilteLabel.text = anime?.titleOrg
    }

    func setupGenresLabel() {
        guard let animeGenres = anime?.genres, !animeGenres.isEmpty else { return }
        
        let genres: [String]? = animeGenres.map { $0.name }
        genresLabel.text = genres?.formatList(by: ",", endSeparator: "&")
    }
}

private extension TopAnimeCell {
    func layoutUI() {
        layoutContainer()
        layoutCoverImageView()
        layoutBlurView()

        // Rank container
        layoutRankContainer()
        layoutRankLabel()

        // Info. container
        layoutInfoContainer()
        layoutDetailStack()
        layoutTitleContainer()
        layoutEngTitleLabel()
        layoutJapTitleLabel()
        layoutGenreLabel()
    }

    func layoutContainer() {
        NSLayoutConstraint.activate([
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        #warning("Is using tooooo much memory, up to 100mb")
    }

    func layoutCoverImageView() {
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            coverImageView.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
    }

    func layoutBlurView() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        ])
    }

    func layoutRankContainer() {
        NSLayoutConstraint.activate([
            rankContainer.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            rankContainer.widthAnchor.constraint(equalToConstant: 50.0),
            rankContainer.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            rankContainer.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        ])
    }

    func layoutRankLabel() {
        NSLayoutConstraint.activate([
            rankLabel.leadingAnchor.constraint(equalTo: rankContainer.leadingAnchor, constant: 3),
            rankLabel.trailingAnchor.constraint(equalTo: rankContainer.trailingAnchor, constant: -3),
            rankLabel.centerXAnchor.constraint(equalTo: rankContainer.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankContainer.centerYAnchor)
        ])
    }

    func layoutInfoContainer() {
        let xInset: CGFloat = 5.0
        let yInset: CGFloat = 2.0
        NSLayoutConstraint.activate([
            infoContainer.leadingAnchor.constraint(equalTo: rankContainer.trailingAnchor, constant: xInset),
            infoContainer.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -xInset),
            infoContainer.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            infoContainer.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -yInset)
        ])
    }

    func layoutDetailStack() {
        NSLayoutConstraint.activate([
            detailStack.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            detailStack.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            detailStack.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }

    func layoutTitleContainer() {
        NSLayoutConstraint.activate([
            titleContainer.centerYAnchor.constraint(equalTo: infoContainer.centerYAnchor),
            titleContainer.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            titleContainer.trailingAnchor.constraint(lessThanOrEqualTo: infoContainer.trailingAnchor)
        ])
    }

    func layoutEngTitleLabel() {
        titleContainer.addArrangedSubview(engTitleLabel)
    }

    func layoutJapTitleLabel() {
        titleContainer.addArrangedSubview(japTilteLabel)
    }

    func layoutGenreLabel() {
        NSLayoutConstraint.activate([
            genresLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            genresLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoContainer.trailingAnchor),
            genresLabel.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor)
        ])
    }
}

private extension TopAnimeCell {
    static func buildStackComponents(anime: Anime?) -> [ACStackItem] {
        guard let anime = anime else { return [ACStackItem]() }
        var components = [ACStackItem]()

        var textStyle = ACStack.Text()
        textStyle.lines = 1
        textStyle.textColor = Color.staticWhite

        /// Icon model for the images in the **ACStack** view.
        var icon = ACStack.Image()
        icon.size = .init(width: 14.0)
        icon.tint = Color.staticWhite

        let spacer: ACStackItem = .spacer(type: .empty, space: 4.0)

        if anime.year > 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.calendar)),
                .text(value: String(anime.year), style: textStyle),
                spacer
            ])
        }

        if anime.episodesCount > 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.tvFilled)),
                .text(value: String(anime.episodesCount), style: textStyle),
                spacer
            ])
        }

        if anime.score >= 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.starFilled)),
                .text(value: "\(anime.score)", style: textStyle),
                spacer
            ])
        }

        if anime.members > 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.twoPeopleFilled)),
                .text(value: "\(anime.members)", style: textStyle)
            ])
        }

        return components
    }
}

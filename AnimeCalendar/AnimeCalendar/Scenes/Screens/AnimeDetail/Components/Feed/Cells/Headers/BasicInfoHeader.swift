//
//  BasicInfoHeader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/12/22.
//

import UIKit

#warning("THIS SHOULD ALL BE STACK VIEW JSAOIDJDOISDFJ")
final class BasicInfoHeader: UICollectionReusableView {
    // MARK: State
    static let reuseIdentifier = "HEADER_REUSE_IDENTIFIER"
    
    var anime: Anime? {
        didSet { setupUI() }
    }
    
    /// Item title.
    private lazy var headerLabel: UILabel = {
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
    
    /// Stack with basic anime details.
    private lazy var detailsStack: ACStack = {
        let stack = ACStack(axis: .horizontal)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .clear
        stack.alignment = .center
        addSubview(stack)
        return stack
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        headerLabel.text = nil
        detailsStack.reset()
    }

    // MARK: Methods
    func setup() {
        headerLabel.text = anime?.titleEng
        detailsStack.setup(with: getDetailsStackComponents())
    }
}

private extension BasicInfoHeader {
    func setupUI() {
        layoutHeader()
        layoutDetailsStack()
    }
    
    func layoutHeader() {
        let yInset: CGFloat = 5.0
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: yInset)
//            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -yInset)
        ])
    }
    
    func layoutDetailsStack() {
        let height: CGFloat = 20.0
        NSLayoutConstraint.activate([
            detailsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailsStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            detailsStack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            detailsStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailsStack.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

private extension BasicInfoHeader {
    func getDetailsStackComponents() -> [ACStackItem] {
        var components = [ACStackItem]()
        guard let anime = anime else { return [] }
        
        var textStyle = ACStack.Text()
        textStyle.font = .systemFont(ofSize: 12, weight: .medium)
        textStyle.textColor = Color.subtitle
        textStyle.lines = 1

        /// Icon model for the images in the **ACStack** view.
        var icon = ACStack.Image()
        icon.size = .init(width: 14.0)
        icon.tint = Color.subtitle
        
        let spacer: ACStackItem = .spacer(type: .circle(tint: Color.subtitle),
                                          space: 5.0)
        
        // Show type
        components.append(contentsOf: [
            .text(value: anime.showType.rawValue, style: textStyle),
            spacer
        ])
        
        // Show year
        if anime.year > 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.calendar)),
                .text(value: String(anime.year), style: textStyle),
                spacer
            ])
        }

        // Show episodes count
        if anime.episodesCount > 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.tvFilled)),
                .text(value: String(anime.episodesCount), style: textStyle),
                spacer
            ])
        }

        // Show score
        if anime.score >= 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.starFilled)),
                .text(value: "\(anime.score)", style: textStyle),
                spacer
            ])
        }

        // Show members
        if anime.members > 0 {
            components.append(contentsOf: [
                .icon(image: icon.with(image: ACIcon.twoPeopleFilled)),
                .text(value: "\(anime.members)", style: textStyle)
            ])
        }
        
        print("senku [DEBUG] \(String(describing: type(of: self))) - detail stasck did setup")
        
        return components
    }
}

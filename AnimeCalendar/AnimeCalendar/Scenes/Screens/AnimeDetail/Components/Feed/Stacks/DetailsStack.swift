//
//  DetailsStack.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 7/01/23.
//

import UIKit

final class DetailsStack: ACStackable {
    // MARK: State
    private(set) lazy var stack: ACStack = {
        let _stack = ACStack()
        _stack.translatesAutoresizingMaskIntoConstraints = false
        _stack.axis = .horizontal
        _stack.alignment = .center
        _stack.distribution = .fill
        _stack.spacing = 4.0
        _stack.backgroundColor = .clear
        return _stack
    }()

    // MARK: Methods
    func setup(with anime: Anime?) {
        stack.setup(with: getStackComponents(with: anime))
    }
}

private extension DetailsStack {
    func getStackComponents(with anime: Anime?) -> [ACStackItem] {
        var components = [ACStackItem]()
        guard let anime = anime else { return [] }

        var textStyle = ACStack.Text()
        textStyle.font = .systemFont(ofSize: 12, weight: .medium)
        textStyle.textColor = Color.lightGray
        textStyle.lines = 1

        /// Icon model for the images in the **ACStack** view.
        var icon = ACStack.Image()
        icon.size = .init(width: 14.0)
        icon.tint = Color.gray

        let spacer: ACStackItem = .spacer(type: .circle(tint: Color.gray), space: 10.0)
        
        let leadingSpacer: ACStackItem = .spacer(type: .empty, space: 10.0)
        
        // Leading spacer (Inset)
        components.append(leadingSpacer)
        
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
        if anime.score > 0 {
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

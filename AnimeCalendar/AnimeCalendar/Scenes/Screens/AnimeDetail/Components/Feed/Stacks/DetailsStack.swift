//
//  DetailsStack.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 7/01/23.
//

import UIKit

final class DetailsStack {
    var anime: Anime?

    // MARK: State
    private lazy var stack: ACStack = {
        let _stack = ACStack(axis: .horizontal)
        _stack.backgroundColor = .clear
        _stack.alignment = .center
        return _stack
    }()

    // MARK: Initializers
    init() {}

    // MARK: Methods
    func setup() {
        stack.setup(with: getStackComponents())
    }

    func reset() {
        stack.reset()
    }

    func getStack() -> UIStackView {
        stack
    }
}

private extension DetailsStack {
    func getStackComponents() -> [ACStackItem] {
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

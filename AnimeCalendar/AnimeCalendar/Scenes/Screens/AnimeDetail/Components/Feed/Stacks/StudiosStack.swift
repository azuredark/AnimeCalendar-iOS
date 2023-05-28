//
//  StudiosStack.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/01/23.
//

import Foundation

final class StudiosStack: ACStackable {
    // MARK: State
    private(set) lazy var stack: ACStack = {
        let _stack = ACStack(axis: .horizontal)
        _stack.translatesAutoresizingMaskIntoConstraints = false
        _stack.backgroundColor = .clear
        _stack.alignment = .center
        _stack.distribution = .fill
        return _stack
    }()
    
    // MARK: Methods
    func setup(with studios: [AnimeStudio]) {
        stack.setup(with: getStackComponents(with: studios))
    }
}

private extension StudiosStack {
    func getStackComponents(with producers: [AnimeStudio]) -> [ACStackItem] {
        var components = [ACStackItem]()
        var textStyle = ACStack.Text()
        textStyle.alignment = .left
        textStyle.textColor = Color.black
        textStyle.lines = 1
        textStyle.font = ACFont.bold.sectionTitle2

        let spacer: ACStackItem = .spacer(type: .circle(tint: Color.subtitle),
                                          space: 5.0)

        // Add producers.
        producers.enumerated().forEach { (index, producer) in
            components.append(.text(value: producer.name, style: textStyle))
            // If there is another element, then layout spacer.
            if (producers.count - (index + 1)) > 0 {
                components.append(spacer)
            }
        }
        return components
    }
}

//
//  AnimeDetailSeparatorView.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import UIKit

final class AnimeDetailSeparatorView: UIView {
    // MARK: State
    
    // MARK: Initializers
    init(model: Model = Model()) {
        super.init(frame: .zero)
        configure(with: model)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AnimeDetailSeparatorView {
    func configure(with model: Model) {
        backgroundColor = model.color
    }
}

extension AnimeDetailSeparatorView {
    struct Model {
        var color: UIColor = Color.gray5
    }
}

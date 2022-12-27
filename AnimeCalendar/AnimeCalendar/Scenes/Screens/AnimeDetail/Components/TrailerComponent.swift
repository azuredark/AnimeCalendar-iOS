//
//  TrailerComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import UIKit
import youtube_ios_player_helper

protocol TrailerCompatible {
    func loadTrailer(withId id: String)
    func startTrailer()
    func getContainer() -> UIView
}

final class TrailerComponent: NSObject {
    // MARK: State
    private lazy var playerView: YTPlayerView = {
        let view = YTPlayerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.alpha = 0
        return view
    }()
    
    /// # Presenter
    private weak var presenter: AnimeDetailPresentable?

    // MARK: Initializers
    init(presenter: AnimeDetailPresentable?) {
        super.init()
        self.presenter = presenter
        configureComponent()
    }
}

extension TrailerComponent: Component {
    func configureComponent() {
        configureView()
        configureSubviews()
    }

    func configureView() {}

    func configureSubviews() {}
}

extension TrailerComponent: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("senku [DEBUG] \(String(describing: type(of: self))) - PLAAYER READYY")
        UIView.animate(withDuration: 0.25) {
            playerView.alpha = 1
        }
    }
}


extension TrailerComponent: TrailerCompatible {
    func loadTrailer(withId id: String) {
        presenter?.loadTrailer(in: playerView, id: id)
    }
    
    func startTrailer() {}

    func getContainer() -> UIView {
        return playerView
    }
}

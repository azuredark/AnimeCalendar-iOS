//
//  TrailerComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import UIKit
import youtube_ios_player_helper

protocol TrailerCompatible: AnyObject {
    func loadTrailer(withId id: String)
    func startTrailer()
    func getContainer() -> UIView
    func disposePlayer()
}

final class TrailerComponent: NSObject {
    // MARK: State
    private lazy var playerView: YTPlayerView = {
        let view = YTPlayerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
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

    func configureSubviews() {
        playerView.delegate = self
    }
}

extension TrailerComponent: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        presenter?.trailerLoaded.accept(true)
        print("senku [DEBUG] \(String(describing: type(of: self))) - PLAAYER READYY")
    }

    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = Color.black
        return nil
    }

    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print("senku [DEBUG] \(String(describing: type(of: self))) - Player error: \(error)")
    }
}

extension TrailerComponent: TrailerCompatible {
    func loadTrailer(withId id: String) {
        playerView.load(withVideoId: id, playerVars: ["playerisinline": 1])
    }

    func startTrailer() {}

    func getContainer() -> UIView {
        return playerView
    }

    func disposePlayer() {
        playerView.stopVideo()
        playerView.pauseVideo()
        playerView.subviews.forEach { $0.removeFromSuperview() }
        playerView.removeFromSuperview()
    }
}

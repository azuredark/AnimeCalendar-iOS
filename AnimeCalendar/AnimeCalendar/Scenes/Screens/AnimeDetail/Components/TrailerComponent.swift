//
//  TrailerComponent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import UIKit
import youtube_ios_player_helper

protocol TrailerCompatible: AnyObject {
    var presenter: AnimeDetailPresentable? { get set }
    var wof: Bool { get set }
    var playerIsAlreadyLoaded: Bool { get }
    func loadTrailer(withId id: String)
    func queueVideo(withId id: String)
    func getContainer() -> UIView
    func disposePlayer()
}

enum PlayerState {
    case loaded
    case loading
    case error
    case idle
}

final class TrailerComponent: NSObject {
    // MARK: State
    private let TIME_OUT_SECONDS: CGFloat = 4.0
    private var playerState: PlayerState = .idle
    var wof: Bool = false
    private var playerWebViewDidLoad: Bool = false

    private lazy var playerView: YTPlayerView = {
        let view = YTPlayerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// # Presenter
    weak var presenter: AnimeDetailPresentable?

    // MARK: Initializers
    override init() {
        super.init()

        self.playerState = .idle
        configureComponent()
        print("senku [DEBUG] \(String(describing: type(of: self))) - ****** TRAILER COMPONENT INITED")
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
        if playerState != .error {
            print("senku [DEBUG] \(String(describing: type(of: self))) - PLAYER READY")
            playerState = .loaded
            presenter?.trailerLoaded.accept(true)
        }
    }

    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = Color.black
        return nil
    }

    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        playerState = .error
        print("senku [DEBUG] \(String(describing: type(of: self))) - Player error: \(error)")
    }

    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {}

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        guard playerState != .error else { return }
        if case .cued = state {
            print("senku [DEBUG] \(String(describing: type(of: self))) - PLAYER DID QUEUE")
            presenter?.trailerLoaded.accept(true)
            playerState = .loaded
        }
    }
}

extension TrailerComponent: TrailerCompatible {
    var playerIsAlreadyLoaded: Bool { !(playerView.webView == nil) }

    func loadTrailer(withId id: String) {
        guard !id.isEmpty else {
            playerState = .idle
            presenter?.trailerLoaded.accept(false)
            print("senku [DEBUG] \(String(describing: type(of: self))) - PLAYER NO ID: \(id)")
            return
        }

        playerState = .loading
        timeOut()
        playerView.load(withVideoId: id,
                        playerVars: ["autoplay": 1,
                                     "playsinline": 1,
                                     "cc_load_policy": 1,
                                     "cc_lang_pref": "en",
                                     "rel": 0])
    }

    func queueVideo(withId id: String) {
        // Load the playerView for the first time, then only queue new videos up.
        if playerView.webView == nil {
            loadTrailer(withId: id)
            playerWebViewDidLoad = true
        } else {
            playerView.cueVideo(byId: id, startSeconds: 0)
        }
    }

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

private extension TrailerComponent {
    func timeOut() {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TIME_OUT_SECONDS) {
            [weak self] in
            guard let self = self else { return }
            guard self.playerState == .loading else { return }
            self.playerState = .error
            self.presenter?.trailerLoaded.accept(false)
            print("senku [DEBUG] \(String(describing: type(of: self))) - PLAYER TIME-OUT")
        }
    }
}

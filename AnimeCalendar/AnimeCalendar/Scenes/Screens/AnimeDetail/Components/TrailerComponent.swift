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
    var playerIsAlreadyLoaded: Bool { get }
    func loadTrailer(withId id: String)
    func queueVideo(withId id: String)
    func getContainer() -> UIView?
    func disposePlayer()
    func createPlayer()
}

enum PlayerState {
    case loaded
    case loading
    case error
    case idle
}

final class TrailerComponent: NSObject {
    // MARK: State
    private let TIME_OUT_SECONDS: CGFloat = 8.0
    private var playerState: PlayerState = .idle

    private var playerView: YTPlayerView?
    private var ytVideoId: String = ""

    /// # Presenter
    weak var presenter: AnimeDetailPresentable?

    static let shared = TrailerComponent()

    // MARK: Initializers
    override private init() {
        super.init()
        configureComponent()
        print("senku [DEBUG] \(String(describing: type(of: self))) - ****** TRAILER COMPONENT INITED")
    }
}

extension TrailerComponent {
    func configureComponent(preheated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.playerView = YTPlayerView(frame: .zero)
            self.playerView?.translatesAutoresizingMaskIntoConstraints = false
            self.playerView?.delegate = self
            self.playerState = .idle
            if preheated { self.queueVideo(withId: "a9tq0aS5Zu8") }
        }
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
    var playerIsAlreadyLoaded: Bool { !(playerView?.webView == nil) }

    func loadTrailer(withId id: String) {
        guard !id.isEmpty else {
            playerState = .idle
            presenter?.trailerLoaded.accept(false)
            print("senku [DEBUG] \(String(describing: type(of: self))) - PLAYER NO ID: \(id)")
            return
        }

        timeOut(for: ytVideoId)
        playerView?.load(withVideoId: id,
                         playerVars: ["autoplay": 0,
                                      "playsinline": 1,
                                      "cc_load_policy": 1,
                                      "cc_lang_pref": "en",
                                      "rel": 0])
    }

    func queueVideo(withId id: String) {
        // Load the playerView for the first time, then only queue new videos up.
        ytVideoId = id
        playerState = .loading
        if playerView?.webView == nil {
            loadTrailer(withId: id)
        } else {
            playerView?.cueVideo(byId: id, startSeconds: 0)
        }
    }

    func getContainer() -> UIView? {
        return playerView
    }

    func disposePlayer() {
        Task { @MainActor in
            playerView?.stopVideo()
            playerView?.pauseVideo()
            playerView?.subviews.forEach { $0.removeFromSuperview() }
            playerView?.removeFromSuperview()
            playerView = nil
        }
    }

    func createPlayer() {
        configureComponent()
    }
}

private extension TrailerComponent {
    func timeOut(for ytVideoId: String) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + TIME_OUT_SECONDS) { [weak self, ytVideoId] in
            guard let self else { return }
            guard ytVideoId == self.ytVideoId else { return }
            guard self.playerState == .loading else { return }
            self.presenter?.trailerLoaded.accept(false)
            print("senku [DEBUG] \(String(describing: type(of: self))) - PLAYER TIME-OUT")
        }
    }
}

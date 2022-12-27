//
//  AnimeDetailPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import RxCocoa
import youtube_ios_player_helper

protocol AnimeDetailPresentable: AnyObject {
    /// Weak reference towards the view
    func start() -> Screen
    func updateAnime(with anime: Anime)
    func loadTrailer(in player: YTPlayerView, id: String)
    var anime: Driver<Anime> { get }
}

final class AnimeDetailPresenter: AnimeDetailPresentable {
    // MARK: State
    private var router: AnimeDetailRoutable
    private var interactor: AnimeDetailInteractive
    weak var view: AnimeDetailScreen?

    // MARK: Initializers
    init(router: AnimeDetailRoutable, interactor: AnimeDetailInteractive) {
        self.router = router
        self.interactor = interactor
    }

    // MARK: Methods
    /// Ask router to create the main module **Screen**.
    func start() -> Screen {
        return router.start(presenter: self)
    }

    func updateAnime(with anime: Anime) {
        interactor.updateAnime(with: anime)
    }

    func loadTrailer(in player: YTPlayerView, id: String) {
        player.load(withVideoId: id, playerVars: ["playerisinline": 1])
    }

    var anime: Driver<Anime> {
        interactor.animeObservable
    }
}

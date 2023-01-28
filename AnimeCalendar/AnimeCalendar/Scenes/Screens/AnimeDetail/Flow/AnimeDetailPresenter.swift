//
//  AnimeDetailPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import RxCocoa
import RxSwift
import youtube_ios_player_helper

protocol AnimeDetailPresentable: AnyObject {
    /// Weak reference towards the view
    func start() -> Screen
    func updateAnime(with anime: Anime)
    func disposeTrailerComponent()
    var anime: Driver<Anime> { get }
    var trailerLoaded: PublishRelay<Bool> { get }
    var didFinishLoadingAnimeAndTrailer: Driver<(Anime, Bool)> { get }
}

final class AnimeDetailPresenter: AnimeDetailPresentable {
    // MARK: State
    private var router: AnimeDetailRoutable
    private var interactor: AnimeDetailInteractive
    weak var view: AnimeDetailScreen?
    
    private let disposeBag = DisposeBag()

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

    /// Sends a new **anime** event.
    func updateAnime(with anime: Anime) {
        interactor.updateAnime(with: anime)
    }
    
    func disposeTrailerComponent() {
        let component = view?.getDetailFeed().getTrailerComponent()
        component?.disposePlayer()
    }

    /// Tracks when a new **anime** event is fired.
    var anime: Driver<Anime> {
        interactor.animeObservable
    }
    
    /// Tracks when the **trailer** has loaded and will be displayed.
    var trailerLoaded: PublishRelay<Bool> {
        interactor.animeTrailerLoadedObservable
    }
    
    /// Tracks when both the **anime** & **trailer** have finished loading and emits an event.
    /// This event fires up a new section being added into the **mainCollection**
    var didFinishLoadingAnimeAndTrailer: Driver<(Anime, Bool)> {
        interactor.didFinishLoadingTrailerObservable
    }
}

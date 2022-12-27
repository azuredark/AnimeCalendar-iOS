//
//  AnimeDetailPresenter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

protocol AnimeDetailPresentable: AnyObject {
    /// Weak reference towards the view
    var view: Screen? { get set }
    func start() -> Screen
    func viewDidDissapear()
}

final class AnimeDetailPresenter: AnimeDetailPresentable {
    // MARK: State
    private var router: AnimeDetailRoutable
    private var interactor: AnimeDetailInteractive
    weak var view: Screen?
    
    // MARK: Initializers
    init(router: AnimeDetailRoutable, interactor: AnimeDetailInteractive) {
        self.router = router
        self.interactor = interactor
    }
    
    // MARK: Methods
}

extension AnimeDetailPresenter {
    /// Ask router to create the main module **Screen**.
    func start() -> Screen {
        return router.start(presenter: self)
    }
    
    func viewDidDissapear() {
        
    }
}

//
//  HomeInteractor.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/10/22.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeInteractor {
    private lazy var repository = AnimeRepository(requestManager)
    private var requestManager: RequestProtocol
    private var disposeBag = DisposeBag()
    
    init(requestManager: RequestProtocol) {
        self.requestManager = requestManager
        repository.getAnime(name: "Dr. Stone")
            .subscribe(onNext: { result in
                print("senku [DEBUG] \(String(describing: type(of: self))) - animes retrieved: \(result?.data?.map {$0.title})")
            }).disposed(by: disposeBag)
    }
}

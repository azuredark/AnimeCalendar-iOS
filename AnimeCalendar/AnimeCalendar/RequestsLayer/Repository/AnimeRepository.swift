//
//  AnimeRepository.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/08/22.
//

import Foundation
import RxSwift

class GenericRepository {
    // MARK: Properties
    private(set) var requestsManager: RequestProtocol

    // MARK: Initializers
    init(_ requestsManager: RequestProtocol) {
        self.requestsManager = requestsManager
    }

    // MARK: Methods
    func getResource(in screen: ScreenType, path: String) -> Observable<Data> {
//        print("senku [DEBUG] \(String(describing: type(of: self))) - path: \(path)")
        return .create { [weak self] observer in
            guard let strongSelf = self else {
                print("senku [DEBUG] \(String(describing: type(of: self))) - FUCKKKK")
                return Disposables.create()
            }

            strongSelf.requestsManager.network.makeResourceRequest(in: screen, from: path) { result in
                switch result {
                    case .success(let data):
                        observer.onNext(data)
                    case .failure(let error):
                        print("senku [DEBUG] \(String(describing: type(of: self))) - error: \(error)")
                        observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getResourceV2(in screen: ScreenType, path: String, completion: @escaping (Data?) -> Void) {
         requestsManager.network.makeResourceRequest(in: screen, from: path) { result in
             switch result {
                 case .success(let data):
                     completion(data)
                 case .failure(let error):
                     print("senku [DEBUG] \(String(describing: type(of: self))) - error: \(error)")
                     completion(nil)
             }

        }
    }
}

final class AnimeRepository: GenericRepository {
    func getAnime(name: String) -> Observable<JikanAnimeResult?> {
        return .create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }

            let model = JikanAnimeResult.self
            strongSelf.requestsManager.network.makeRequest(model, .anime(.getAnime(name: name))) { result in
                switch result {
                    case .success(let anime):
                        observer.onNext(anime)
                    case .failure(let error):
                        observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

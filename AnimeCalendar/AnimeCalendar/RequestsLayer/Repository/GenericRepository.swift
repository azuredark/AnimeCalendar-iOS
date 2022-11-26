//
//  GenericRepository.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/11/22.
//

import Foundation

class GenericRepository {
    // MARK: Properties
    private(set) var requestsManager: RequestProtocol

    // MARK: Initializers
    init(_ requestsManager: RequestProtocol) {
        self.requestsManager = requestsManager
    }

    func getResource(in screen: ScreenType, path: String, completion: @escaping (Data?) -> Void) {
        requestsManager.network.makeResourceRequest(in: screen, from: path) { result in
            switch result {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    completion(nil)
            }
        }
    }
}

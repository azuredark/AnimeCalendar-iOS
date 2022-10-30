//
//  LocalManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 30/10/22.
//

import Foundation

final class LocalManager: Requestable {
    // MARK: State
    
    // MARK: Initializers
    init() {}
    
    // MARK: Methods
    func makeRequest<T>(_ model: T.Type, _ service: Service, _ completion: @escaping (Result<T?, Error>) -> Void) where T : Decodable {
        
    }
}

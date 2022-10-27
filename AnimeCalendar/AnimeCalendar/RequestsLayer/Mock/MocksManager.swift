//
//  MocksManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class MocksManager: Requestable {
    func makeRequest<T>(_ model: T.Type, _ service: Service, _ completion: @escaping (Result<T?, Error>) -> Void) where T: Decodable {}
}

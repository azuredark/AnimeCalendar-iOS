//
//  RequetsMethods.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/04/22.
//

import Foundation

protocol Requestable: AnyObject {
    func makeRequest<T: Decodable>(_ model: T.Type, _ service: Service, _ completion: @escaping (Result<T?, Error>) -> Void)
}

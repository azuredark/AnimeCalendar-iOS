//
//  RequestsManager.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 24/04/22.
//

import Foundation

final class RequestsManager: RequestProtocol {
  lazy var network: RequestsMethods = NetworkManager()
  lazy var mock: RequestsMethods = MocksManager()
}

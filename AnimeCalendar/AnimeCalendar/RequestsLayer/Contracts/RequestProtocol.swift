//
//  RequestProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/04/22.
//

import Foundation

protocol RequestProtocol {
  var network: RequestsMethods { get set }
  var mock: RequestsMethods { get set }
}

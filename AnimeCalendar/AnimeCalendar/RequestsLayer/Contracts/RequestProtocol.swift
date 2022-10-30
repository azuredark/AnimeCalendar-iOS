//
//  RequestProtocol.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 25/04/22.
//

import Foundation

protocol RequestProtocol {
    var network: Requestable { get }
    var local: Requestable { get }
    var mock: Requestable { get }
}

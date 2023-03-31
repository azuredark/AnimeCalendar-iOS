//
//  AnimeProducer.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/03/23.
//

import Foundation

final class AnimeProducer: Content {
    // MARK: Parameters
    var type: String
    var name: String
    var url: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case url
    }

    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.url  = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        
        try super.init(from: decoder)
    }

    // MARK: Initializers
    override init() {
        self.type = "PRODUCER_ID"
        self.name = "PRODUCER__NAME"
        self.url = "PRODUCER_URL"
        super.init()
    }
}

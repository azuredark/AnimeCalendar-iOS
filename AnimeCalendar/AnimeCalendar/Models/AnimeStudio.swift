//
//  AnimeStudio.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/03/23.
//

import Foundation

final class AnimeStudio: Content {
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
        self.type = "STUDIO_ID"
        self.name = "STUDIO_NAME"
        self.url = "STUDIO_URL"
        super.init()
    }
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AnimeStudio, rhs: AnimeStudio) -> Bool {
        return lhs.id == rhs.id
    }
}

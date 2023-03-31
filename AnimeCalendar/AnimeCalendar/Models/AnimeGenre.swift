//
//  AnimeGenre.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 29/03/23.
//

import Foundation

final class AnimeGenre: Content {
    // MARK: Parameters
    var name: String
    var url: String

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }

    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.url  = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        
        try super.init(from: decoder)
    }

    // MARK: Initializers
    override init() {
        self.name = "DEFAULT_NAME"
        self.url = "DEFAULT_URL"
        super.init()
    }
    
    
    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AnimeGenre, rhs: AnimeGenre) -> Bool {
        return lhs.id == rhs.id
    }
}


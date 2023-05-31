//
//  RecommendationInfo.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 31/05/23.
//

import Foundation

final class RecommendationInfo: Content {
    // MARK: Parameters
    var votes: Int = 0
    var url: String?
    var anime: Anime?
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case votes
        case url
        case anime = "entry"
    }
    
    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.votes = try container.decodeIfPresent(Int.self, forKey: .votes) ?? 0
        self.url   = try container.decodeIfPresent(String.self, forKey: .url) ?? nil
        self.anime = try container.decodeIfPresent(Anime.self, forKey: .anime) ?? nil
        
        try super.init(from: decoder)
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
}

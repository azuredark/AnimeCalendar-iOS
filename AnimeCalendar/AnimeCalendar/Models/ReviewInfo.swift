//
//  ReviewInfo.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import Foundation

final class ReviewInfo: Content {
    // MARK: Parameters
    var url: String?
    var type: ShowType = .tv
    var reaction: Reaction?
    var dateStr: String?
    var review: String = ""
    var score: Int?
    var isSpoiler: Bool = false
    var isPreliminary: Bool = false
    var user: User?
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case url
        case type
        case reaction      = "reactions"
        case dateStr       = "date"
        case review
        case score
        case isSpoiler     = "is_spoiler"
        case isPreliminary = "is_preliminary"
        case user
    }
    
    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url           = try container.decodeIfPresent(String.self, forKey: .url)
        self.type          = ShowType(from: try container.decodeIfPresent(String.self, forKey: .type) ?? "")
        self.reaction      = try container.decodeIfPresent(Reaction.self, forKey: .reaction)
        self.dateStr       = try container.decodeIfPresent(String.self, forKey: .dateStr)
        self.review        = try container.decodeIfPresent(String.self, forKey: .review) ?? ""
        self.score         = try container.decodeIfPresent(Int.self, forKey: .score) ?? 0
        self.isSpoiler     = try container.decode(Bool.self, forKey: .isSpoiler)
        self.isPreliminary = try container.decode(Bool.self, forKey: .isPreliminary)
        self.user          = try container.decodeIfPresent(User.self, forKey: .user) ?? nil
        
        try super.init(from: decoder)
    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
}

struct Reaction: Decodable {
    // MARK: Parameters
    var overall: Int?
    var nice: Int?
    var love: Int?
    var funny: Int?
    var confusing: Int?
    var informative: Int?
    var wellWritten: Int?
    var creative: Int?
    
    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case overall
        case nice
        case love        = "love_it"
        case funny
        case confusing
        case informative
        case wellWritten = "well_written"
        case creative
    }
    
    // MARK: Decoding Technique
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.overall     = try container.decodeIfPresent(Int.self, forKey: .overall)
        self.nice        = try container.decodeIfPresent(Int.self, forKey: .nice)
        self.love        = try container.decodeIfPresent(Int.self, forKey: .love)
        self.funny       = try container.decodeIfPresent(Int.self, forKey: .funny)
        self.confusing   = try container.decodeIfPresent(Int.self, forKey: .confusing)
        self.informative = try container.decodeIfPresent(Int.self, forKey: .informative)
        self.wellWritten = try container.decodeIfPresent(Int.self, forKey: .wellWritten)
        self.creative    = try container.decodeIfPresent(Int.self, forKey: .creative)
    }
    
    // MARK: Initializers
    init() {}
}

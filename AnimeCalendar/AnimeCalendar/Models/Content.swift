//
//  Content.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 28/03/23.
//

import Foundation

/**
 Content should be used directly. Replace the **id** on the subclass if needed. (Trailer uses a different field to identify itself).
 Use this superclass for all the **visible cell data**
 */
class Content: Hashable, Decodable {
    // MARK: Parameters
    var id: String = UUID().uuidString
    var imageType: ContentImageType?

    // MARK: Parameter mapping
    enum CodingKeys: String, CodingKey {
        case id        = "mal_id"
        case imageType = "images"
    }

    // MARK: Decoding Technique
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id        = String(try container.decodeIfPresent(Int.self, forKey: .id) ?? 0)
        
        var imageType = try container.decodeIfPresent(ContentImageType.self, forKey: .imageType)
        imageType?.contentId = self.id
        self.imageType = imageType
    }
    
    init() {}
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Content, rhs: Content) -> Bool {
        return lhs.id == rhs.id
    }
    
    var feedSection: FeedSection = .unknown
    var detailFeedSection: DetailFeedSection = .unknown
}

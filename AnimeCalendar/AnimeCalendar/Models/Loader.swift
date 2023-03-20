//
//  Loader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 10/03/23.
//

import Foundation

struct Loader: ModelSectionable {
    var uuid = UUID()
    var isLoading: Bool = false

    // MARK: Parameters

    // MARK: Parameter mapping
    // MARK: Decoding Technique

    // MARK: Initializers

    var detailFeedSection: DetailFeedSection = .animeBasicInfo
    var feedSection: FeedSection = .animePromos
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: Loader, rhs: Loader) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

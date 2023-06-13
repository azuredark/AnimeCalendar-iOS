//
//  SynopsisContent.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 11/06/23.
//

final class SynopsisContent: Content {
    // MARK: Parameters
    var synopsis: String

    // MARK: Initializers
    init?(synopsis: String, detailSection: DetailFeedSection) {
        if synopsis.isNotEmpty {
            self.synopsis = synopsis
        } else { return nil }
        
        super.init(detailFeedSection: detailSection)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

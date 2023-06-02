//
//  ACContentLoader.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 1/06/23.
//

import Foundation

final class ACContentLoader: Content {
    // MARK: Initializers
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    init(detailFeedSection: DetailFeedSection) {
        super.init()
        
        self.detailFeedSection = detailFeedSection
    }
    
    init(feedSection: FeedSection) {
        super.init()
        
        self.feedSection = feedSection
    }
}

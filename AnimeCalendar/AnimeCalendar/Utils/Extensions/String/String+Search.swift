//
//  String+Search.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 26/12/22.
//

import Foundation

extension String {
    
    /// Get the video Id from a youtube URL.
    ///
    /// URL input example: *https://www.youtube.com/watch?v=e8YBesRKq_U*
    /// - Returns: Youtube's video Id.
    func getYoutubeId() -> String? {
        guard let delimiterIndex = self.firstIndex(where: { String($0) == "=" }) else {
            return nil
        }
        
        var id = String(self[delimiterIndex...])
        id.removeFirst() // Remove "="
        
        return id
    }
}

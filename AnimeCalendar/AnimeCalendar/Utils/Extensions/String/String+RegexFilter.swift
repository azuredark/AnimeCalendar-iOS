//
//  String+RegexFilter.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 23/12/22.
//

import Foundation

// https://www.codexpedia.com/regex/regex-symbol-list-and-regex-examples/
// https://nshipster.com/swift-regular-expressions/

// MARK: - Filter blacklisted characters.
extension String {
    /// Filter **blacklisted characters** with a custom **replacement**.
    /// - Parameter blacklist: Blacklisted type.
    /// - Parameter replace: Value to replace with.
    /// - Returns: New **String** with its **banned** characters replaced.
    func filterV2(by blackList: [BlackList], replace: ReplaceType) -> String {
        // Blacklist must have elements
        guard !blackList.isEmpty else { return "\(self)"}
        
        /// Final **regex** expression.
        let regex: String = "[\(blackList.map { getRegex(with: $0) }.joined())]"
        Logger.log(.info, msg: "Final regex: \(regex)", active: false)

        
        /// Letters to replace **blacklisted characters** with.
        let replacement: String = Self.getReplacerString(with: replace)
        
        return self.replacingOccurrences(of: regex, with: replacement, options: .regularExpression)
    }
     
    /// Filter **blacklisted** characters and replaced them.
    /// - Parameter blacklist: List of banned characters.
    /// - Returns: New depurated **String**
    @available(*, deprecated, message: "Use filterV2(blacklist:replace) instead for accurate results" )
    func filter(by blackList: [BlackList]) -> String {
        guard !blackList.isEmpty else { return self }
        // Global & multi-line (Greedy matching all):
        // -> / REGEX /gm"
        
        /// Create the regex from the **BlackList**
        //  let regex: String = "/\(blackList.map { getRegex(with: $0) }.joined())/gm"
        let regex: String = "[\(blackList.map { getRegex(with: $0) }.joined())]"
        
        /// Get all the matching ranges
        let matchRanges: [Range<Index>] = matches(for: regex)
        
        /// Update the matching indexes/characters of the String with a custom value.
        let replacedString: String = replace(ranges: matchRanges, with: .space)
        
        return replacedString
    }
    
    /// Create the regex from the *blacklist*.
    /// - Parameter blackList: Type of characters to omit.
    /// - Returns: Regex for given blacklist.
    private func getRegex(with blackList: BlackList) -> String {
        var regex: String = ""
        
        switch blackList {
            case .letters(let letterStyle):
                regex += "\(filterLetter(by: letterStyle))"
            case .numbers:
                regex += "0-9"
            case .spaces:
                regex += "\\s" // Needs 2 scapes to override swift's default.
            case .special(let blackListed):
                let blackList = blackListed.flatMap { $0.asList }
                regex += "\(Self.parseSpecialElements(blackList))"
        }
        
        return regex
    }
    
    /// Creates regex by letter type *(LowerCase, UpperCase or all cases)*.
    /// - Parameter filter: The LetterStyle filter.
    /// - Returns: Regex.
    private func filterLetter(by filter: LetterStyle) -> String {
        switch filter {
            case .lowerCase:
                return "a-z"
            case .upperCase:
                return "A-Z"
            case .all:
                return "a-zA-Z"
        }
    }
   
    /// Take list of special elements and parse it into regex - i.e.: ["%", ",", ":"] -> **"[%,:]+"**
    private static func parseSpecialElements(_ elements: [String]) -> String {
        return "\(elements.map { "\($0)" }.joined(separator: ""))"
    }
    
    /// Finds all occurrences from the **regex** and returns a list of its **ranges**.
    /// - Parameter regex: Final **regex** to use.
    /// - Returns: List of Range<Index> whih contain each **index occurrence**.
    private func matches(for regex: String) -> [Range<Index>] {
        print("senku [DEBUG] \(String(describing: type(of: self))) - Text: \(self)")
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .anchorsMatchLines)
            /// List of **occurences** of **regex** in a **String** range.
            /// *Array<NSTextCheckingResult>*
            /// List of **[NSRange]** alike.
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            print("senku [DEBUG] \(String(describing: type(of: self))) - Matches count: \(results.count)")
            
            /// Transform NSRange (ObjC) to Range (Swift).
            let nsRangeToRange: (NSRange) -> Range? = { Range($0, in: self) }
            
            /// Array<Range> of occurrences.
            let ranges: [Range<Index>] = results.compactMap { nsRangeToRange($0.range) }
            
            return ranges
            
            /// The *string* from the given ranges.
            //  let stringsFromRanges: [String] = ranges.compactMap { String(self[$0]) }
        } catch {
            print("senku [❌] \(String(describing: type(of: self))) - Error regex.")
            return []
        }
    }
    
    /// Replace the occurrences with a value
    /// - Parameter ranges: List of Range<Index> whih contain each **index occurrence**.
    /// - Parameter replacer: Represents the value to swap the **occurrences** with.
    /// - Returns: Final **String** with all the **blacklist** characters replaced.
    private func replace(ranges: [Range<Index>], with replacer: ReplaceType) -> String {
        /// String to replace the *occurrences* with.
        let replacer: String = Self.getReplacerString(with: replacer)
        
        /// Output final text
        var finalText: String = ""
        
        /// Copy of the original text
        let originalText: String = "\(self)"
        
        /// Index to keep track of the ranges.
        var i: Int = 0
        
        for (indexInt, character) in originalText.enumerated() {
            /// Turn the int. iterator value into an Index from the *orginalText*.
            let index = originalText.index(originalText.startIndex, offsetBy: indexInt)
            
            // If indexes match, then replace them
            if i < ranges.count, index == ranges[i].lowerBound {
                finalText += replacer
                i += 1
            } else {
                // If not, append the original index.
                finalText += String(character)
            }
        }

        return finalText
    }
    
    /// Get replacer value from the ReplacerType.
    /// - Parameter replacer: Replacing enum. to transform.
    /// - Returns: Replacer as String.
    private static func getReplacerString(with replacer: ReplaceType) -> String {
        switch replacer {
            case .none:
                return ""
            case .space:
                return " "
            case .custom(let string):
                return string
        }
    }
}

/// Special common blacklist-characters.
enum CommonSpecialCharacter: String, CaseIterable {
    case semiColon = ";"
    case colon = ":"
    case comma = ","
    case asterisk = "*"
    case dollar = "$"
    case at = "@"
    case all
    
    var asList: [String] {
        if self == .all {
            return self.asList.reduce([String]()) { partialResult, next in
                var a = partialResult
                a.append(next)
                return a
            }
        }
        
        return Array(repeating: self.rawValue, count: 1)
    }
}

/// Values not permited in String
enum BlackList {
    case letters(LetterStyle)
    case numbers
    case spaces
    case special([CommonSpecialCharacter])
}

///
enum LetterStyle {
    case lowerCase
    case upperCase
    case all
}

/// Values to replace regex **occurrences** with.
enum ReplaceType {
    case none
    case space
    case custom(String)
}

//
//  ACFilterValues.swift
//  AnimeCalendar
//
//  Created by Leonardo  on 27/05/23.
//

import CoreImage

enum FilterValues {
    case radius(_ value: CGFloat)

    typealias CIKeyValue = (key: String, value: Any)
    var ciValue: CIKeyValue {
        switch self {
            case .radius(let value):
                return (key: kCIInputRadiusKey, value: value)
        }
    }
}

//
//  SnowGlobeSensitivity.swift
//  SnowGlobe
//
//  Created by Jan Dammshäuser on 08.11.17.
//  Copyright © 2017 stringCode. All rights reserved.
//

import Foundation

/// The SnowGlobeSensitivity defines how hard you have to shake the device in order to make it snow.
///
/// - ultraLow: 1.7
/// - low: 2
/// - medium: 3 (default)
/// - high: 4
/// - custom: enter your own sensitivity value. Has to be positive.
public enum SnowGlobeSensitivity {
    case ultraLow, low, medium, high
    case custom(Double)

    fileprivate var value: Double {
        switch self {
        case .ultraLow: return 1.7
        case .low: return 2
        case .medium: return 3
        case .high: return 4
        case let .custom(sensitivity) where sensitivity > 0: return sensitivity
        case .custom: return 0
        }
    }
}

func >=(lhs: Double, rhs: SnowGlobeSensitivity) -> Bool {
    return lhs >= rhs.value
}

//
//  KeyboardShiftState.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2019-07-04.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This enum lists the various shift states a keyboard can use.
 */
public enum KeyboardShiftState: String, Identifiable {
    
    case
    lowercased,
    uppercased,
    capsLocked
}

public extension KeyboardShiftState {
    
    var id: String { rawValue }
    
    var isUppercased: Bool {
        switch self {
        case .lowercased: return false
        case .uppercased, .capsLocked: return true
        }
    }
}

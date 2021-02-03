//
//  SymbolicKeyboardInputSet.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This input set can be used in symbolic keyboards.
 */
public class SymbolicKeyboardInputSet: KeyboardInputSet {}

public extension SymbolicKeyboardInputSet {
    
    static func standard(for device: UIDevice = .current, currencies: [String]) -> SymbolicKeyboardInputSet {
        SymbolicKeyboardInputSet(rows: [
            standardTopRow(for: device),
            standardCenterRow(for: device, currencies: currencies),
            standardBottomRow(for: device)
        ])
    }
    
    static func standardTopRow(for device: UIDevice) -> [String] {
        device.isPad ? "1234567890`".chars : "[]{}#%^*+=".chars
    }
    
    static func standardCenterRow(for device: UIDevice, currencies: [String]) -> [String] {
        device.isPad
            ? currencies + "^[]{}—˚…".chars
            : "_\\|~<>".chars + currencies + ["•"]
    }
    
    static func standardBottomRow(for device: UIDevice) -> [String] {
        device.isPad ? "§|~≠\\<>!?".chars : ".,?!’".chars
    }
}

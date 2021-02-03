//
//  NumericKeyboardInputSet.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This input set can used in numeric keyboards.
 */
public class NumericKeyboardInputSet: KeyboardInputSet {}

public extension NumericKeyboardInputSet {
    
    static func standard(for device: UIDevice = .current, currency: String) -> NumericKeyboardInputSet {
        NumericKeyboardInputSet(rows: [
            standardTopRow(for: device),
            standardCenterRow(for: device, currency: currency),
            standardBottomRow(for: device)
        ])
    }
    
    static func standardTopRow(for device: UIDevice) -> [String] {
        device.isPad ? "1234567890`".chars : "1234567890".chars
    }
    
    static func standardCenterRow(for device: UIDevice, currency: String) -> [String] {
        device.isPad
            ? "@#".chars + [currency] + "&*()’”+•".chars
            : "-/:;()".chars + [currency] + "&@\"".chars
    }
    
    static func standardBottomRow(for device: UIDevice) -> [String] {
        device.isPad ? "%_-=/;:,.".chars : ".,?!’".chars
    }
}

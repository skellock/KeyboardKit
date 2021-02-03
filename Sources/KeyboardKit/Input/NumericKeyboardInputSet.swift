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
        NumericKeyboardInputSet(inputRows: [
            standardTopRow(for: device),
            standardCenterRow(for: device, currency: currency),
            standardBottomRow(for: device)
        ])
    }
    
    static func standardTopRow(for device: UIDevice) -> [String] {
        device.isIpad ? "1234567890`".chars : "1234567890".chars
    }
    
    static func standardCenterRow(for device: UIDevice, currency: String) -> [String] {
        device.isIpad
            ? "@#".chars + [currency] + "&*()’”+•".chars
            : "-/:;()".chars + [currency] + "&@\"".chars
    }
    
    static func standardBottomRow(for device: UIDevice) -> [String] {
        device.isIpad ? "%_-=/;:,.".chars : ".,?!’".chars
    }
}

private extension UIDevice {
    
    var isIpad: Bool { userInterfaceIdiom == .pad }
}

private extension String {
    
    var chars: [String] { self.map { String($0) } }
}

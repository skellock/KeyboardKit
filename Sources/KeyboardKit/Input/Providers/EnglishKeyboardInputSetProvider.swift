//
//  EnglishKeyboardInputSetProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This class provides English keyboard input sets.
 */
public class EnglishKeyboardInputSetProvider: KeyboardInputSetProvider {
    
    public init(device: UIDevice = .current) {
        self.device = device
    }
    
    private let device: UIDevice
    
    public func alphabeticInputSet() -> AlphabeticKeyboardInputSet {
        AlphabeticKeyboardInputSet(inputRows: [
            "qwertyuiop".chars,
            "asdfghjkl".chars,
            bottomRow
        ])
    }
    
    public func numericInputSet() -> NumericKeyboardInputSet {
        .standard(currency: "$")
    }
    
    public func symbolicInputSet() -> SymbolicKeyboardInputSet {
        .standard(currencies: "€£¥".chars)
    }
}

private extension EnglishKeyboardInputSetProvider {
    
    var bottomRow: [String] {
        AlphabeticKeyboardInputSet.standardBottomRow(
            for: device,
            inputs: "zxcvbnm".chars)
    }
}


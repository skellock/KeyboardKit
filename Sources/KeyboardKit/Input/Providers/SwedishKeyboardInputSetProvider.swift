//
//  SwedishKeyboardInputSetProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This class provides Swedish keyboard input sets.
 */
public class SwedishKeyboardInputSetProvider: KeyboardInputSetProvider {
    
    public init(device: UIDevice = .current) {
        self.device = device
    }
    
    private let device: UIDevice
    
    public func alphabeticInputSet() -> AlphabeticKeyboardInputSet {
        AlphabeticKeyboardInputSet(inputRows: [
            "qwertyuiopå".chars,
            "asdfghjklöä".chars,
            bottomRow
        ])
    }
    
    public func numericInputSet() -> NumericKeyboardInputSet {
        .standard(currency: "kr")
    }
    
    public func symbolicInputSet() -> SymbolicKeyboardInputSet {
        .standard(currencies: "€$£".chars)
    }
}

private extension SwedishKeyboardInputSetProvider {
    
    var bottomRow: [String] {
        AlphabeticKeyboardInputSet.standardBottomRow(
            for: device,
            inputs: "zxcvbnm".chars)
    }
}

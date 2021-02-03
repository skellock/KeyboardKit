//
//  GermanKeyboardInputSetProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This class provides German keyboard input sets.
 */
public class GermanKeyboardInputSetProvider: KeyboardInputSetProvider {
    
    public init(device: UIDevice = .current) {
        self.device = device
    }
    
    private let device: UIDevice
    
    public func alphabeticInputSet() -> AlphabeticKeyboardInputSet {
        AlphabeticKeyboardInputSet(rows: [
            "qwertzuiopü".chars,
            "asdfghjklöä".chars,
            device.isPad ? "yxcvbnm,.ß".chars : "yxcvbnm".chars
        ])
    }
    
    public func numericInputSet() -> NumericKeyboardInputSet {
        .standard(currency: "€")
    }
    
    public func symbolicInputSet() -> SymbolicKeyboardInputSet {
        .standard(currencies: "$£¥".chars)
    }
}

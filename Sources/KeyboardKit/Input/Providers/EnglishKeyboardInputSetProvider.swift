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
public class EnglishKeyboardInputSetProvider: DeviceSpecificInputSetProvider {
    
    public init(device: UIDevice = .current) {
        self.device = device
    }
    
    public let device: UIDevice
    
    public func alphabeticInputSet() -> AlphabeticKeyboardInputSet {
        AlphabeticKeyboardInputSet(rows: [
            "qwertyuiop".chars,
            "asdfghjkl".chars,
            "zxcvbnm\(device.isPhone ? "" : ",.")".chars
        ])
    }
    
    public func numericInputSet() -> NumericKeyboardInputSet {
        NumericKeyboardInputSet(rows: [
            "1234567890".chars,
            row(phone: "-/:;()$&@“", pad: "@#$&*()’”"),
            row(phone: ".,?!’", pad: "%-+=/;:,.")
        ])
    }
    
    public func symbolicInputSet() -> SymbolicKeyboardInputSet {
        SymbolicKeyboardInputSet(rows: [
            row(phone: "[]{}#%^*+=", pad: "1234567890"),
            row(phone: "_\\|~<>€£¥•", pad: "€£¥_^[]{}"),
            row(phone: ".,?!’", pad: "§|~…\\<>!?")
        ])
    }
}

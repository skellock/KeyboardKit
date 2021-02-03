//
//  AlphabeticKeyboardInputSet.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

/**
 This input set can be used in alphabetic keyboards.
 */
public class AlphabeticKeyboardInputSet: KeyboardInputSet {}

public extension AlphabeticKeyboardInputSet {

    static func standardBottomRow(for device: UIDevice = .current, inputs: [String]) -> [String] {
        device.isPad ? inputs + ",.".chars : inputs
    }
}

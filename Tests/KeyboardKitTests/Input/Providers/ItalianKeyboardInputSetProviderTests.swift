//
//  ItalianKeyboardInputSetProviderTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-03.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import UIKit
@testable import KeyboardKit

class ItalianKeyboardInputSetProviderTests: QuickSpec {
    
    override func spec() {
        
        var device: MockDevice!
        var provider: KeyboardInputSetProvider!
        
        beforeEach {
            device = MockDevice()
            provider = ItalianKeyboardInputSetProvider(device: device)
        }
        
        describe("input set provider") {
            
            it("has correct alphabetic input set for phone") {
                device.userInterfaceIdiomValue = .phone
                let result = provider.alphabeticInputSet()
                expect(result.rows).to(equal([
                    "qwertyuiop".chars,
                    "asdfghjkl".chars,
                    "zxcvbnm".chars
                ]))
            }
            
            it("has correct alphabetic input set for pad") {
                device.userInterfaceIdiomValue = .pad
                let result = provider.alphabeticInputSet()
                expect(result.rows).to(equal([
                    "qwertyuiop".chars,
                    "asdfghjkl".chars,
                    "zxcvbnm,.".chars
                ]))
            }
            
            it("has correct numeric input set") {
                let rows = provider.numericInputSet().rows
                let expected = NumericKeyboardInputSet.standard(currency: "€").rows
                expect(rows).to(equal(expected))
            }
            
            it("has correct symbolic input set") {
                let rows = provider.symbolicInputSet().rows
                let expected = SymbolicKeyboardInputSet.standard(currencies: ["$", "£", "¥"]).rows
                expect(rows).to(equal(expected))
            }
        }
    }
}

//
//  AlphabeticKeyboardInputSetTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-03.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
@testable import KeyboardKit

class AlphabeticKeyboardInputSetTests: QuickSpec {
    
    override func spec() {
        
        var device: MockDevice!
        
        beforeEach {
            device = MockDevice()
        }
        
        describe("standard bottom row") {
            
            it("is valid for iPhone") {
                device.userInterfaceIdiomValue = .phone
                let row = AlphabeticKeyboardInputSet.standardBottomRow(for: device, inputs: ["a", "b", "c"])
                expect(row.joined(separator: "")).to(equal("abc"))
            }
            
            it("is valid for iPad") {
                device.userInterfaceIdiomValue = .pad
                let row = AlphabeticKeyboardInputSet.standardBottomRow(for: device, inputs: ["a", "b", "c"])
                expect(row.joined(separator: "")).to(equal("abc,."))
            }
        }
    }
}

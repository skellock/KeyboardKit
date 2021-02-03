//
//  NumericKeyboardInputSetTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-03.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import KeyboardKit

class NumericKeyboardInputSetTests: QuickSpec {
    
    override func spec() {
        
        var device: MockDevice!
        
        beforeEach {
            device = MockDevice()
        }
        
        describe("standard") {
            
            context("for iPhone") {
                
                beforeEach {
                    device.userInterfaceIdiomValue = .phone
                }
                
                func validate(rows: [KeyboardInputSet.InputRow], for currency: String) -> Bool {
                    rows == [
                        "1234567890".chars,
                        "-/:;()".chars + [currency] + "&@\"".chars,
                        ".,?!’".chars
                    ]
                }
                
                it("is valid for Euro currency") {
                    let currency = "€"
                    let rows = NumericKeyboardInputSet.standard(for: device, currency: currency).inputRows
                    expect(validate(rows: rows, for: currency)).to(beTrue())
                }
                
                it("is valid for Swedish currency") {
                    let currency = "kr"
                    let rows = NumericKeyboardInputSet.standard(for: device, currency: currency).inputRows
                    expect(validate(rows: rows, for: currency)).to(beTrue())
                }
            }
            
            context("for iPad") {
                
                beforeEach {
                    device.userInterfaceIdiomValue = .pad
                }
                
                func validate(rows: [KeyboardInputSet.InputRow], for currency: String) -> Bool {
                    rows == [
                        "1234567890`".chars,
                        "@#".chars + [currency] + "&*()’”+•".chars,
                        "%_-=/;:,.".chars
                    ]
                }
                
                it("is valid for Euro currency") {
                    let currency = "€"
                    let rows = NumericKeyboardInputSet.standard(for: device, currency: currency).inputRows
                    expect(validate(rows: rows, for: currency)).to(beTrue())
                }
                
                it("is valid for Swedish currency") {
                    let currency = "kr"
                    let rows = NumericKeyboardInputSet.standard(for: device, currency: currency).inputRows
                    expect(validate(rows: rows, for: currency)).to(beTrue())
                }
            }
        }
    }
}

private extension String {
    
    var chars: [String] { self.map { String($0) } }
}

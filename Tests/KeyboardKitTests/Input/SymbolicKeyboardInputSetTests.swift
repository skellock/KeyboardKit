//
//  SymbolicKeyboardInputSetTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-03.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import KeyboardKit

class SymbolicKeyboardInputSetTests: QuickSpec {
    
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
                
                func validate(rows: [KeyboardInputSet.InputRow], for currencies: [String]) -> Bool {
                    rows == [
                        "[]{}#%^*+=".chars,
                        "_\\|~<>".chars + currencies + ["•"],
                        ".,?!’".chars
                    ]
                }
                
                it("is valid for European currencies") {
                    let currencies = ["€", "£", "¥"]
                    let rows = SymbolicKeyboardInputSet.standard(for: device, currencies: currencies).inputRows
                    expect(validate(rows: rows, for: currencies)).to(beTrue())
                }
                
                it("is valid for Swedish currency") {
                    let currencies = ["€", "$", "£"]
                    let rows = SymbolicKeyboardInputSet.standard(for: device, currencies: currencies).inputRows
                    expect(validate(rows: rows, for: currencies)).to(beTrue())
                }
            }
            
            context("for iPad") {
                
                beforeEach {
                    device.userInterfaceIdiomValue = .pad
                }
                
                func validate(rows: [KeyboardInputSet.InputRow], for currencies: [String]) -> Bool {
                    rows == [
                        "1234567890`".chars,
                        currencies + "^[]{}—˚…".chars,
                        "§|~≠\\<>!?".chars
                    ]
                }
                
                it("is valid for European currencies") {
                    let currencies = ["€", "£", "¥"]
                    let rows = SymbolicKeyboardInputSet.standard(for: device, currencies: currencies).inputRows
                    expect(validate(rows: rows, for: currencies)).to(beTrue())
                }
                
                it("is valid for Swedish currency") {
                    let currencies = ["€", "$", "£"]
                    let rows = SymbolicKeyboardInputSet.standard(for: device, currencies: currencies).inputRows
                    expect(validate(rows: rows, for: currencies)).to(beTrue())
                }
            }
        }
    }
}

private extension String {
    
    var chars: [String] { self.map { String($0) } }
}

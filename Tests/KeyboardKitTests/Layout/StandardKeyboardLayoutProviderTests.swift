//
//  StandardKeyboardLayoutProviderTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import KeyboardKit

class StandardKeyboardLayoutProviderTests: QuickSpec {
    
    override func spec() {
        
        describe("standard keyboard input set provider") {
            
            var inputSet: AlphabeticKeyboardInputSet!
            var provider: StandardKeyboardLayoutProvider!
            var context: MockKeyboardContext!
            var rows: KeyboardActionRows!
            
            beforeEach {
                context = MockKeyboardContext()
                provider = StandardKeyboardLayoutProvider(
                    context: context,
                    inputSetProvider: StandardKeyboardInputSetProvider(context: context),
                    leftSpaceAction: .done,
                    rightSpaceAction: .escape)
                inputSet = EnglishKeyboardInputSetProvider().alphabeticInputSet()
                rows = KeyboardActionRows(characters: inputSet.inputRows)
            }
            
            func verifyStandardPhoneResult(_ result: KeyboardActionRows) {
                expect(result[0]).to(equal(rows[0]))
                expect(result[1]).to(equal(rows[1]))
                let lower = result[2]
                let lowerFirst = lower.first
                let lowerLast = lower.last
                let lowerCenter = lower.filter { $0 != lowerFirst && $0 != lowerLast }
                expect(lowerFirst).to(equal(KeyboardAction.shift(currentState: .lowercased)))
                expect(lowerCenter).to(equal(rows[2]))
                expect(lowerLast).to(equal(.backspace))
            }
            
            it("is correct for a home button phone") {
                context.needsInputModeSwitchKey = true
                let result = provider.keyboardLayout(iPad: false, rows: rows).rows
                verifyStandardPhoneResult(result)
                let bottom: [KeyboardAction] = [.keyboardType(.numeric), .nextKeyboard, .done, .space, .escape, .newLine]
                expect(result[3]).to(equal(bottom))
            }
            
            it("is correct for a notch phone") {
                context.needsInputModeSwitchKey = false
                let result = provider.keyboardLayout(iPad: false, rows: rows).rows
                verifyStandardPhoneResult(result)
                let bottom: [KeyboardAction] = [.keyboardType(.numeric), .done, .space, .escape, .newLine]
                expect(result[3]).to(equal(bottom))
            }
            
            it("is correct for a home button pad") {
                context.needsInputModeSwitchKey = true
                let result = provider.keyboardLayout(iPad: true, rows: rows).rows
                expect(result[0].first).to(equal(KeyboardAction.character("q")))
                expect(result[0].last).to(equal(.backspace))
                expect(result[1].first).to(equal(KeyboardAction.character("a")))
                expect(result[1].last).to(equal(.newLine))
                expect(result[2].first).to(equal(KeyboardAction.shift(currentState: .lowercased)))
                expect(result[2].last).to(equal(KeyboardAction.shift(currentState: .lowercased)))
                let bottom: [KeyboardAction] = [.keyboardType(.numeric), .nextKeyboard, .done, .space, .escape, .keyboardType(.numeric), .dismissKeyboard]
                expect(result[3]).to(equal(bottom))
            }
            
            it("is correct for a non-home button pad") {
                context.needsInputModeSwitchKey = false
                let result = provider.keyboardLayout(iPad: true, rows: rows).rows
                let expectedKeyboardType = KeyboardAction.keyboardType(.alphabetic(.capsLocked))
                expect(result[0].first).to(equal(.tab))
                expect(result[0].last).to(equal(.backspace))
                expect(result[1].first).to(equal(expectedKeyboardType))
                expect(result[1].last).to(equal(.newLine))
                expect(result[2].first).to(equal(KeyboardAction.shift(currentState: .lowercased)))
                expect(result[2].last).to(equal(KeyboardAction.shift(currentState: .lowercased)))
                let bottom: [KeyboardAction] = [.nextKeyboard, .keyboardType(.numeric), .done, .space, .escape, .keyboardType(.numeric), .dismissKeyboard]
                expect(result[3]).to(equal(bottom))
            }
        }
    }
}

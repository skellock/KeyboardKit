//
//  BaseKeyboardLayoutProviderTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-11-30.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import CoreGraphics
import KeyboardKit
import SwiftUI

class BaseKeyboardLayoutProviderTests: QuickSpec {
    
    override func spec() {
        
        var context: MockKeyboardContext!
        var inputSetProvider: StandardKeyboardInputSetProvider!
        var provider: BaseKeyboardLayoutProvider!
        
        beforeEach {
            context = MockKeyboardContext()
            inputSetProvider = StandardKeyboardInputSetProvider(context: context)
            provider = BaseKeyboardLayoutProvider(
                context: context,
                inputSetProvider: inputSetProvider)
        }
        
        func expectedItem(for action: KeyboardAction) -> KeyboardLayoutItem {
            let size = provider.layoutSize(for: action, at: 0)
            let insets = EdgeInsets.standardKeyboardButtonInsets()
            return KeyboardLayoutItem(action: action, size: size, insets: insets)
        }
        
        func validateRows(in inputSet: KeyboardInputSet, rows: [KeyboardInputSet.InputRow]) {
            expect(inputSet.inputRows.count).to(equal(3))
            expect(inputSet.inputRows.count).to(equal(rows.count))
            expect(inputSet.inputRows[0].count).to(equal(rows[0].count))
            expect(inputSet.inputRows[1].count).to(equal(rows[1].count))
            expect(inputSet.inputRows[2].count).to(equal(rows[2].count))
        }
        
        describe("action rows") {
            
            it("is input rows mapped to action rows") {
                context.locale = LocaleKey.english.locale
                context.keyboardType = .alphabetic(.lowercased)
                let actionRows = provider.actionRows
                let inputRows = provider.inputRows
                expect(actionRows).to(equal(KeyboardActionRows(characters: inputRows)))
            }
        }
        
        describe("input rows") {
    
            it("is is valid for lowercased alphabetic keyboard type") {
                context.locale = LocaleKey.english.locale
                context.keyboardType = .alphabetic(.lowercased)
                let inputSet = inputSetProvider.alphabeticInputSet()
                let rows = provider.inputRows
                validateRows(in: inputSet, rows: rows)
                expect(inputSet.inputRows[0][0]).to(equal("q"))
                expect(rows[0][0]).to(equal("q"))
            }
            
            it("is is valid for uppercased alphabetic keyboard type") {
                context.locale = LocaleKey.english.locale
                context.keyboardType = .alphabetic(.uppercased)
                let inputSet = inputSetProvider.alphabeticInputSet()
                let rows = provider.inputRows
                validateRows(in: inputSet, rows: rows)
                expect(inputSet.inputRows[0][0]).to(equal("q"))
                expect(rows[0][0]).to(equal("Q"))
            }
            
            it("is is valid for numeric keyboard type") {
                context.keyboardType = .numeric
                let inputSet = inputSetProvider.numericInputSet()
                let rows = provider.inputRows
                validateRows(in: inputSet, rows: rows)
                expect(inputSet.inputRows[0][0]).to(equal("1"))
                expect(rows[0][0]).to(equal("1"))
            }
            
            it("is is valid for symbolic keyboard type") {
                context.keyboardType = .symbolic
                let inputSet = inputSetProvider.symbolicInputSet()
                let rows = provider.inputRows
                validateRows(in: inputSet, rows: rows)
                expect(inputSet.inputRows[0][0]).to(equal("["))
                expect(rows[0][0]).to(equal("["))
            }
            
            it("is is empty for other keyboard type") {
                context.keyboardType = .emojis
                let rows = provider.inputRows
                expect(rows.count).to(equal(0))
            }
        }
        
        describe("keyboard switcher action for bottom row") {
            
            func result(for type: KeyboardType) -> KeyboardAction? {
                context.keyboardType = type
                return provider.keyboardSwitcherActionForBottomRow
            }
            
            it("is valid for all supported keyboard types") {
                expect(result(for: .alphabetic(.lowercased))).to(equal(.keyboardType(.numeric)))
                expect(result(for: .alphabetic(.uppercased))).to(equal(.keyboardType(.numeric)))
                expect(result(for: .numeric)).to(equal(.keyboardType(.alphabetic(.lowercased))))
                expect(result(for: .symbolic)).to(equal(.keyboardType(.alphabetic(.lowercased))))
            }
            
            it("is nil for unsupported keyboard types") {
                expect(result(for: .emojis)).to(beNil())
            }
        }
        
        describe("keyboard switcher action for bottom input row") {
            
            func result(for type: KeyboardType) -> KeyboardAction? {
                context.keyboardType = type
                return provider.keyboardSwitcherActionForBottomInputRow
            }
            
            it("is valid for all supported keyboard types") {
                expect(result(for: .alphabetic(.lowercased))).to(equal(KeyboardAction.shift(currentState: .lowercased)))
                expect(result(for: .alphabetic(.uppercased))).to(equal(KeyboardAction.shift(currentState: .uppercased)))
                expect(result(for: .numeric)).to(equal(.keyboardType(.symbolic)))
                expect(result(for: .symbolic)).to(equal(.keyboardType(.numeric)))
            }
            
            it("is nil for unsupported keyboard types") {
                expect(result(for: .emojis)).to(beNil())
            }
        }
        
        describe("layout items for action rows") {
            
            func result(for rows: KeyboardActionRows) -> KeyboardLayoutItemRows {
                rows.map {
                    $0.map {
                        provider.layoutItem(for: $0, at: 0)
                    }
                }
            }
            
            it("is correct for all actions") {
                let row1: [KeyboardAction] = [.backspace, .dictation]
                let row2: [KeyboardAction] = [.space, .command]
                let items = result(for: [row1, row2])
                expect(items[0][0]).to(equal(expectedItem(for: .backspace)))
                expect(items[0][1]).to(equal(expectedItem(for: .dictation)))
                expect(items[1][0]).to(equal(expectedItem(for: .space)))
                expect(items[1][1]).to(equal(expectedItem(for: .command)))
            }
        }
        
        describe("layout items for actions") {
            
            func result(for actions: KeyboardActions) -> KeyboardLayoutItems {
                actions.map {
                    provider.layoutItem(for: $0, at: 0)
                }
            }
            
            it("is correct for all actions") {
                let items = result(for: [.backspace, .dictation])
                expect(items[0]).to(equal(expectedItem(for: .backspace)))
                expect(items[1]).to(equal(expectedItem(for: .dictation)))
            }
        }
        
        describe("layout item for action") {
            
            func result(for action: KeyboardAction) -> KeyboardLayoutItem {
                provider.layoutItem(for: action, at: 0)
            }
            
            it("is correct for all actions") {
                expect(result(for: .backspace)).to(equal(expectedItem(for: .backspace)))
                expect(result(for: .character("a"))).to(equal(expectedItem(for: .character("a"))))
                expect(result(for: .dictation)).to(equal(expectedItem(for: .dictation)))
            }
        }
        
        describe("layout size for action") {
            
            func result(for action: KeyboardAction, at row: Int) -> KeyboardLayoutItem.Size {
                provider.layoutSize(for: action, at: row)
            }
            
            func expectedSize(for width: KeyboardLayoutWidth) -> KeyboardLayoutItem.Size {
                let height = CGFloat.standardKeyboardRowHeight()
                return KeyboardLayoutItem.Size(width: width, height: height)
            }
            
            it("is correct for all actions") {
                expect(result(for: .character(""), at: 0)).to(equal(expectedSize(for: .reference(.available))))
                expect(result(for: .character(""), at: 1)).to(equal(expectedSize(for: .useReference)))
                expect(result(for: .backspace, at: 0)).to(equal(expectedSize(for: .available)))
            }
        }
        
        describe("layout width for action") {
            
            func result(for action: KeyboardAction, at row: Int) -> KeyboardLayoutWidth {
                provider.layoutWidth(for: action, at: row)
            }
            
            it("is reference for character actions at first row") {
                expect(result(for: .character(""), at: 0)).to(equal(.reference(.available)))
            }
            
            it("is from reference for other characters actions") {
                expect(result(for: .character(""), at: 1)).to(equal(.useReference))
                expect(result(for: .character(""), at: 2)).to(equal(.useReference))
            }
            
            it("is available for other actions") {
                expect(result(for: .backspace, at: 0)).to(equal(.available))
                expect(result(for: .space, at: 3)).to(equal(.available))
            }
        }
        
    }
}

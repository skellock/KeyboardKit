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
        
        var provider: BaseKeyboardLayoutProvider!
        
        beforeEach {
            provider = BaseKeyboardLayoutProvider()
        }
        
        func expectedItem(for action: KeyboardAction) -> KeyboardLayoutItem {
            let size = provider.layoutSize(for: action, at: 0)
            let insets = EdgeInsets.standardKeyboardButtonInsets()
            return KeyboardLayoutItem(action: action, size: size, insets: insets)
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
                expect(result(for: .character(""), at: 1)).to(equal(expectedSize(for: .fromReference)))
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
                expect(result(for: .character(""), at: 1)).to(equal(.fromReference))
                expect(result(for: .character(""), at: 2)).to(equal(.fromReference))
            }
            
            it("is available for other actions") {
                expect(result(for: .backspace, at: 0)).to(equal(.available))
                expect(result(for: .space, at: 3)).to(equal(.available))
            }
        }
        
    }
}

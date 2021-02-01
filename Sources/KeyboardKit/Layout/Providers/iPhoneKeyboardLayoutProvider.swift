//
//  iPhoneKeyboardLayoutProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This class provides keyboard layouts that corresponds to an
 iPhone device, regardless of it having a home button or not.
 
 You can inherit this class and override any implementations
 to customize the standard layout.
 
 `TODO` Unit test this class.
 
 `TODO` This class currently doesn't have landscape-specific
 item widths. This will be implemented in a future update.
 
 `TODO` The bottom-right button should not be `.newLine` but
 rather the `primary` action for the current context.
 */
open class iPhoneKeyboardLayoutProvider: BaseKeyboardLayoutProvider, KeyboardLayoutProvider {
    
    open override var actionRows: KeyboardActionRows {
        var rows = super.actionRows
        assert(rows.count > 0, "iPhone layouts require at least 1 input row.")
        let last = rows.last ?? []
        rows.removeLast()
        rows.append(lowerLeadingActions + last + lowerTrailingActions)
        rows.append(bottomActions)
        return rows
    }
    
    open var bottomActions: KeyboardActions {
        var result = KeyboardActions()
        if let action = keyboardSwitcherActionForBottomRow { result.append(action) }
        if needsInputSwitcher { result.append(.nextKeyboard) }
        if !needsInputSwitcher { result.append(.keyboardType(.emojis)) }
        if isPortrait, needsDictation, let action = dictationReplacement { result.append(action) }
        result.append(.space)
        result.append(.newLine) // TODO: Should be "primary"
        if isLandscape, needsDictation, let action = dictationReplacement { result.append(action) }
        return result
    }
    
    open var lowerLeadingActions: KeyboardActions {
        guard let action = keyboardSwitcherActionForBottomInputRow else { return [] }
        return [action, .none]
    }
    
    open var lowerTrailingActions: KeyboardActions {
        [.none, .backspace]
    }
    
    open override func layoutWidth(for action: KeyboardAction, at row: Int) -> KeyboardLayoutWidth {
        switch action {
        case dictationReplacement: return shortButtonWidth
        case .character: return isLastSymbolicInputRow(row) ? shortButtonWidth : super.layoutWidth(for: action, at: row)
        case .backspace: return mediumButtonWidth
        case .keyboardType: return shortButtonWidth
        case .nextKeyboard: return shortButtonWidth
        case .newLine: return longButtonWidth
        case .shift: return mediumButtonWidth
        default: return super.layoutWidth(for: action, at: row)
        }
    }
}

private extension iPhoneKeyboardLayoutProvider {
    
    var longButtonWidth: KeyboardLayoutWidth { .percentage(0.24) }
    
    var mediumButtonWidth: KeyboardLayoutWidth { shortButtonWidth }
    
    var shortButtonWidth: KeyboardLayoutWidth { .percentage(0.11) }
    
    func isLastSymbolicInputRow(_ row: Int) -> Bool {
        let isNumeric = context.keyboardType == .numeric
        let isSymbolic = context.keyboardType == .symbolic
        guard isNumeric || isSymbolic else { return false }
        return row == 2 // Index 2 is the "wide keys" row
    }
}

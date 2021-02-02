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
 iPhone device.
 
 You can inherit this class and override any implementations
 to customize the standard layout.
 */
open class iPhoneKeyboardLayoutProvider: BaseKeyboardLayoutProvider, KeyboardLayoutProvider {
    
    public init(
        context: KeyboardContext,
        inputSetProvider: KeyboardInputSetProvider,
        dictationReplacement: KeyboardAction? = nil) {
        self.dictationReplacement = dictationReplacement
        super.init(context: context, inputSetProvider: inputSetProvider)
    }
    
    private let dictationReplacement: KeyboardAction?
    
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
        let short = KeyboardLayoutWidth.percentage(0.11)
        switch action {
        case dictationReplacement: return short
        case .backspace: return short
        case .keyboardType: return short
        case .nextKeyboard: return short
        case .newLine: return short
        case .shift: return short
        default: return super.layoutWidth(for: action, at: row)
        }
    }
}

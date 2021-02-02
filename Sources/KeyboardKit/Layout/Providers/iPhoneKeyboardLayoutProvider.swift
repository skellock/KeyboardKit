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
 iPhone device with a home button.
 
 This may not always be what you want. If you want to create
 keyboards with a custom layout, you should either not use a
 layout provider, or create a custom one.
 
 You can inherit this class and override any implementations
 to customize the standard layout.
 */
open class iPhoneKeyboardLayoutProvider: BaseKeyboardLayoutProvider, KeyboardLayoutProvider {
    
    public init(
        context: KeyboardContext,
        inputSetProvider: KeyboardInputSetProvider,
        dictationReplacement: KeyboardAction? = nil) {
        super.init(context: context, inputSetProvider: inputSetProvider)
    }
    
    open override var actionRows: KeyboardActionRows {
        var rows = super.actionRows
        assert(rows.count > 0, "iPhone layouts require at least 1 input row.")
        let last = rows.last ?? []
        rows.removeLast()
        rows.append(lowerLeadingActions + last + lowerLeadingActions)
        rows.append(bottomActions)
        return rows
    }
    
    open var bottomActions: KeyboardActions {
        var result = KeyboardActions()
        let switcher = keyboardSwitcherActionForBottomRow
        
        if let action = switcher {
            result.append(action)
        }
        if context.needsInputModeSwitchKey {
            result.append(.nextKeyboard)
        }
        /*if isDictationSupported {
            result.append(.dictation)
        }
        if let action = leftSpaceAction {
            result.append(action)
        }
        result.append(.space)
        if let action = rightSpaceAction {
            result.append(action)
        }*/
        result.append(.newLine)
        
        return result
    }
    
    open var lowerLeadingActions: KeyboardActions {
        guard let action = keyboardSwitcherActionForBottomInputRow else { return [] }
        return [action]
    }
    
    open var lowerTrailingActions: KeyboardActions {
        [.backspace]
    }
}

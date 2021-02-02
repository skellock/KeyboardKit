//
//  iPadKeyboardLayoutProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This class provides keyboard layouts that corresponds to an
 iPad device with a home button.
 
 You can inherit this class and override any implementations
 to customize the standard layout.
 
 `TODO` Unit test this class.
 
 `TODO` This class is currently used for iPad Air and Pro as
 well. These devices should have a separate layout provider.
 
 `TODO` This class currently doesn't have landscape-specific
 item widths. This will be implemented in a future update.
 
 `TODO` The bottom-right button should not be `.newLine` but
 rather the `primary` action for the current context.
 */
open class iPadKeyboardLayoutProvider: BaseKeyboardLayoutProvider, KeyboardLayoutProvider {
    
    open override var actionRows: KeyboardActionRows {
        var rows = super.actionRows
        assert(rows.count > 2, "iPad layouts require at least 3 input row.")
        let last = rows.suffix(3)
        rows.removeLast(3)
        rows.append(last[0] + [.backspace])
        rows.append([.none] + last[1] + [.newLine])
        rows.append(lowerLeadingActions + last[2] + lowerTrailingActions)
        rows.append(bottomActions)
        return rows
    }
    
    open override var inputRows: [KeyboardInputSet.InputRow] {
        var rows = super.inputRows
        assert(rows.count > 2, "iPad layouts require at least 3 input row.")
        rows[2].append(",")
        rows[2].append(".")
        return rows
    }
    
    open var bottomActions: KeyboardActions {
        var result = KeyboardActions()
        if let action = keyboardSwitcherActionForBottomRow { result.append(action) }
        result.append(.nextKeyboard)
        if needsDictation, let action = dictationReplacement { result.append(action) }
        result.append(.space)
        if let action = keyboardSwitcherActionForBottomRow { result.append(action) }
        result.append(.dismissKeyboard)
        return result
    }
    
    open var lowerLeadingActions: KeyboardActions {
        guard let action = keyboardSwitcherActionForBottomInputRow else { return [] }
        return [action, .none]
    }
    
    open var lowerTrailingActions: KeyboardActions {
        guard let action = keyboardSwitcherActionForBottomInputRow else { return [] }
        return [.none, action]
    }
    
    open override func layoutWidth(for action: KeyboardAction, at row: Int) -> KeyboardLayoutWidth {
        switch action {
        //case dictationReplacement: return shortButtonWidth
        //case .backspace: return mediumButtonWidth
        //case .keyboardType: return shortButtonWidth
        //case .nextKeyboard: return shortButtonWidth
        //case .newLine: return longButtonWidth
        //case .shift: return mediumButtonWidth
        default: return super.layoutWidth(for: action, at: row)
        }
    }
}

private extension iPadKeyboardLayoutProvider {
    
    var longButtonWidth: KeyboardLayoutWidth {
        /*isPortrait ?*/ .percentage(0.24) // : .percentage(0.15)
    }
    
    var mediumButtonWidth: KeyboardLayoutWidth {
        /*isPortrait ?*/ shortButtonWidth // : .percentage(0.13)
    }
    
    var shortButtonWidth: KeyboardLayoutWidth {
        /*isPortrait ?*/ .percentage(0.11) // : .percentage(0.11)
    }
}

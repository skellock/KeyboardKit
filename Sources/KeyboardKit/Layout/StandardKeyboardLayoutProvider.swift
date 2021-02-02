//
//  StandardKeyboardLayoutProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI
import UIKit

/**
 This keyboard layout provider bases its layout decisions on
 factors like locale, device and screen orientation.
 
 This may not always be what you want. If you want to create
 keyboards with a custom layout, you should either not use a
 layout provider, or create a custom one.
 
 You can inherit this class and override any implementations
 to customize the standard layout.
 
 This provider will fallback to lowercased alphabetic layout
 if the current context state doesn't have a standard layout.
 One example is if the current keyboard type is `.emojis` or
 another non-standard keyboard.

 You can provide a custom left and right space action, which
 gives you a chance to customize the default actions, but in
 a limited way. If you want to make bigger changes, subclass.
 */
open class StandardKeyboardLayoutProvider: KeyboardLayoutProvider {
    
    public init(
        context: KeyboardContext,
        inputSetProvider: KeyboardInputSetProvider,
        leftSpaceAction: KeyboardAction? = nil,
        rightSpaceAction: KeyboardAction? = nil) {
        self.context = context
        self.inputSetProvider = inputSetProvider
        self.leftSpaceAction = leftSpaceAction
        self.rightSpaceAction = rightSpaceAction
    }
    
    private let context: KeyboardContext
    private let inputSetProvider: KeyboardInputSetProvider
    private let leftSpaceAction: KeyboardAction?
    private let rightSpaceAction: KeyboardAction?
    
    open func keyboardLayout() -> KeyboardLayout {
        let rows = actionRows(for: context)
        let iPad = context.device.userInterfaceIdiom == .pad
        return keyboardLayout(iPad: iPad, rows: rows)
    }
    
    func keyboardLayout(
        iPad: Bool,
        rows: KeyboardActionRows) -> KeyboardLayout {
        let rows = iPad
            ? iPadActions(for: context, rows: rows)
            : iPhoneActions(for: context, rows: rows)
        return KeyboardLayout(rows: layoutItemRows(for: rows))
    }
}

private extension StandardKeyboardLayoutProvider {
    
    func layoutItem(for action: KeyboardAction) -> KeyboardLayoutItem {
        let size = KeyboardLayoutItem.Size(width: .available, height: .standardKeyboardRowHeight())
        let insets = EdgeInsets.standardKeyboardButtonInsets()
        return KeyboardLayoutItem(action: action, size: size, insets: insets)
    }
    
    func layoutItemRow(for actions: KeyboardActions) -> KeyboardLayoutItemRow {
        actions.map { layoutItem(for: $0) }
    }
    
    func layoutItemRows(for actionRows: KeyboardActionRows) -> KeyboardLayoutItemRows {
        actionRows.map { layoutItemRow(for: $0) }
    }
    
    func layoutSize(for action: KeyboardAction) -> KeyboardLayoutItem.Size {
        let width = layoutWidth(for: action)
        let height = CGFloat.standardKeyboardRowHeight()
        return KeyboardLayoutItem.Size(width: width, height: height)
    }
    
    func layoutWidth(for action: KeyboardAction) -> KeyboardLayoutWidth {
        .available
    }
}

private extension StandardKeyboardLayoutProvider {
    
    /**
     Dictation is currently not supported and will not be in
     layouts generated that are generated by this class.
     */
    var isDictationSupported: Bool { false }
}


// MARK: - iPad layouts

private extension StandardKeyboardLayoutProvider {
    
    func iPadActions(
        for context: KeyboardContext,
        rows: KeyboardActionRows) -> KeyboardActionRows {
        var rows = rows
        
        if rows.count > 0 { rows[0] =
            iPadUpperLeadingActions(for: context) +
            rows[0] +
            iPadUpperTrailingActions(for: context)
        }
        
        if rows.count > 1 { rows[1] =
            iPadMiddleLeadingActions(for: context) +
            rows[1] +
            iPadMiddleTrailingActions(for: context)
        }
        
        if rows.count > 2 { rows[2] =
            iPadLowerLeadingActions(for: context) +
            rows[2] +
            iPadLowerTrailingActions(for: context)
        }
        
        rows.append(iPadBottomActions(for: context))
        
        return rows
    }
    
    func iPadUpperLeadingActions(for context: KeyboardContext) -> KeyboardActions {
        context.needsInputModeSwitchKey ? [] : [.tab]
    }
    
    func iPadUpperTrailingActions(for context: KeyboardContext) -> KeyboardActions {
        [.backspace]
    }
    
    func iPadMiddleLeadingActions(for context: KeyboardContext) -> KeyboardActions {
        context.needsInputModeSwitchKey ? [] : [.keyboardType(.alphabetic(.capsLocked))]
    }
    
    func iPadMiddleTrailingActions(for context: KeyboardContext) -> KeyboardActions {
        [.newLine]
    }
    
    func iPadLowerLeadingActions(for context: KeyboardContext) -> KeyboardActions {
        guard let action = context.keyboardType.standardSideKeyboardSwitcherAction else { return [] }
        return [action]
    }
    
    func iPadLowerTrailingActions(for context: KeyboardContext) -> KeyboardActions {
        iPadLowerLeadingActions(for: context)
    }
    
    func iPadBottomActions(for context: KeyboardContext) -> KeyboardActions {
        var result = KeyboardActions()
        let switcher = context.keyboardType.standardBottomKeyboardSwitcherAction
        
        if !context.needsInputModeSwitchKey {
            result.append(.nextKeyboard)
        }
        if let action = switcher {
            result.append(action)
        }
        if context.needsInputModeSwitchKey {
            result.append(.nextKeyboard)
        }
        if isDictationSupported {
            result.append(.dictation)
        }
        if let action = leftSpaceAction {
            result.append(action)
        }
        result.append(.space)
        if let action = rightSpaceAction {
            result.append(action)
        }
        if let action = switcher {
            result.append(action)
        }
        result.append(.dismissKeyboard)
        
        return result
    }
}


// MARK: - iPhone layouts

private extension StandardKeyboardLayoutProvider {
    
    func iPhoneActions(
        for context: KeyboardContext,
        rows: KeyboardActionRows) -> KeyboardActionRows {
        var rows = rows
        
        if rows.count > 0 { rows[0] =
            iPhoneUpperLeadingActions(for: context) +
            rows[0] +
            iPhoneUpperTrailingActions(for: context)
        }
        
        if rows.count > 1 { rows[1] =
            iPhoneMiddleLeadingActions(for: context) +
            rows[1] +
            iPhoneMiddleTrailingActions(for: context)
        }
        
        if rows.count > 2 { rows[2] =
            iPhoneLowerLeadingActions(for: context) +
            rows[2] +
            iPhoneLowerTrailingActions(for: context)
        }
        
        rows.append(iPhoneBottomActions(for: context))
        
        return rows
    }
    
    func iPhoneUpperLeadingActions(for context: KeyboardContext) -> KeyboardActions {
        []
    }
    
    func iPhoneUpperTrailingActions(for context: KeyboardContext) -> KeyboardActions {
        []
    }
    
    func iPhoneMiddleLeadingActions(for context: KeyboardContext) -> KeyboardActions {
        []
    }
    
    func iPhoneMiddleTrailingActions(for context: KeyboardContext) -> KeyboardActions {
        []
    }
    
    func iPhoneLowerLeadingActions(for context: KeyboardContext) -> KeyboardActions {
        guard let action = context.keyboardType.standardSideKeyboardSwitcherAction else { return [] }
        return [action]
    }
    
    func iPhoneLowerTrailingActions(for context: KeyboardContext) -> KeyboardActions {
        [.backspace]
    }
    
    func iPhoneBottomActions(for context: KeyboardContext) -> KeyboardActions {
        var result = KeyboardActions()
        let switcher = context.keyboardType.standardBottomKeyboardSwitcherAction
        
        if let action = switcher {
            result.append(action)
        }
        if context.needsInputModeSwitchKey {
            result.append(.nextKeyboard)
        }
        if isDictationSupported {
            result.append(.dictation)
        }
        if let action = leftSpaceAction {
            result.append(action)
        }
        result.append(.space)
        if let action = rightSpaceAction {
            result.append(action)
        }
        result.append(.newLine)
        
        return result
    }
}

private extension StandardKeyboardLayoutProvider {

    func actionRows(for context: KeyboardContext) -> KeyboardActionRows {
        let rows = inputRows(for: context)
        return KeyboardActionRows(characters: rows)
    }
    
    func inputRows(for context: KeyboardContext) -> [KeyboardInputSet.InputRow] {
        let provider = inputSetProvider
        switch context.keyboardType {
        case .alphabetic(let state):
            let rows = provider.alphabeticInputSet().inputRows
            return state.isUppercased ? rows.uppercased() : rows
        case .numeric: return provider.numericInputSet().inputRows
        case .symbolic: return provider.symbolicInputSet().inputRows
        default: return provider.alphabeticInputSet().inputRows
        }
    }
}

private extension KeyboardType {
    
    var standardBottomKeyboardSwitcherAction: KeyboardAction? {
        switch self {
        case .alphabetic: return .keyboardType(.numeric)
        case .numeric: return .keyboardType(.alphabetic(.lowercased))
        case .symbolic: return .keyboardType(.alphabetic(.lowercased))
        default: return nil
        }
    }

    var standardSideKeyboardSwitcherAction: KeyboardAction? {
        switch self {
        case .alphabetic(let state): return .shift(currentState: state)
        case .numeric: return .keyboardType(.symbolic)
        case .symbolic: return .keyboardType(.numeric)
        default: return nil
        }
    }
}

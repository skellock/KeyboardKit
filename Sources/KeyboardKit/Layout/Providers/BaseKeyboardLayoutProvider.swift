//
//  BaseKeyboardLayoutProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This class can be inherited by keyboard layout providers to
 get a base set of standard functionality, that can then get
 modified by each subclass.
 
 By default, this class will apply a `reference` size to any
 `character` action on the first row, then a `fromReference`
 size to any other `character` buttons.
 
 You can inherit this class and override any implementations
 you need to customize the final layout.
 
 This class just converts the input provider's current input
 set to correctly adjusted `inputRows` which is then used by
 `actionRows` where each char is mapped to a keyboard action.
 It is then used by `layoutRows` where each action is mapped
 to a layout item. You can override any properties/functions
 to create custom layouts, but the most convenient way is to
 override `actionRows`. `inputRows` should not be overridden
 since it's better to adjust the input provider. `actionRows`
 lets you add actions that then gets mapped with the current
 rules of the provider. Overriding `layoutRows` requires you
 to specify the entire layout item.
 */
open class BaseKeyboardLayoutProvider {
    
    public init(
        context: KeyboardContext,
        inputSetProvider: KeyboardInputSetProvider,
        dictationReplacement: KeyboardAction? = nil) {
        self.context = context
        self.inputSetProvider = inputSetProvider
        self.dictationReplacement = dictationReplacement
    }

    public let context: KeyboardContext
    public let dictationReplacement: KeyboardAction?
    public let inputSetProvider: KeyboardInputSetProvider
    
    
    // MARK: - KeyboardLayoutProvider
    
    open func keyboardLayout() -> KeyboardLayout {
        KeyboardLayout(rows: layoutRows)
    }
    
    
    // MARK: - Properties
    
    /**
     The action rows for the provider's current state.
     */
    open var actionRows: KeyboardActionRows {
        KeyboardActionRows(characters: inputRows)
    }
    
    /**
     The input rows for the provider's current state.
     */
    open var inputRows: [KeyboardInputRow] {
        switch context.keyboardType {
        case .alphabetic(let state):
            let rows = inputSetProvider.alphabeticInputSet().rows
            return state.isUppercased ? rows.uppercased() : rows
        case .numeric: return inputSetProvider.numericInputSet().rows
        case .symbolic: return inputSetProvider.symbolicInputSet().rows
        default: return []
        }
    }
    
    /**
     The keyboard switcher action that should be on the last
     keyboard row. It's by default `numeric` for `alphabetic`
     keyboards and `alphabetic` for `numeric` and `symbolic`.
     */
    open var keyboardSwitcherActionForBottomRow: KeyboardAction? {
        switch context.keyboardType {
        case .alphabetic: return .keyboardType(.numeric)
        case .numeric: return .keyboardType(.alphabetic(.lowercased))
        case .symbolic: return .keyboardType(.alphabetic(.lowercased))
        default: return nil
        }
    }
    
    /**
     The keyboard switcher action that should be on the last
     keyboard row with char inputs. It's by default a `shift`
     for `alphabetic`, `symbolic` for `numeric` and `numeric`
     for `symbolic`.
     */
    open var keyboardSwitcherActionForBottomInputRow: KeyboardAction? {
        switch context.keyboardType {
        case .alphabetic(let state): return .shift(currentState: state)
        case .numeric: return .keyboardType(.symbolic)
        case .symbolic: return .keyboardType(.numeric)
        default: return nil
        }
    }
    
    /**
     The layout items for the provider's current state.
     */
    open var layoutRows: [KeyboardLayoutRow] {
        layoutRows(for: actionRows)
    }
    
    
    // MARK: - Functions
    
    /**
     Map keyboard action rows to layout item rows.
     */
    open func layoutRows(for actions: KeyboardActionRows) -> [KeyboardLayoutRow] {
        actions.enumerated().map {
            layoutRow(for: $0.element, at: $0.offset)
        }
    }
    
    /**
     Map keyboard actions at a certain row to layout items.
     */
    open func layoutRow(for actions: KeyboardActions, at row: Int) -> KeyboardLayoutRow {
        KeyboardLayoutRow(items: actions.map { layoutItem(for: $0, at: row) })
    }
    
    /**
     Map a keyboard action at a certain row to a layout item.
     */
    open func layoutItem(for action: KeyboardAction, at row: Int) -> KeyboardLayoutItem {
        let size = layoutSize(for: action, at: row)
        let insets = EdgeInsets.standardKeyboardButtonInsets()
        return KeyboardLayoutItem(action: action, size: size, insets: insets)
    }

    /**
     Get the size of a keyboard action at a certain row.
     */
    open func layoutSize(for action: KeyboardAction, at row: Int) -> KeyboardLayoutItem.Size {
        let width = layoutWidth(for: action, at: row)
        let height = CGFloat.standardKeyboardRowHeight()
        return KeyboardLayoutItem.Size(width: width, height: height)
    }
    
    /**
     Get the width of a keyboard action at a certain row.
     */
    open func layoutWidth(for action: KeyboardAction, at row: Int) -> KeyboardLayoutWidth {
        switch action {
        case .character: return row == 0 ? .reference(.available) : .useReference
        default: return .available
        }
    }
}


// MARK: - Shortcut Properties

public extension BaseKeyboardLayoutProvider {
    
    var isPhone: Bool { context.device.userInterfaceIdiom == .phone }
    var isPad: Bool { context.device.userInterfaceIdiom == .pad }
    var isPortrait: Bool { context.deviceOrientation.isPortrait }
    var isLandscape: Bool { context.deviceOrientation.isLandscape }
    var needsDictation: Bool { needsInputSwitcher }
    var needsInputSwitcher: Bool { context.needsInputModeSwitchKey }
}
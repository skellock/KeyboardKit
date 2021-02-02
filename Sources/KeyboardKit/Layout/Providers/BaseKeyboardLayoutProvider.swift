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
 
 This class only returns `inputRows` and `actionRows` if the
 input set provider returns characters. Otherwise, these row
 properties will be empty.
 
 You can inherit this class and override any implementations
 you need to customize the final layout.
 
 This class just converts the input provider's current input
 set to correctly adjusted `inputRows` which is then used to
 derive a computed `actionRows` where each char is mapped to
 a keyboard action. This is then used by `layoutItemRows` to
 map keyboard actions to layout items. You can override this
 process by overriding any of these properties and functions
 to create a custom layout. The most convenient way it to do
 so for the `layoutItemRows` and add layout items directly.
 */
open class BaseKeyboardLayoutProvider {
    
    public init(
        context: KeyboardContext,
        inputSetProvider: KeyboardInputSetProvider) {
        self.context = context
        self.inputSetProvider = inputSetProvider
    }

    public let context: KeyboardContext
    public let inputSetProvider: KeyboardInputSetProvider
    
    
    // MARK: - KeyboardLayoutProvider
    
    open func keyboardLayout() -> KeyboardLayout {
        KeyboardLayout(rows: layoutItemRows)
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
    open var inputRows: [KeyboardInputSet.InputRow] {
        switch context.keyboardType {
        case .alphabetic(let state):
            let rows = inputSetProvider.alphabeticInputSet().inputRows
            return state.isUppercased ? rows.uppercased() : rows
        case .numeric: return inputSetProvider.numericInputSet().inputRows
        case .symbolic: return inputSetProvider.symbolicInputSet().inputRows
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
    open var layoutItemRows: KeyboardLayoutItemRows {
        layoutItemRows(for: actionRows)
    }
    
    
    // MARK: - Functions
    
    /**
     Map keyboard action rows to layout item rows.
     */
    open func layoutItemRows(for actions: KeyboardActionRows) -> KeyboardLayoutItemRows {
        actions.enumerated().map {
            layoutItems(for: $0.element, at: $0.offset)
        }
    }
    
    /**
     Map keyboard actions at a certain row to layout items.
     */
    open func layoutItems(for actions: KeyboardActions, at row: Int) -> KeyboardLayoutItems {
        actions.map { layoutItem(for: $0, at: row) }
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

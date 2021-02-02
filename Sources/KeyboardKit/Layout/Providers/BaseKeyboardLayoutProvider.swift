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
 */
open class BaseKeyboardLayoutProvider {
    
    public init() {}
    
    /**
     Map keyboard action rows to layout item rows.
     */
    open func layoutItems(for actions: KeyboardActionRows) -> KeyboardLayoutItemRows {
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
        case .character: return row == 0 ? .reference(.available) : .fromReference
        default: return .available
        }
    }
}

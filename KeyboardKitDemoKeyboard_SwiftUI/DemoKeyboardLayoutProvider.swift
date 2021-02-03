//
//  DemoKeyboardLayoutProvider.swift
//  KeyboardKitDemoKeyboard_SwiftUI
//
//  Created by Daniel Saidi on 2021-02-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit

class DemoKeyboardLayoutProvider: StandardKeyboardLayoutProvider {
    
    override func keyboardLayout() -> KeyboardLayout {
        let layout = super.keyboardLayout()
        var rows = layout.rows
        guard var last = rows.last else { return layout }
        guard let index = (last.firstIndex { $0.action == .space }) else { return layout }
        let action = KeyboardAction.keyboardType(.images)
        let size = super.layoutSize(for: action, at: 3)
        let item = KeyboardLayoutItem(action: action, size: size, insets: .standardKeyboardButtonInsets())
        last.insert(item, at: last.index(after: index))
        rows.removeLast(1)
        rows.append(last)
        return KeyboardLayout(rows: rows)
    }
}
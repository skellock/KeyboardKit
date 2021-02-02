//
//  SystemKeyboardItem.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view is meant to be used within a `SystemKeyboard` and
 will apply the correct frames and paddings to make the view
 behave well within an automatically generated keyboard view.
 */
public struct SystemKeyboardItem<Content: View>: View {
    
    public init(
        item: KeyboardLayoutItem,
        content: Content,
        appearance: KeyboardAppearance,
        keyboardSize: CGSize,
        referenceSize: Binding<CGSize>) {
        self.item = item
        self.appearance = appearance
        self.content = content
        self.keyboardSize = keyboardSize
        self.referenceSize = referenceSize
    }
    
    private let item: KeyboardLayoutItem
    private let appearance: KeyboardAppearance
    private let content: Content
    private let keyboardSize: CGSize
    private let referenceSize: Binding<CGSize>
    
    @EnvironmentObject private var context: ObservableKeyboardContext
    
    public var body: some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: item.size.height - item.insets.top - item.insets.bottom)
            .width(item.size.width, referenceSize: referenceSize)
            .keyboardButtonStyle(for: item.action, appearance: appearance)
            .padding(item.insets)
            .frame(height: item.size.height)
            .background(Color.clearInteractable)
    }
}

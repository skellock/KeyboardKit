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
        actionHandler: KeyboardActionHandler,
        appearance: KeyboardAppearance,
        buttonContent: Content,
        keyboardSize: CGSize,
        referenceSize: Binding<CGSize>) {
        self.item = item
        self.actionHandler = actionHandler
        self.appearance = appearance
        self.buttonContent = buttonContent
        self.keyboardSize = keyboardSize
        self.referenceSize = referenceSize
    }
    
    private let item: KeyboardLayoutItem
    private let actionHandler: KeyboardActionHandler
    private let appearance: KeyboardAppearance
    private let buttonContent: Content
    private let keyboardSize: CGSize
    private let referenceSize: Binding<CGSize>
    
    @EnvironmentObject private var context: ObservableKeyboardContext
    
    public var body: some View {
        buttonContent
            .frame(maxWidth: .infinity)
            .frame(height: item.size.height - item.insets.top - item.insets.bottom)
            .width(item.size.width, referenceSize: referenceSize)
            .keyboardButtonStyle(for: item.action, appearance: appearance)
            .padding(item.insets)
            .frame(height: item.size.height)
            .background(Color.clearInteractable)
            .keyboardGestures(for: item.action, actionHandler: actionHandler)
    }
}

//
//  SystemKeyboardButtonRowItem.swift
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
 
 This view wraps a `SystemKeyboardButtonContent` and adjusts
 it to be used within a keyboard row. This involves applying
 height and paddings and new gestures in a way that make the
 buttons seem separated while actually sticking together.
 */
public struct SystemKeyboardButtonRowItem<Content: View>: View {
    
    public init(
        item: KeyboardLayoutItem,
        actionHandler: KeyboardActionHandler,
        appearance: KeyboardAppearance,
        buttonContent: Content,
        dimensions: KeyboardDimensions = SystemKeyboardDimensions(),
        keyboardSize: CGSize,
        referenceSize: Binding<CGSize>) {
        self.item = item
        self.actionHandler = actionHandler
        self.appearance = appearance
        self.buttonContent = buttonContent
        self.dimensions = dimensions
        self.keyboardSize = keyboardSize
        self.referenceSize = referenceSize
    }
    
    private let item: KeyboardLayoutItem
    private let actionHandler: KeyboardActionHandler
    private let appearance: KeyboardAppearance
    private let buttonContent: Content
    private let dimensions: KeyboardDimensions
    private let keyboardSize: CGSize
    private let referenceSize: Binding<CGSize>
    
    @EnvironmentObject private var context: ObservableKeyboardContext
    
    public var body: some View {
        buttonContent
            .frame(maxWidth: .infinity)
            .frame(height: dimensions.buttonHeight - dimensions.buttonInsets.top - dimensions.buttonInsets.bottom)
            .width(item.size.width, referenceSize: referenceSize)
            .keyboardButtonStyle(for: item.action, appearance: appearance)
            .padding(dimensions.buttonInsets)
            .frame(height: item.size.height)
            .background(Color.clearInteractable)
            .keyboardGestures(for: item.action, actionHandler: actionHandler)
    }
}

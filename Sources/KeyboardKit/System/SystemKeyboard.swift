//
//  SystemKeyboard.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view mimics native system keyboards, like the standard
 alphabetic, numeric and symbolic system keyboards.
 
 The keyboard view takes a `keyboardLayout` and converts the
 actions to buttons, using the provided `buttonBuilder`. The
 buttons are then wrapped in a `SystemKeyboardButtonRowItem`.
 */
public struct SystemKeyboard: View {
    
    public init(
        layout: KeyboardLayout,
        actionHandler: KeyboardActionHandler,
        appearance: KeyboardAppearance,
        buttonBuilder: @escaping ButtonBuilder = Self.standardButtonBuilder) {
        self.layout = layout
        self.actionHandler = actionHandler
        self.appearance = appearance
        self.buttonBuilder = buttonBuilder
    }
    
    private let actionHandler: KeyboardActionHandler
    private let appearance: KeyboardAppearance
    private let buttonBuilder: ButtonBuilder
    private let layout: KeyboardLayout
    
    @State private var keyboardSize: CGSize = .zero
    @State private var referenceSize: CGSize = .zero
    
    @EnvironmentObject private var context: ObservableKeyboardContext
    
    public typealias ButtonBuilder = (KeyboardAction, KeyboardSize) -> AnyView
    public typealias KeyboardSize = CGSize
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(layout.rows.enumerated()), id: \.offset) {
                hStack(for: $0.element)
            }
        }
        .bindSize(to: $keyboardSize)
        .inputCallout(style: .systemStyle(for: context))
        .secondaryInputCallout(style: .systemStyle(for: context))
    }
}

public extension SystemKeyboard {

    /**
     This is the standard `buttonBuilder`, that will be used
     when no custom builder is provided to the view.
     */
    static func standardButtonBuilder(action: KeyboardAction, keyboardSize: KeyboardSize) -> AnyView {
        AnyView(SystemKeyboardButtonContent(action: action))
    }
}

private extension SystemKeyboard {

    func hStack(for row: KeyboardLayoutItems) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(row.enumerated()), id: \.offset) {
                hStackItem(for: $0.element)
            }
        }
    }
    
    func hStackItem(for item: KeyboardLayoutItem) -> some View {
        SystemKeyboardItem(
            item: item,
            content: buttonBuilder(item.action, keyboardSize),
            appearance: appearance,
            keyboardSize: keyboardSize,
            referenceSize: $referenceSize)
            .keyboardGestures(for: item.action, actionHandler: actionHandler)
    }
}

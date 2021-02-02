//
//  KeyboardView+Keyboards.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2021-01-09.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import SwiftUI

extension KeyboardView {
    
    var imageKeyboard: some View {
        ImageKeyboard(
            actionHandler: keyboardActionHandler,
            appearance: keyboardAppearance)
            .padding()
    }
    
    var systemKeyboard: some View {
        VStack(spacing: 0) {
            HStack {
                AutocompleteToolbar(
                    suggestions: autocompleteContext.suggestions,
                    buttonBuilder: autocompleteButtonBuilder)
                    
                Image.settings
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(5)
                    .keyboardButtonStyle(for: .character(""), appearance: keyboardAppearance)
                    .padding(.standardKeyboardButtonInsets())
                    .contextMenu {
                        Button("English") {
                            self.context.locale = LocaleKey.english.locale
                        }
                        Button("Swedish") {
                            self.context.locale = LocaleKey.swedish.locale
                        }
                        
                    }
            }.frame(height: 50)
            SystemKeyboard(
                layout: keyboardLayoutProvider.keyboardLayout(),
                actionHandler: keyboardActionHandler,
                appearance: keyboardAppearance,
                buttonBuilder: buttonBuilder)
        }
    }
}

private extension KeyboardView {
    
    func autocompleteButton(for suggestion: AutocompleteSuggestion) -> AnyView {
        guard let subtitle = suggestion.subtitle else { return AutocompleteToolbar.standardButton(for: suggestion) }
        return AnyView(VStack(spacing: 0) {
            Text(suggestion.title).font(.callout)
            Text(subtitle).font(.footnote)
        }.frame(maxWidth: .infinity))
    }
    
    func autocompleteButtonBuilder(suggestion: AutocompleteSuggestion) -> AnyView {
        AnyView(autocompleteButton(for: suggestion)
            .background(Color.clearInteractable))
    }
    
    func buttonBuilder(action: KeyboardAction, size: CGSize) -> AnyView {
        switch action {
        case .space: return AnyView(SystemKeyboardSpaceButtonContent(localeText: "English", spaceText: "space"))
        default: return SystemKeyboard.standardButtonBuilder(action: action, keyboardSize: size)
        }
    }
}

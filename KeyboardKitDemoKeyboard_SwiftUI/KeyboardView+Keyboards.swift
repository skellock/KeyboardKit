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
                autocompleteBar
                settingsButton
            }.frame(height: 50)
            SystemKeyboard(
                layout: keyboardLayoutProvider.keyboardLayout(),
                actionHandler: keyboardActionHandler,
                appearance: keyboardAppearance,
                buttonBuilder: buttonBuilder)
        }
    }
}


// MARK: - Private Logic

private extension KeyboardView {
    
    func changeLocale(to locale: Locale) {
        DispatchQueue.main.async {
            keyboardInputViewController.changeKeyboardLocale(to: locale)
        }
    }
    
    func nextLocale() {
        let isSwedish = context.locale.identifier == "sv"
        let new: LocaleKey = isSwedish ? .english : .swedish
        changeLocale(to: new.locale)
    }
}


// MARK: - Private View Logic

private extension KeyboardView {
    
    var autocompleteBar: some View {
        AutocompleteToolbar(
            suggestions: autocompleteContext.suggestions,
            buttonBuilder: autocompleteBarButtonBuilder)
    }
    
    var settingsButton: some View {
        Image.settings
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(5)
            .keyboardButtonStyle(for: .character(""), appearance: keyboardAppearance)
            .padding(.standardKeyboardButtonInsets())
            .onTapGesture(perform: nextLocale)
            .contextMenu {
                localeButton(title: "English", locale: .english)
                localeButton(title: "Swedish", locale: .swedish)
            }
    }
    
    func autocompleteBarButton(for suggestion: AutocompleteSuggestion) -> AnyView {
        guard let subtitle = suggestion.subtitle else { return AutocompleteToolbar.standardButton(for: suggestion) }
        return AnyView(VStack(spacing: 0) {
            Text(suggestion.title).font(.callout)
            Text(subtitle).font(.footnote)
        }.frame(maxWidth: .infinity))
    }
    
    func autocompleteBarButtonBuilder(suggestion: AutocompleteSuggestion) -> AnyView {
        AnyView(autocompleteBarButton(for: suggestion)
                    .background(Color.clearInteractable))
    }
    
    func buttonBuilder(action: KeyboardAction, size: CGSize) -> AnyView {
        switch action {
        case .space: return AnyView(SystemKeyboardSpaceButtonContent(localeText: "English", spaceText: "space"))
        default: return SystemKeyboard.standardButtonBuilder(action: action, keyboardSize: size)
        }
    }
    
    func localeButton(title: String, locale: LocaleKey) -> some View {
        Button(title) {
            changeLocale(to: locale.locale)
        }
    }
}

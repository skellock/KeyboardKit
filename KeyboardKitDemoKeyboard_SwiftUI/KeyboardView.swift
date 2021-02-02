//
//  KeyboardView.swift
//  KeyboardKitDemo
//
//  Created by Daniel Saidi on 2020-06-10.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI
import KeyboardKit

/**
 This view is the main view that is used by the extension by
 calling `setup(with:)` in `KeyboardViewController`.
 
 The view will switch over the current keyboard type and add
 the correct keyboard view.
 */
struct KeyboardView: View {
    
    var keyboardActionHandler: KeyboardActionHandler
    var keyboardAppearance: KeyboardAppearance
    var keyboardLayoutProvider: KeyboardLayoutProvider
    
    @EnvironmentObject var autocompleteContext: ObservableAutocompleteContext
    @EnvironmentObject var context: ObservableKeyboardContext
    @EnvironmentObject var toastContext: KeyboardToastContext
    
    var body: some View {
        keyboardView.keyboardToast(
            context: toastContext,
            background: toastBackground)
    }
    
    @ViewBuilder
    var keyboardView: some View {
        switch context.keyboardType {
        case .alphabetic, .numeric, .symbolic: systemKeyboard
        case .emojis: emojiKeyboard
        case .images: imageKeyboard
        default: Button("???", action: switchToDefaultKeyboard)
        }
    }
}


// MARK: - Functions

private extension KeyboardView {
    
    @ViewBuilder
    var emojiKeyboard: some View {
        if #available(iOSApplicationExtension 14.0, *) {
            EmojiCategoryKeyboard().padding(.top)
        } else {
            Text("Requires iOS 14 or later")
        }
    }
    
    func switchToDefaultKeyboard() {
        keyboardActionHandler
            .handle(.tap, on: .keyboardType(.alphabetic(.lowercased)))
    }
    
    var toastBackground: some View {
        Color.white
            .cornerRadius(3)
            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)
    }
}












struct KeyboardButtonWidthPreview: View {
    
    @State var referenceSize: CGSize = .zero
    @State var totalSize: CGSize = .zero
    
    var totalWidth: CGFloat { totalSize.width }
    
    func systemButton() -> some View {
        Color.gray.opacity(0.7).cornerRadius(6).padding(3)
    }
    
    func button() -> some View {
        Color.white.cornerRadius(6).padding(3)
    }
    
    func spacer() -> some View {
        Color.clear.padding(1).width(.available)
    }
    
    func bars(count: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0...(count/2-1), id: \.self) { _ in
                Color.white
                Color.black
            }
        }
    }
    
    func repeatingView<ViewType: View>(count: Int, view: @escaping () -> ViewType) -> some View {
        HStack(spacing: 0) {
            ForEach(0...count-1, id: \.self) { _ in
                view()
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            bars(count: 100)
            VStack(spacing: 0) {
                repeatingView(count: 10, view: { button().width(.reference(.available), referenceSize: $referenceSize) })
                repeatingView(count: 9, view: { button().width(.fromReference, referenceSize: $referenceSize) })
                HStack(spacing: 0) {
                    systemButton().width(.percentage(0.125), totalWidth: totalWidth)
                    spacer()
                    repeatingView(count: 7, view: { button().width(.fromReference, referenceSize: $referenceSize) })
                    spacer()
                    systemButton().width(.percentage(0.125), totalWidth: totalWidth)
                }
                HStack(spacing: 0) {
                    systemButton().width(.percentage(0.125), totalWidth: totalWidth)
                    systemButton().width(.percentage(0.125), totalWidth: totalWidth)
                    button().width(.fromReference, referenceSize: $referenceSize)
                    button()
                    systemButton().width(.percentage( 0.25), totalWidth: totalWidth)
                }
            }.frame(height: 200)
            bars(count: 100)
        }
        .background(Color.gray.opacity(0.4))
        .bindSize(to: $totalSize)
    }
}

//
//  StandardKeyboardInputSetProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This input set provider provides the standard input set for
 the locale of the current context. Note that the characters
 aren't shift adjusted and only returned as lowercased chars.
 
 You can inherit and customize this class to create your own
 provider that builds on this foundation.
 */
open class StandardKeyboardInputSetProvider: KeyboardInputSetProvider {
    
    public init(context: KeyboardContext) {
        self.context = context
    }
    
    private let context: KeyboardContext
    
    private lazy var providerDictionaryValue: LocaleDictionary<KeyboardInputSetProvider> = LocaleDictionary([
        LocaleKey.english.key: EnglishKeyboardInputSetProvider(),
        LocaleKey.german.key: GermanKeyboardInputSetProvider(),
        LocaleKey.italian.key: ItalianKeyboardInputSetProvider(),
        LocaleKey.swedish.key: SwedishKeyboardInputSetProvider()
    ])
    
    open var providerDictionary: LocaleDictionary<KeyboardInputSetProvider> {
        providerDictionaryValue
    }
    
    open func provider(for context: KeyboardContext) -> KeyboardInputSetProvider {
        providerDictionary.value(for: context.locale) ?? EnglishKeyboardInputSetProvider()
    }
    
    open func alphabeticInputSet() -> AlphabeticKeyboardInputSet {
        provider(for: context).alphabeticInputSet()
    }
    
    open func numericInputSet() -> NumericKeyboardInputSet {
        provider(for: context).numericInputSet()
    }
    
    open func symbolicInputSet() -> SymbolicKeyboardInputSet {
        provider(for: context).symbolicInputSet()
    }
}

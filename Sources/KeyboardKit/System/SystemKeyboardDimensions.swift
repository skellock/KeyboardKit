//
//  SystemKeyboardDimensions.swift
//  KeyboardKit  
//
//  Created by Daniel Saidi on 2020-07-04.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import Combine
import SwiftUI

/**
 This struct specifies dimensions for a `SystemKeyboard`.
 */
public struct SystemKeyboardDimensions: KeyboardDimensions {
    
    public init(
        buttonHeight: CGFloat = .standardKeyboardRowHeight(),
        buttonInsets: EdgeInsets = .standardKeyboardButtonInsets(),
        longButtonWidth: CGFloat = 100.0,
        shortButtonWidth: CGFloat = 50.0) {
        self.buttonHeight = buttonHeight
        self.buttonInsets = buttonInsets
        self.longButtonWidth = longButtonWidth
        self.shortButtonWidth = shortButtonWidth
    }
    
    public let buttonHeight: CGFloat
    public let buttonInsets: EdgeInsets
    private let longButtonWidth: CGFloat
    private let shortButtonWidth: CGFloat
    
    public func width(
        for action: KeyboardAction,
        keyboardWidth: CGFloat,
        context: KeyboardContext) -> CGFloat? {
        switch action {
        case .shift, .backspace: return shortButtonWidth
        case .nextKeyboard: return shortButtonWidth
        case .keyboardType(let type): return width(for: type, context: context)
        default: return nil
        }
    }
    
    func width(for type: KeyboardType, context: KeyboardContext) -> CGFloat? {
        let currentType = context.keyboardType
        let alphaWidth = context.needsInputModeSwitchKey ? shortButtonWidth : nil
        
        switch type {
        case .numeric:
            switch currentType {
            case .symbolic: return shortButtonWidth
            case .alphabetic: return alphaWidth
            default: return nil
            }
        case .symbolic:
            switch currentType {
            case .numeric: return shortButtonWidth
            default: return nil
            }
        case .alphabetic: return alphaWidth
        default: return nil
        }
    }
}

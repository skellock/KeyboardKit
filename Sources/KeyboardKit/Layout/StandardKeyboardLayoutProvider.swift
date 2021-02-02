//
//  StandardKeyboardLayoutProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-12-01.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This keyboard layout provider bases its layout decisions on
 factors like locale, device and screen orientation.
 
 This may not always be what you want. If you want to create
 keyboards with a custom layout, you should either not use a
 layout provider, or create a custom one.
 
 You can inherit this class and override any implementations
 to customize the standard layout.
 */
open class StandardKeyboardLayoutProvider: BaseKeyboardLayoutProvider, KeyboardLayoutProvider {
    
    private lazy var iPadLayout = iPadKeyboardLayoutProvider(context: context, inputSetProvider: inputSetProvider)
    private lazy var iPhoneLayout = iPhoneKeyboardLayoutProvider(context: context, inputSetProvider: inputSetProvider)
    
    var layout: KeyboardLayoutProvider { isPad ? iPadLayout : iPhoneLayout }
    
    open override func keyboardLayout() -> KeyboardLayout {
        layout.keyboardLayout()
    }
}

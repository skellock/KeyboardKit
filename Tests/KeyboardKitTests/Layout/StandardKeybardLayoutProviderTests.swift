//
//  StandardKeybardLayoutProviderTests.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-02.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import Quick
import Nimble
import UIKit
@testable import KeyboardKit

class StandardKeybardLayoutProviderTests: QuickSpec {
    
    override func spec() {
        
        var context: MockKeyboardContext!
        var device: MockDevice!
        var inputProvider: KeyboardInputSetProvider!
        var provider: StandardKeyboardLayoutProvider!
        
        beforeEach {
            device = MockDevice()
            context = MockKeyboardContext()
            context.device = device
            inputProvider = StandardKeyboardInputSetProvider(context: context)
            provider = StandardKeyboardLayoutProvider(context: context, inputSetProvider: inputProvider)
        }
        
        describe("layout") {
            
            it("is iPad layout for iPad devices") {
                device.userInterfaceIdiomValue = .pad
                expect(provider.layout is iPadKeyboardLayoutProvider).to(beTrue())
            }
            
            it("is iPhone layout for iPhone devices") {
                device.userInterfaceIdiomValue = .phone
                expect(provider.layout is iPhoneKeyboardLayoutProvider).to(beTrue())
            }
        }
    }
}

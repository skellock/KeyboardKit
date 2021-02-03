//
//  DeviceSpecificInputSetProvider.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-02-03.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import UIKit

public protocol DeviceSpecificInputSetProvider: KeyboardInputSetProvider {
    
    var device: UIDevice { get }
}

public extension DeviceSpecificInputSetProvider {
    
    func row(phone: String, pad: String) -> KeyboardInputRow {
        device.isPhone ? phone.chars : pad.chars
    }
}

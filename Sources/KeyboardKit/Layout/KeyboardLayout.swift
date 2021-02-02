//
//  KeyboardLayout.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2020-07-03.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import CoreGraphics
import SwiftUI

/**
 Keyboard layouts list available actions on a keyboard. They
 most often consist of multiple input button rows surrounded
 by system buttons.
 */
public struct KeyboardLayout: Equatable {
    
    public init(rows: KeyboardLayoutItemRows) {
        self.rows = rows
    }
    
    public let rows: KeyboardLayoutItemRows
}

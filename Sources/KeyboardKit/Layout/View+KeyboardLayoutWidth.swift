//
//  View+KeyboardLayoutWidth.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-21.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {
    
    /**
     Apply a certain keybard button width type to this view.
     
     The `totalWidth` parame is only required when using the
     `.percentage` and `.reference(.percentage)` width types.     
     
     The `referenceSize` binding param is only required when
     using `.reference` and `.fromReference` width types.
     */
    @ViewBuilder
    func width(_ width: KeyboardLayoutWidth, totalWidth: CGFloat = .zero, referenceSize: Binding<CGSize> = .constant(.zero)) -> some View {
        switch width {
        case .fromReference: self.frame(width: referenceSize.width.wrappedValue)
        case .percentage(let percent): self.frame(width: percent * totalWidth)
        case .points(let points): self.frame(width: points)
        case .reference(let width): self.frame(width: self.width(for: width, totalWidth: totalWidth, referenceSize: referenceSize.wrappedValue)).bindSize(to: referenceSize)
        case .available: self
        }
    }
}

private extension View {
    
    /**
     Calculate the width in points for a certain width type.
     */
    func width(for width: KeyboardLayoutWidth, totalWidth: CGFloat, referenceSize: CGSize) -> CGFloat? {
        switch width {
        case .percentage(let percent): return percent * totalWidth
        case .points(let points): return points
        case .available: return nil
        default: return 0
        }
    }
}
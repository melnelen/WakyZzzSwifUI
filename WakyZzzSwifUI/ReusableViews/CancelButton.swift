//
//  CancelButton.swift
//  WakyZzzSwifUI
//
//  Created by Alexandra Ivanova on 28/06/2024.
//

import SwiftUI

struct CancelButton: View {
    let action: () -> Void
    
    var body: some View {
        Button("Cancel", action: action)
    }
}

#Preview {
    CancelButton(action: {})
}

//
//  ButtonBackgroundView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 19.10.2024.
//

import SwiftUI

struct ButtonBackgroundView: View {
    let text: LocalizedStringResource
    let onClick: () -> Void
    let disabled: Bool
    
    init(_ text: LocalizedStringResource, disabled: Bool = false, onClick: @escaping () -> Void) {
        self.text = text
        self.disabled = disabled
        self.onClick = onClick
    }
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .foregroundStyle(.text)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(disabled ? Color.background.opacity(Constants.buttonDisabled) : Color.background)
                .cornerRadius(Constants.cornerRadius)
        }
        .disabled(disabled)
    }
}

#Preview {
    ButtonBackgroundView("") {}
}

//
//  ButtonView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 19.10.2024.
//

import SwiftUI

struct ButtonView: View {
    let text: LocalizedStringResource
    let onClick: () -> Void
    
    init(_ text: LocalizedStringResource, onClick: @escaping () -> Void) {
        self.text = text
        self.onClick = onClick
    }
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .foregroundStyle(.text)
                .padding()
        }
    }
}

#Preview {
    ButtonView("") {}
}

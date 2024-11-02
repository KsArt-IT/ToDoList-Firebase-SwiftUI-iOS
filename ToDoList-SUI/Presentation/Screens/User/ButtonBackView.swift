//
//  ButtonBackgroundView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 02.11.2024.
//


import SwiftUI

struct ButtonBackView: View {
    let onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Image(systemName: "chevron.left")
                .font(.headline)
                .foregroundStyle(.accent)
        }
    }
}

#Preview {
    ButtonBackView {}
}

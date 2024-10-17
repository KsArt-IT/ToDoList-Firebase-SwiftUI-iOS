//
//  ItemView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 15.10.2024.
//

import SwiftUI

struct ItemView: View {
    private let item: ToDoItem
    private let toggle: (String) -> Void
    private let action: (String) -> Void
    
    init(item: ToDoItem, toggle:  @escaping (String) -> Void, action: @escaping (String) -> Void) {
        self.item = item
        self.toggle = toggle
        self.action = action
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.title2)
                    .strikethrough(item.isCompleted)
                Text(item.text)
                    .font(.subheadline)
                Text(item.date.toStringDateTime())
                    .font(.subheadline)
            }
            Spacer()
            Button {
                toggle(item.id)
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.seal.fill" : "seal")
            }
            .padding(8)
            .buttonStyle(.borderless)
        }
        .onTapGesture {
            action(item.id)
        }
        .padding()
        .background(Color.clear)
        .cornerRadius(10)
        .listRowBackground(Color.clear)
        .padding(.vertical)
    }
}

#Preview {
    List {
        ItemView(
            item: ToDoItem(id: "1", date: Date(), title: "Title 1", text: "make", isCritical: true, isCompleted: false),
            toggle: {_ in },
            action: {_ in }
        )
        ItemView(
            item: ToDoItem(id: "2", date: Date(), title: "Title 2", text: "make", isCritical: true, isCompleted: false),
            toggle: {_ in },
            action: {_ in }
        )
    }
}


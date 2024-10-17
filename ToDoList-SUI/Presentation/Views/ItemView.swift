//
//  ItemView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 15.10.2024.
//

import SwiftUI

struct ItemView: View {
    private let item: ToDoItem
    private let action: (String) -> Void
    
    init(item: ToDoItem, action: @escaping (String) -> Void) {
        self.item = item
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
                action(item.id)
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.seal.fill" : "seal")
            }
            .padding(8)
            .buttonStyle(.borderless)
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
            item: ToDoItem(id: "1", date: Date(), title: "Title", text: "make", isCritical: true, isCompleted: false)
        ) {_ in }
        ItemView(
            item: ToDoItem(id: "1", date: Date(), title: "Title", text: "make", isCritical: false, isCompleted: true)
        ) {_ in }
    }
}


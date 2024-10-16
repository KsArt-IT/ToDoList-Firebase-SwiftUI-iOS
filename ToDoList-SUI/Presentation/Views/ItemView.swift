//
//  ItemView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 15.10.2024.
//

import SwiftUI

struct ItemView: View {
    var item: ToDoItem
    
    init(item: ToDoItem) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.title2)
                Text(item.text)
                    .font(.subheadline)
                Text(item.date.toStringDateTime())
                    .font(.subheadline)
            }
            Spacer()
            Button {
                
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.seal.fill" : "seal")
            }
            .padding(8)
            .buttonStyle(.borderless)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ItemView(
        item: ToDoItem(id: "1", date: Date(), title: "Title", text: "make", isCritical: true, isCompleted: false)
    )
}


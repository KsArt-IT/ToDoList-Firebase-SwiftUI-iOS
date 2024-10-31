//
//  ItemView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 15.10.2024.
//

import SwiftUI

struct ItemView: View {
    private var item: ToDoItem
    private let toggle: (String) -> Void
    private let action: (ToDoItem) -> Void
    // TODO: статический цвет, потом переделать с использованием таймера
    private var borderColor: Color {
        if item.isCompleted {
            return Color.completed
        }
        // интервал между текущей датой и датой задачи
        return switch Date().timeIntervalSince(item.date) {
            case -3600...3600 where !item.isCritical, -3600...0 where item.isCritical:
                Color.critical
            case let diff where diff > 0: // > 0 значит уже прошло время
                Color.expired
            default:
                Color.clear
        }
    }
    
    init(item: ToDoItem, toggle:  @escaping (String) -> Void, action: @escaping (ToDoItem) -> Void) {
        self.item = item
        self.toggle = toggle
        self.action = action
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.title2)
                    .lineLimit(1)
                    .strikethrough(item.isCompleted)
                Text(item.text)
                    .font(.subheadline)
                    .lineLimit(3)
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
        .padding()
        .background(Color.backgroundFirst.opacity(0.3))
        .cornerRadius(Constants.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(borderColor, lineWidth: 1)
            )
        .onTapGesture {
            action(item)
        }
        .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
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


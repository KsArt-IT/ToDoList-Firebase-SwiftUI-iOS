//
//  ErrorMessageModifier.swift
//  ToDoList-SUI
//
//  Created by KsArT on 23.10.2024.
//

import SwiftUI

// Модификатор для отображения ошибки под TextField
struct ErrorMessageModifier: ViewModifier {
    var message: String // Сообщение об ошибке, может быть nil
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            content // Основное поле TextField
                .overlay(
                    // Добавляем красную рамку, если есть ошибка
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(!message.isEmpty && cornerRadius > 0 ? Color.red : Color.clear, lineWidth: 2)
                )
            if !message.isEmpty {
                Divider()
                Text(message)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 2)
                    .padding(.horizontal)
                    .transition(.opacity) // Анимация появления/исчезновения
            }
        }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func errorMessage(_ message: String, cornerRadius: CGFloat = 0) -> some View {
        self.modifier(
            ErrorMessageModifier(message: message, cornerRadius: cornerRadius)
        )
    }
}

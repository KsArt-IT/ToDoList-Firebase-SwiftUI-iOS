//
//  AlertModifier.swift
//  ToDoList-SUI
//
//  Created by KsArT on 23.10.2024.
//


import SwiftUI

// Модификатор для отображения Alert при наличии ошибки
struct AlertModifier: ViewModifier {
    @Binding var message: String // Сообщение для отображения в Alert
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(!message.isEmpty)) {
                Alert(
                    title: Text("Error"),
                    message: Text(message),
                    dismissButton: .default(Text("Ok")) {
                        message = "" // Сброс сообщения после закрытия Alert
                        action()
                    }
                )
            }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func showAlert(_ message: Binding<String>, action: @escaping () -> Void = {}) -> some View {
        self.modifier(AlertModifier(message: message, action: action))
    }
}

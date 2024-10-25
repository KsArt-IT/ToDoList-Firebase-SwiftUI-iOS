//
//  AlertModifier.swift
//  ToDoList-SUI
//
//  Created by KsArT on 23.10.2024.
//


import SwiftUI

// Модификатор для отображения Alert при наличии ошибки
struct AlertModifier: ViewModifier {
    typealias AlertType = (message: String, isError: Bool)
    @Binding var alert: AlertType // Сообщение для отображения в Alert
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: .constant(!alert.message.isEmpty)) {
                Alert(
                    title: Text(alert.isError ? "Error": "Info"),
                    message: Text(alert.message),
                    dismissButton: .default(Text("Ok")) {
                        alert = ("", alert.isError) // Сброс сообщения после закрытия Alert
                        action()
                    }
                )
            }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func showAlert(_ alert: Binding<AlertModifier.AlertType>, action: @escaping () -> Void = {}) -> some View {
        self.modifier(AlertModifier(alert: alert, action: action))
    }
}

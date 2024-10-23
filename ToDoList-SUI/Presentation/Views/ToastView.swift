//
//  ToastView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 23.10.2024.
//

import SwiftUI

// Модификатор для отображения Toast
// @Binding<String> message для сообщения, скроется как message = ""
// Позиция: .top или .bottom
// Используем: View.showToast("Этот тост появится сверху!")
struct ToastModifier: ViewModifier {
    @Binding var message: String
    var position: ToastPosition // Добавляем перечисление для ограничения

    func body(content: Content) -> some View {
        content
            .overlay(
                toastView,
                alignment: alignment
            )
    }

    // Определяем выравнивание в зависимости от позиции
    private var alignment: Alignment {
        switch position {
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }

    // Определяем с какого края будет анимация
    private var edge: Edge {
        switch position {
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }

    // Вспомогательное свойство для создания представления Toast
    @ViewBuilder
    private var toastView: some View {
        if !message.isEmpty {
            ToastView(message: message)
                .transition(.move(edge: edge).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            message = "" // Автоматическое скрытие через 3 секунды
                        }
                    }
                }
        }
    }
}

// Расширение для удобного использования модификатора
extension View {
    func showToast(_ message: Binding<String>, position: ToastPosition = .top) -> some View {
        self.modifier(ToastModifier(message: message, position: position))
    }
}

// Перечисление для ограничения выравнивания на .top или .bottom
enum ToastPosition {
    case top
    case bottom
}

// Представление для Toast
struct ToastView: View {
    var message: String

    var body: some View {
        Text(message)
            .lineLimit(5)
            .multilineTextAlignment(.center)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity)
            .padding()
    }
}

//
//  EditScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 14.10.2024.
//

import SwiftUI

struct EditScreen: View {
    @State private var viewModel: EditViewModel
    // Сразу установим фокус на первое поле ввода
    @FocusState private var focusedField: Field?
    enum Field {
        case title, text
    }

    init(_ item: ToDoItem? = nil, viewModel: EditViewModel) {
        self.viewModel = viewModel
        self.viewModel.editItem(item)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            TextField("Task title", text: $viewModel.title)
                .focused($focusedField, equals: .title)
                .font(.headline)
                .padding()
                .background()
                .cornerRadius(Constants.cornerRadius)
                .keyboardType(.alphabet)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .text  // Переключаемся на следующее поле
                }
            TextField("Task text", text: $viewModel.text)
                .focused($focusedField, equals: .text)
                .font(.subheadline)
                .padding()
                .background()
                .cornerRadius(Constants.cornerRadius)
                .keyboardType(.alphabet)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = nil  // Скрываем клавиатуру после завершения ввода
                }
            DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
            DatePicker("Time", selection: $viewModel.date, displayedComponents: .hourAndMinute)
            Toggle(isOn: $viewModel.isCritical) {
                Label("Important task", systemImage: "bolt")
            }
            ButtonBackgroundView("Save", disabled: viewModel.isSaveDisabled, onClick: viewModel.save)
            
            Spacer()
        }
        .padding()
        // MARK: - Navigation
        .navigationTitle(viewModel.newTask ? "New task" : "Edit")
        .navigationBarTitleDisplayMode(.inline)
        // MARK: - Navigation Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                ButtonBackView(onClick: viewModel.close)
            }
        }
        // MARK: - Toast, Alert
        .showToast($viewModel.toastMessage)
        .showAlert($viewModel.alertMessage)
        // MARK: - Background
        .background {
            BackgroundView()
        }
        .onAppear {
            focusedField = .title
        }
    }
}

#Preview {
    NavigationView {
        EditScreen(viewModel: DIManager.shared.resolve())
    }
}

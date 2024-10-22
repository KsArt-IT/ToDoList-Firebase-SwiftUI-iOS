//
//  RegistrationScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import SwiftUI

struct RegistrationScreen: View {
    @State private var viewModel: RegistrationViewModel
    // Сразу установим фокус на первое поле ввода
    @FocusState private var focusedField: Field?
    enum Field {
        case email, password, passwordConfirm
    }
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Image("loginLogo")
                .resizable()
                .layoutPriority(-1)
                .scaledToFit()
                .frame(width: 100, height: 100)
            TextField("Type email", text: $viewModel.login)
                .focused($focusedField, equals: .email)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password  // Переключаемся на следующее поле
                }
                .padding(.vertical)
            SecureField("Type password", text: $viewModel.password)
                .focused($focusedField, equals: .password)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(10)
                .keyboardType(.alphabet)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .passwordConfirm  // Переключаемся на следующее поле
                }
            SecureField("Confirm password", text: $viewModel.passwordConfirm)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(10)
                .keyboardType(.alphabet)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = nil  // Скрываем клавиатуру после завершения ввода
                }
                .padding(.vertical)
            ButtonBackgroundView("Register", disabled: viewModel.isLoginDisabled, onClick: viewModel.register)
                .padding(.vertical)
            Spacer()
        }
        .padding()
        .navigationTitle("Registration")
        .background {
            BackgroundView()
        }
        .onAppear {
            focusedField = .email
        }
    }
}

#Preview {
    RegistrationScreen(
        viewModel: RegistrationViewModel(
            router: RouterApp(),
            repository: FirebaseAuthRepositoryImpl(service: FirebaseAuthServiceImpl()),
            validation: Validation()
        )
    )
}

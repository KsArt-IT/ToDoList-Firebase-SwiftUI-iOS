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
        VStack(spacing: 16) {
            LoginLogoView()
            TextField("Type email", text: $viewModel.login)
                .textContentType(.emailAddress)
                .focused($focusedField, equals: .email)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(Constants.cornerRadius)
                .errorMessage(viewModel.emailError, cornerRadius: Constants.cornerRadius)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password  // Переключаемся на следующее поле
                }
            SecureField("Type password", text: $viewModel.password)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(Constants.cornerRadius)
                .errorMessage(viewModel.passwordError, cornerRadius: Constants.cornerRadius)
                .keyboardType(.alphabet)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .passwordConfirm  // Переключаемся на следующее поле
                }
            SecureField("Confirm password", text: $viewModel.passwordConfirm)
                .textContentType(.newPassword)
                .focused($focusedField, equals: .passwordConfirm)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(Constants.cornerRadius)
                .errorMessage(viewModel.passwordConfirmError, cornerRadius: Constants.cornerRadius)
                .keyboardType(.alphabet)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = nil  // Скрываем клавиатуру после завершения ввода
                }
            ButtonBackgroundView("Register", disabled: viewModel.isLoginDisabled, onClick: viewModel.register)
            Spacer()
        }
        .padding()
        .navigationTitle("Registration")
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

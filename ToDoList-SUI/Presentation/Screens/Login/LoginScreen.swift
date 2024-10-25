//
//  LoginScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 18.10.2024.
//

import SwiftUI
import GoogleSignIn

struct LoginScreen: View {
    @State private var viewModel: LoginViewModel
    // Сразу установим фокус на первое поле ввода
    @FocusState private var focusedField: Field?
    enum Field {
        case email, password
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.isInitialized && !viewModel.isClose {
            VStack(spacing: 16) {
                Image("loginLogo")
                    .resizable()
                    .layoutPriority(-1)
                    .scaledToFit()
                    .frame(maxWidth: 100, maxHeight: 100)
                TextField("Type email", text: $viewModel.login)
                    .focused($focusedField, equals: .email)
                    .font(.body)
                    .layoutPriority(1)
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
                    .focused($focusedField, equals: .password)
                    .font(.body)
                    .layoutPriority(1)
                    .padding()
                    .background()
                    .cornerRadius(Constants.cornerRadius)
                    .errorMessage(viewModel.passwordError, cornerRadius: Constants.cornerRadius)
                    .keyboardType(.alphabet)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField = nil  // Скрываем клавиатуру после завершения ввода
                    }
                Button("Forgot your password?") {
                    viewModel.toResetPassword()
                }
                .foregroundStyle(.text)
                .frame(maxWidth: .infinity, alignment: .trailing)
                ButtonBackgroundView("Login", disabled: viewModel.isLoginDisabled, onClick: viewModel.signIn)
                ButtonBackgroundView("Sign in with Google account", onClick: viewModel.showSignInGoogle)
                Spacer()
                ButtonView("SignUp", onClick: viewModel.toRegistration)
                
                // отобразить окно логина через google
                if !viewModel.signInGoogleWithClientID.isEmpty {
                    SignInGoogleView(
                        clientID: $viewModel.signInGoogleWithClientID,
                        action: viewModel.signInGoogle
                    )
                }
            }
            .padding(.horizontal)
            .navigationTitle("Authorization")
            .navigationBarBackButtonHidden(true) // скрыть кнопку назад
            .interactiveDismissDisabled() // закрывать представление и запретить навигацию назад
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
        } else {
            if viewModel.isInitialized {
                BackgroundView()
            } else {
                SplashScreen()
            }
        }
    }
}

#Preview {
    LoginScreen(
        viewModel: LoginViewModel(
            router: RouterApp(),
            repository: FirebaseAuthRepositoryImpl(service: FirebaseAuthServiceImpl()),
            validation: Validation(),
            initialized: true
        )
    )
}

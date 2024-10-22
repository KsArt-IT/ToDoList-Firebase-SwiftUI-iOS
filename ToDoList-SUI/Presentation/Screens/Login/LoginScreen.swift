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
            VStack {
                Image("loginLogo")
                    .resizable()
                    .layoutPriority(-1)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                TextField("Type email", text: $viewModel.login)
                    .focused($focusedField, equals: .email)
                    .font(.body)
                    .layoutPriority(1)
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
                    .layoutPriority(1)
                    .padding()
                    .background()
                    .cornerRadius(10)
                    .keyboardType(.alphabet)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField = nil  // Скрываем клавиатуру после завершения ввода
                    }
                Button {
                    viewModel.toResetPassword()
                } label: {
                    HStack {
                        Spacer()
                        Text("Forgot your password?")
                            .foregroundStyle(.text)
                    }
                }
                .padding(.vertical)
                ButtonBackgroundView("Login", disabled: viewModel.isLoginDisabled, onClick: viewModel.signIn)
                ButtonBackgroundView("Sign in with Google account", onClick: viewModel.signInGoogle)
                    .padding(.top)
                Spacer()
                ButtonView("SignUp", onClick: viewModel.toRegistration)
                
                if viewModel.isSignInGoogle {
                    SignInGoogleView(
                        clientID: viewModel.clientID,
                        action: viewModel.submitSignInGoogle,
                        closed: viewModel.onCloseSignInGoogle
                    )
                }
            }
            .padding()
            .navigationTitle("Authorization")
            .navigationBarBackButtonHidden(true) // скрыть кнопку назад
            .interactiveDismissDisabled() // закрывать представление и запретить навигацию назад
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

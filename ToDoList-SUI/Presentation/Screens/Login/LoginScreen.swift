//
//  LoginScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 18.10.2024.
//

import SwiftUI

struct LoginScreen: View {
    @State private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Image("loginLogo")
                .resizable()
                .frame(width: 100, height: 100)
            TextField("Type email", text: $viewModel.login)
                .font(.headline)
                .padding()
                .background()
                .cornerRadius(10)
                .padding(.vertical)
            TextField("Type password", text: $viewModel.password)
                .font(.headline)
                .padding()
                .background()
                .cornerRadius(10)
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
                .padding(.vertical)
            Spacer()
            ButtonView("SignUp", onClick: viewModel.toRegistration)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled()
        .background {
            BackgroundView()
        }
    }
}

#Preview {
    LoginScreen(viewModel: LoginViewModel(router: RouterApp(), validation: Validation()))
}

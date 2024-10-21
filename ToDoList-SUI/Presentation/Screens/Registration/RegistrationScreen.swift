//
//  RegistrationScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import SwiftUI

struct RegistrationScreen: View {
    @State private var viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Image("loginLogo")
                .resizable()
                .frame(width: 100, height: 100)
            TextField("Type email", text: $viewModel.login)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(10)
                .padding(.vertical)
            SecureField("Type password", text: $viewModel.password)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(10)
            SecureField("Confirm password", text: $viewModel.passwordConfirm)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(10)
                .padding(.vertical)
            ButtonBackgroundView("Register", disabled: viewModel.isLoginDisabled, onClick: viewModel.register)
                .padding(.vertical)
            Spacer()
        }
        .padding()
        .background {
            BackgroundView()
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

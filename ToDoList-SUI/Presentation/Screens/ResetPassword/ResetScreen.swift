//
//  ResetScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 22.10.2024.
//

import SwiftUI

struct ResetScreen: View {
    @State private var viewModel: ResetViewModel
    @FocusState private var isFocused: Bool
    
    init(viewModel: ResetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Image("loginLogo")
                .resizable()
                .frame(width: 100, height: 100)
            TextField("Type email", text: $viewModel.email)
                .focused($isFocused)
                .font(.body)
                .padding()
                .background()
                .cornerRadius(Constants.cornerRadius)
                .errorMessage(viewModel.emailError, cornerRadius: Constants.cornerRadius)
                .keyboardType(.emailAddress)
                .submitLabel(.done)
                .onSubmit {
                    isFocused = false
                }
                .padding(.vertical)
            ButtonBackgroundView("Reset password", disabled: viewModel.isButtonDisabled, onClick: viewModel.resetPassword)
            if !viewModel.time.isEmpty {
                Text(viewModel.time)
                    .font(.title)
                    .padding()
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Title Reset password")
        .showToast($viewModel.showToast)
        .showAlert($viewModel.showAlert, action: viewModel.actionAlert)
        .background {
            BackgroundView()
        }
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
//    ResetScreen()
}

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
        VStack(spacing: 16) {
            LoginLogoView()
            TextField("Type email", text: $viewModel.email)
                .textContentType(.emailAddress)
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
            ButtonBackgroundView("Reset password", disabled: viewModel.isButtonDisabled, onClick: viewModel.resetPassword)
            Spacer()
            if !viewModel.time.isEmpty {
                Text(viewModel.time)
                    .font(.title)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Title Reset password")
        // MARK: - Navigation Back
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                ButtonBackView(onClick: viewModel.close)
            }
        }
        // MARK: - Toast, Alert
        .showToast($viewModel.toastMessage)
        .showAlert($viewModel.alertMessage, action: viewModel.actionAlert)
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

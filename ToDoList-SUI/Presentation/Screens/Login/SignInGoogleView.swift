//
//  LoginGoogleView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import SwiftUI
import GoogleSignIn

// Отображение ViewController с логином через google
struct SignInGoogleView: View {
    @Binding var clientID: String
    // Передать токен
    var action: (String, String) -> Void
    
    var body: some View {
        VStack{
            
        }
        .onAppear {
            print("LoginGoogleView: \(#function)")
            showGoogleAuthVC()
        }
    }
    
    /// Создать ViewController, иотобразить его для входа в Google акаунт
    private func showGoogleAuthVC() {
        print("LoginGoogleView: \(#function)")
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            close()
            return
        }
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            
            if let error {
                print("Error doing Google Sign-In, \(error.localizedDescription)")
                close()
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            
            action(idToken, user.accessToken.tokenString)
            close()
        }
    }
    
    private func close() {
        clientID = ""
    }
}

//
//  LoginViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 18.10.2024.
//

import Foundation

@Observable
final class LoginViewModel {
    
    private let router: Router
    private let validation: Validation
    
    var login: String = "test@gmail.com"
    var password: String = "test"
    var isLoginDisabled: Bool {
        !(checkLogin() && checkPassword())
    }
    
    init(
        router: Router,
        validation: Validation
    ) {
        self.router = router
        self.validation = validation
        
        // проверить авторизацию
        self.checkAuthorization()
    }
    
    private func checkLogin() -> Bool {
        validation.isEmail(login)
    }

    private func checkPassword() -> Bool {
        validation.isPassword(password)
    }
    
    private func checkAuthorization() {
        // сначала проверим необходим ли релогин
        if Profile.isRelogin {
            logout()
        } else {
            // проверить авторизацию
//            Profile.login(user: )
        }
        // перейдем на главный экран
        if Profile.user != nil {
            toHome()
        }
    }
    
    public func signIn() {
        if !isLoginDisabled {
            avtorized()
            toHome()
        }
    }
    
    private func avtorized() {
        // test
        Profile.login(user: UserAuth(id: "", token: "", refreshToken: "", name: "test", email: "test@gmail.com", photoUrl: nil, photo: nil, date: Date()))
    }
    
    public func signInGoogle() {
        
    }
    
    private func logout() {
        Profile.logout()
        
    }
    
    // MARK: - Navigation
    public func toResetPassword() {
        router.navigate(to: .resetPassword)
    }

    private func toHome() {
        print(#function)
        router.navigate(to: .home)
    }
    
    public func toRegistration() {
        router.navigate(to: .registration)
    }
}

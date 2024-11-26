//
//  LoginViewModel.swift
//  ToDoList-SUI
//
//  Created by KsArT on 18.10.2024.
//

import Foundation

@Observable
final class LoginViewModel {
    
    @ObservationIgnored private let router: Router
    @ObservationIgnored private let repository: AuthRepository
    @ObservationIgnored private let validation: Validation
    var isInitialized: Bool
    
    var login: String = "" {
        didSet {
            emailError = ""
        }
    }
    var password: String = "" {
        didSet {
            passwordError = ""
        }
    }
    var isLoginDisabled: Bool {
        !(isCanClick && checkLogin() && checkPassword())
    }
    @ObservationIgnored private var isCanClick = true
    
    // Вход через гугл
    var signInGoogleWithClientID = ""
    
    var isClose = false
    // отображение тостов и алертов
    var toastMessage = ""
    var alertMessage: AlertModifier.AlertType = ("", false)
    
    // Отображение ошибок в полях ввода
    var emailError = ""
    var passwordError = ""
    
    init(
        router: Router,
        repository: AuthRepository,
        validation: Validation,
        initialized: Bool
    ) {
        self.router = router
        self.repository = repository
        self.validation = validation
        self.isInitialized = initialized
        
        // проверить авторизацию и получить дааные пользователя
        self.checkAuthorization()
    }
    
    private func checkLogin() -> Bool {
        validation.isEmail(login)
    }
    
    private func checkPassword() -> Bool {
        validation.isPassword(password)
    }
    
    private func checkAuthorization() {
        print("LoginViewModel: \(#function)")
        // сначала проверим необходим ли релогин
        if Profile.isInitialized && Profile.isRelogin {
            logout()
        } else {
            Task { [weak self] in
                await self?.showSplashIfNeed()
                await self?.fetchAuthUser()
            }
        }
    }
    
    private func fetchAuthUser() async {
        let result = await repository.fetchAuthUser()
        switch result {
        case .success(let user):
            print("LoginViewModel: \(#function) on")
            Profile.login(user: user)
            toHome()
        case .failure(let error):
            isInitialized = true
            guard Profile.isInitialized else { break }
            Profile.logout()
            showError(error)
        }
    }
    
    private func logout() {
        Task { [weak self] in
            Profile.logout()
            let result = await self?.repository.logout()
            // проверить на ошибки сети
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    public func signIn() {
        guard !isLoginDisabled else { return }
        print("LoginViewModel: \(#function)")
        
        isCanClick = false
        Task { [weak self] in
            guard let self else { return }
            
            let result = await self.repository.signIn(email: self.login, password: self.password)
            switch result {
            case .success(_):
                // успешная авторизация, получить пользователя и перейти на основной экран
                await self.showToastAuth()
                await self.fetchAuthUser()
            case .failure(let error):
                isCanClick = true
                self.showError(error)
            }
        }
    }
    
    public func showSignInGoogle() {
        guard signInGoogleWithClientID.isEmpty else { return }
        print("LoginViewModel: \(#function)")
        
        Task { [weak self] in
            let result = await self?.repository.signInGoogle()
            switch result {
            case .success(let clientID):
                self?.signInGoogleWithClientID = clientID
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    public func signInGoogle(idToken: String, accessToken: String) {
        Task { [weak self] in
            let result = await self?.repository.signIn(withIDToken: idToken, accessToken: accessToken)
            switch result {
            case .success(_):
                // успешная авторизация, получить пользователя и перейти на основной экран
                await self?.showToastAuth()
                await self?.fetchAuthUser()
            case .failure(let error):
                self?.showError(error)
            case .none:
                break
            }
        }
    }
    
    private func showError(_ error: Error) {
        guard let error = error as? NetworkServiceError else {
            showAlert(error.localizedDescription, isError: true)
            return
        }
        print("LoginViewModel: \(#function), Error: \(error.localizedDescription)")
        switch error {
        case .invalidRequest, .invalidResponse, .invalidDatabase,
                .statusCode(_, _), .decodingError(_), .networkError(_),
                .invalidCredential, .userNotFound, .userDisabled:
            showToast(error.localizedDescription)
        case .invalidEmail, .emailAlreadyInUse:
            emailError = error.localizedDescription
        case .wrongPassword, .weakPassword:
            passwordError = error.localizedDescription
        case .cancelled, .profileNotInitialized:
            break
        }
    }
    
    private func showToastAuth() async {
        showToast(String(localized: "Successful authorization"))
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
    }
    
    private func showAlert(_ message: String, isError: Bool = false) {
        alertMessage = (message, isError)
    }
    
    private func showSplashIfNeed() async {
        if !Profile.isInitialized {
            // пауза на отображение splashscreen
            try? await Task.sleep(nanoseconds: Constants.timeSplashVisible)
        }
    }
    
    // MARK: - Navigation
    public func toResetPassword() {
        router.navigate(to: .resetPassword)
    }
    
    private func toHome() {
        isClose = true
        Profile.initialize()
        router.navigateToRoot()
    }
    
    public func toRegistration() {
        router.navigate(to: .registration)
    }
    
}

//
//  FirebaseAuthServiceImpl.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

final class FirebaseAuthServiceImpl: AuthService {

    func logout() async -> Result<Bool, Error> {
        do {
            try Auth.auth().signOut()
            return .success(true)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }

    func fetchAuthUser() async -> Result<UserAuth, Error> {
        do {
            guard let user = Auth.auth().currentUser else {
                return .failure(NetworkServiceError.cancelled)
            }
            let token = try await user.getIDToken()
            let photo: Data? = await getPhoto(url: user.photoURL)
            let userAuth = UserAuth(
                id: user.uid,
                token: token,
                refreshToken: user.refreshToken ?? "",
                name: user.displayName ?? "No name",
                email: user.email ?? "No Email",
                photoUrl: user.photoURL?.absoluteString,
                photo: photo,
                date: Date()
            )
            return .success(userAuth)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }

    private func getPhoto(url: URL?) async -> Data? {
        guard let url else { return nil }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                return nil
            }
            return data
        } catch {
            return nil
        }
    }

    func signIn(email: String, password: String) async -> Result<Bool, Error>{

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("Auth result=\(result)")
            return .success(true)
        } catch {
            return if let errorCode = AuthErrorCode(rawValue: error._code) {
                switch errorCode {
                    case .invalidEmail:
                            .failure(NetworkServiceError.invalidEmail)
                    case .wrongPassword:
                            .failure(NetworkServiceError.wrongPassword)
                    case .userNotFound:
                            .failure(NetworkServiceError.userNotFound)
                    case .userDisabled:
                            .failure(NetworkServiceError.userDisabled)
                    case .invalidCredential:
                            .failure(NetworkServiceError.invalidCredential)
                    default:
                            .failure(NetworkServiceError.networkError(error))
                }
            } else {
                .failure(NetworkServiceError.networkError(error))
            }
        }
    }

    func signUp(email: String, password: String) async -> Result<Bool, Error>{

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("Auth result=\(result)")
            return .success(true)
        } catch {
            return if let errorCode = AuthErrorCode(rawValue: error._code) {
                switch errorCode {
                    case .emailAlreadyInUse:
                            .failure(NetworkServiceError.emailAlreadyInUse)
                    case .invalidEmail:
                            .failure(NetworkServiceError.invalidEmail)
                    case .weakPassword:
                            .failure(NetworkServiceError.weakPassword)
                    default:
                            .failure(NetworkServiceError.networkError(error))
                }
            } else {
                .failure(NetworkServiceError.networkError(error))
            }
        }
    }

    func resetPassword(email: String) async -> Result<Bool, Error>{

        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("Auth result=Ok")
            return .success(true)
        } catch {
            return if let errorCode = AuthErrorCode(rawValue: error._code) {
                switch errorCode {
                    case .emailAlreadyInUse:
                            .failure(NetworkServiceError.emailAlreadyInUse)
                    case .invalidEmail:
                            .failure(NetworkServiceError.invalidEmail)
                    case .weakPassword:
                            .failure(NetworkServiceError.weakPassword)
                    default:
                            .failure(NetworkServiceError.networkError(error))
                }
            } else {
                .failure(NetworkServiceError.networkError(error))
            }
        }
    }

    // вход через google аккаунт
    func signIn(withIDToken: String, accessToken: String) async -> Result<Bool, Error> {
        do {
            let credential = GoogleAuthProvider.credential(withIDToken: withIDToken, accessToken: accessToken)
            let result = try await Auth.auth().signIn(with: credential)
            let user = result.user
            print("Auth result=Ok, user=\(user)")
            return .success(true)
        } catch {
            return .failure(NetworkServiceError.networkError(error))
        }
    }
}

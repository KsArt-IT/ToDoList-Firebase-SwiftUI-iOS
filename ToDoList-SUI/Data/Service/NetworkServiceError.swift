//
//  NetworkServiceError.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import Foundation

enum NetworkServiceError: Error {
    // отменен запрос
    case cancelled
    //
    case invalidRequest
    case invalidResponse
    case invalidDatabase
    case statusCode(code: Int, message: String)
    case decodingError(DecodingError)
    case networkError(Error)
    // FirebaseAuth
    case invalidEmail
    case emailAlreadyInUse
    
    case wrongPassword
    case weakPassword
    
    case userNotFound
    case userDisabled
    case invalidCredential
    // MARK: - Description
    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            String(localized: "The request is invalid.")
        case .invalidResponse:
            String(localized: "The response is invalid.")
        case .invalidDatabase:
            String(localized: "Database is not connected.")
        case .statusCode(let code, let message):
            String(localized: "Unexpected status code") + ": \(code). \(message)."
        case .decodingError(let error):
            String(localized: "Decoding failed with error") + ": \(error.localizedDescription)."
        case .networkError(let error):
            String(localized: "Network error occurred") + ": \(error.localizedDescription)."
        case .cancelled:
            ""
        case .invalidEmail:
            String(localized: "Invalid email format.")
        case .emailAlreadyInUse:
            String(localized: "This email is already in use.")
        case .wrongPassword:
            String(localized: "Incorrect password entered.")
        case .weakPassword:
            String(localized: "The password is too weak.")
        case .userNotFound:
            String(localized: "A user with this email does not exist.")
        case .userDisabled:
            String(localized: "The user account has been blocked.")
        case .invalidCredential:
            String(localized: "The supplied auth credential is malformed or has expired.")
        }
    }
}

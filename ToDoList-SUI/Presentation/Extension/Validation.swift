//
//  EmailValidation.swift
//  ToDoList-SUI
//
//  Created by KsArT on 18.10.2024.
//

import Foundation

final class Validation {
    private let emailPredicat = NSPredicate(
        format: "SELF MATCHES %@",
        "^(?=[a-z0-9][a-z0-9@._%+-]{5,253}$)([a-z0-9_-]+\\.)*[a-z0-9_-]+@[a-z0-9_-]+(\\.[a-z0-9_-]+)*\\.[a-z]{2,63}$"
    )
    
    public func isEmail(_ email: String) -> Bool {
        !email.isEmpty && emailPredicat.evaluate(with: email.lowercased())
    }
    
    public func isPassword(_ password: String) -> Bool {
        !password.isEmpty && password.count > 3
    }
}

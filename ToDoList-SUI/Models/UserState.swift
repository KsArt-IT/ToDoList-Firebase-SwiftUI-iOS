//
//  User.swift
//  ToDoList-SUI
//
//  Created by KsArT on 19.10.2024.
//

import Foundation

public enum Profile {
    // Храненим авторизованного пользователя
    private(set) static var user: UserAuth? {
        didSet {
            isRelogin = (user == nil)
        }
    }

    // Флаг для проверки, нужно ли перелогиниваться
    private(set) static var isRelogin: Bool = true

    static func login(user: UserAuth) {
        self.user = user
    }
    
    static func logout() {
        self.user = nil
    }
}

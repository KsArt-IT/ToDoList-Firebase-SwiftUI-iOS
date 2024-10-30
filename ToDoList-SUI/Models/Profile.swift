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

    private(set) static var profile = UserData(
        email: "",
        name: "",
        gender: Gender.male,
        age: 0,
        aboutMe: "",
        photoUrl: "",
        photoData: nil,
        taskCreated: 0,
        taskActive: 0,
        taskDeleted: 0,
        taskCompleted: 0
    )
    
    // Флаг для проверки, нужно ли перелогиниваться
    private(set) static var isRelogin: Bool = true
    // Отобразить SplashScreen если false
    private(set) static var isInitialized = false
    
    static func login(user: UserAuth) {
        self.user = user
    }
    
    static func logout() {
        self.user = nil
    }
    
    static func initialize() {
        self.isInitialized = true
    }
}

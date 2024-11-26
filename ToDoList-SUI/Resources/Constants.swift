//
//  Constants.swift
//  ToDoList-SUI
//
//  Created by KsArT on 23.10.2024.
//

import Foundation

enum Constants {
    // Название приложения из Bundle
    static let appName: String = {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ??
        "ToDo List"
    }()
    
    static let timeSplashVisible: UInt64 = 2500000000 // 2.5 seconds

    static let cornerRadius: CGFloat = 10
    static let timeInterval: Int = 60
    static let buttonDisabled: CGFloat = 0.5
}

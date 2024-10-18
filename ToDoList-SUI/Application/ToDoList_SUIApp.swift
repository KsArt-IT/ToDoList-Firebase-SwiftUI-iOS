//
//  ToDoList_SUIApp.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI
import FirebaseCore

@main
struct ToDoList_SUIApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
}

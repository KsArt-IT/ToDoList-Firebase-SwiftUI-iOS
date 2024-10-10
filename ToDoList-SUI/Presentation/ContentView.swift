//
//  ContentView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var router = AppRouter(.splash)
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            HomeScreen()
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        EmptyView()
                            .onAppear {
                                router.navigateToRoot()
                            }
                    case .splash:
                        SplashScreen()
                            .navigationBarBackButtonHidden(true)
                            .interactiveDismissDisabled()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    router.navigateToRoot()
                                }
                            }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}

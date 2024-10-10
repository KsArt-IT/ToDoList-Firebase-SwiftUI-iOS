//
//  HomeScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(AppRouter.self) var router
    
    var body: some View {
        VStack {
            Text("Home Screen")
        }
//        .navigationTitle("Home")
    }
    
}

#Preview {
    HomeScreen()
}

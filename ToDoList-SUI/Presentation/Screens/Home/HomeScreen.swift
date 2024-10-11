//
//  HomeScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(AppRouter.self) var router
    @Environment(\.homeViewModelValue) var viewModel
    
    var body: some View {
        VStack {
            Text("Home Screen \(viewModel?.update ?? -1)")
        }
//        .navigationTitle("Home")
    }
    
}

#Preview {
//    HomeScreen()
}

//
//  HomeScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            BackgroundView()
            
            LazyVStack {
                ForEach(viewModel.list) { item in
                    ItemView(item: item)
                }
            }
        }
        .navigationTitle("To Do List")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.edit()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            print("релоад: \(#function)")
            viewModel.loadData()
        }
    }
    
}

#Preview {
    HomeScreen(viewModel: DIManager.shared.resolve())
}

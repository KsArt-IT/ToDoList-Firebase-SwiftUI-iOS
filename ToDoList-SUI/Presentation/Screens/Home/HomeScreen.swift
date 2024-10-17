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
            
            List {
                ForEach(viewModel.list) { item in
                    ItemView(item: item, toggle: viewModel.toggleCompleted, action: viewModel.edit)
                }
                .onDelete(perform: viewModel.delete)
            }
            .listStyle(.plain)
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
    }
    
}

#Preview {
    HomeScreen(viewModel: HomeViewModel(router: RouterApp(), repository: DataRepositoryPreview()))
}

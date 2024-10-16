//
//  EditScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 14.10.2024.
//

import SwiftUI

struct EditScreen: View {
    @State var viewModel: EditViewModel
    
    init(_ id: String = "", viewModel: EditViewModel) {
        self.viewModel = viewModel
        self.viewModel.loadItem(id)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                TextField("Task title", text: $viewModel.title)
                    .font(.headline)
                    .padding()
                    .background()
                    .cornerRadius(10)
                    .padding()
                TextField("Task text", text: $viewModel.text)
                    .font(.subheadline)
                    .padding()
                    .background()
                    .cornerRadius(10)
                    .padding(.horizontal)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    .padding()
                DatePicker("Time", selection: $viewModel.date, displayedComponents: .hourAndMinute)
                    .padding(.horizontal)
                Toggle(isOn: $viewModel.isCritical) {
                    Text("Important task")
                }
                .padding()
                Button {
                    viewModel.save()
                } label: {
                    Text("Save")
                        .foregroundStyle(.primary)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background()
                        .cornerRadius(10)
                        .padding()
                }
                
                Spacer()
            }
        }
        // MARK: - Navigation
        .navigationTitle(viewModel.newTask ? "New task" : "Edit")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    viewModel.toBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        EditScreen(viewModel: DIManager.shared.resolve())
    }
}

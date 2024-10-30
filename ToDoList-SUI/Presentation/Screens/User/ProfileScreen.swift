//
//  ProfileScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import SwiftUI

struct ProfileScreen: View {
    @State private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                ProfileImage(data: viewModel.profile?.photoData, gender: viewModel.profile?.gender)
                    .frame(maxWidth: .infinity)
                Spacer()
            }
            ProfileFigureView()
            VStack {
                Spacer()
                Text(viewModel.profile?.name ?? "name")
                    .font(.title2)
                HStack(alignment: .top) {
                    ProfileImage(data: viewModel.profile?.photoData, gender: viewModel.profile?.gender)
                        .clipShape(.circle)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .padding(.horizontal)
                    Text(viewModel.profile?.aboutMe ?? "about me")
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                }
                HStack {
                    Spacer()
                    ParamView(title: "Task Active", value: viewModel.profile?.taskActive)
                    Spacer()
                    ParamView(title: "Task Completed", value: viewModel.profile?.taskCompleted)
                    Spacer()
                    ParamView(title: "Task Created", value: viewModel.profile?.taskCreated)
                    Spacer()
                    ParamView(title: "Task Deleted", value: viewModel.profile?.taskDeleted)
                }
                .padding()
                .frame(height: 100)
            }
        }
        .padding(24)
        // MARK: - Navigation
        .navigationTitle("Title Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    viewModel.close()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .foregroundStyle(.accent)
                }
            }
        }
        // MARK: - Toast, Alert
        .showToast($viewModel.toastMessage)
        .showAlert($viewModel.alertMessage)
        // MARK: - Background
        .background {
            BackgroundView()
        }
    }
}

#Preview {
    //    ProfileScreen(ProfileViewModel())
}

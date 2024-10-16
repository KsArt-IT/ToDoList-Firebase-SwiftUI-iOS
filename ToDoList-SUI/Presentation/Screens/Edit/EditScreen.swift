//
//  EditScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 14.10.2024.
//

import SwiftUI

struct EditScreen: View {
    @Environment(\.editViewModel) var viewModel
    @State var id: String
    
    init(_ id: String = "") {
        self.id = id
    }
    
    var body: some View {
        ZStack{
            BackgroundView()
            
            VStack{
                Text(viewModel?.item?.title ?? "")
                Button {
                    viewModel?.save()
                } label: {
                    Text(Strings.buttonSave)
                }
            }
        }
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel?.getItem(id)
        }
    }
}

#Preview {
    EditScreen()
}

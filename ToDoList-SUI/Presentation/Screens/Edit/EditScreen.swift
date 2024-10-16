//
//  EditScreen.swift
//  ToDoList-SUI
//
//  Created by KsArT on 14.10.2024.
//

import SwiftUI

struct EditScreen: View {
    @Environment(\.router) var router
    @Environment(EditViewModel.self) var viewModel: EditViewModel?
    
    init(_ id: String = "") {
        self.viewModel?.getItem(id)
    }
    
    var body: some View {
        Text(viewModel?.item?.title ?? "")
        Button {
            viewModel?.save()
        } label: {
            Text("Save")
        }
    }
}

#Preview {
    EditScreen()
}

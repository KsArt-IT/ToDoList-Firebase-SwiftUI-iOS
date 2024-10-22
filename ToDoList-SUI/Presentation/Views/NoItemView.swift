//
//  NoItemView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 17.10.2024.
//

import SwiftUI

struct NoItemView: View {
    
    let addItem: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("Add your first task!")
                .font(.title)
                .foregroundStyle(Color.backgroundSecond)
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                addItem()
            } label: {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .padding(30)
                    .background(Color.backgroundFirst)
                    .opacity(0.5)
                    .clipShape(.circle)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NoItemView() {}
}

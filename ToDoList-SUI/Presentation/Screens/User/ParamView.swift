//
//  ParamView.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import SwiftUI

struct ParamView: View {
    var title: LocalizedStringResource
    var value: Int?
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            Spacer()
            Text("\(value ?? 0)")
                .font(.title2)
        }
    }
}

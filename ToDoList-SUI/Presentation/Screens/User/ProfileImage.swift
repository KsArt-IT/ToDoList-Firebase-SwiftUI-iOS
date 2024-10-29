//
//  ProfileImage.swift
//  ToDoList-SUI
//
//  Created by KsArT on 29.10.2024.
//

import SwiftUI

struct ProfileImage: View {
    var data: Data?
    var gender: Gender?
    
    var body: some View {
        if let data, let image = CIImage(data: data)?.cgImage {
            Image(decorative: image, scale: 1.0, orientation: .up)
                .resizable()
                .scaledToFit()
        } else {
            Image(gender == .female ? "woman" : "man")
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    ProfileImage()
}

//
//  ViewError.swift
//  ToDoList-SUI
//
//  Created by KsArT on 21.10.2024.
//

import Foundation

enum ViewError {
    case none
    case email(message: String)
    case password(message: String)
    case alert(message: String)
}

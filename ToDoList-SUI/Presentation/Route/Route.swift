//
//  Route.swift
//  ToDoList-SUI
//
//  Created by KsArT on 10.10.2024.
//

enum Route: Hashable {
//    case splash // перенесено в login
//    case home // root
    case edit(id: String)
    case login
    case registration
    case resetPassword
}

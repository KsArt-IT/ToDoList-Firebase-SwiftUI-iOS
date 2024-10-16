//
//  DataService.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation

protocol DataService: AnyObject {
    func fetchData() async -> Result<[ToDoItem], any Error>
    func fetchData(_ id: String) async -> Result<ToDoItem?, any Error>
    func saveData(_ item: ToDoItem) async -> Result<Bool, any Error>
    func updateData(_ item: ToDoItem) async -> Result<Bool, any Error>
    func deleteData(_ id: String) async -> Result<Bool, any Error>
}

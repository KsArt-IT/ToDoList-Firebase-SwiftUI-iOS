//
//  DBLocal.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//


import Foundation

final class LocalDataServiceImpl: DataService {
    
    private var items: [String: ToDoItem] = [:]

    func fetchData() async -> Result<[ToDoItem], any Error> {
        .success(Array(items.values))
    }
    
    func saveData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        items[item.id] = item
        return .success(true)
    }
    
    func updateData(_ item: ToDoItem) async -> Result<Bool, any Error> {
        await saveData(item)
    }
    
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        items.removeValue(forKey: id)
        return .success(true)
    }
}

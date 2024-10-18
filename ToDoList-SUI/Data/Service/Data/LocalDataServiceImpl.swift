//
//  DBLocal.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation
import Combine

final class LocalDataServiceImpl: DataService {
    
    private var items: [String: ToDoDTO] = [:] {
        didSet { saveUD() }
    }
    private let updateSubject = PassthroughSubject<String, Never>()
    public var updatePublisher: AnyPublisher<String, Never> {
        updateSubject.eraseToAnyPublisher()
    }
    private let keyUD = "ToDoList.key"
    
    init() {
        loadUD()
    }
    
    func fetchData() async -> Result<[ToDoDTO], any Error> {
        return .success(getArray())
    }
    
    func fetchData(_ id: String) async -> Result<ToDoDTO?, any Error> {
        .success(items[id])
    }
    
    func saveData(_ item: ToDoDTO) async -> Result<Bool, any Error> {
        items[item.id] = item
        updateSubject.send(item.id)
        return .success(true)
    }
    
    func updateData(_ item: ToDoDTO) async -> Result<Bool, any Error> {
        await saveData(item)
    }
    
    func deleteData(_ id: String) async -> Result<Bool, any Error> {
        items.removeValue(forKey: id)
        return .success(true)
    }
    
    private func loadUD() {
        Task {
            guard let data = UserDefaults.standard.data(forKey: keyUD) else { return }
            do {
                let list = try JSONDecoder().decode([ToDoDTO].self, from: data)
                setItems(list)
            } catch {
                print("LocalDataServiceImpl: error load data: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveUD() {
        Task {
            do {
                let data = try JSONEncoder().encode(getArray())
                UserDefaults.standard.set(data, forKey: keyUD)
            } catch {
                print("LocalDataServiceImpl: error save data: \(error.localizedDescription)")
            }
        }
    }
    
    private func getArray() -> Array<ToDoDTO> {
        Array(items.values)
    }
    
    private func setItems(_ list: Array<ToDoDTO>) {
        items = list.reduce(into: [String: ToDoDTO]()) { dict, item in
            dict[item.id] = item
        }
    }
}

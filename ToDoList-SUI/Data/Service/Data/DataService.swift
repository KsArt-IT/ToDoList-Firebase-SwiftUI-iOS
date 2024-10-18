//
//  DataService.swift
//  ToDoList-SUI
//
//  Created by KsArT on 11.10.2024.
//

import Foundation
import Combine

protocol DataService: AnyObject {
    func fetchData() async -> Result<[ToDoDTO], any Error>
    func fetchData(_ id: String) async -> Result<ToDoDTO?, any Error>
    func saveData(_ item: ToDoDTO) async -> Result<Bool, any Error>
    func updateData(_ item: ToDoDTO) async -> Result<Bool, any Error>
    func deleteData(_ id: String) async -> Result<Bool, any Error>
    
    var updatePublisher: AnyPublisher<String, Never> { get }
}

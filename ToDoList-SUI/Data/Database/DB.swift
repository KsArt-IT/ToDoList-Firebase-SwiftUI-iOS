//
//  DB.swift
//  ToDoList-SUI
//
//  Created by KsArT on 25.10.2024.
//


import Foundation

enum DB {
    
    enum Users {
        static let name = "users"
    }
    
    enum Todos {
        static let name = "todos"
    }
    
}

/*
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Ограничиваем доступ к коллекции users
    match /users/{userId} {
      
      // Чтение и запись данных пользователя возможны только для авторизованного пользователя
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Ограничиваем доступ к вложенной коллекции todos
      match /todos/{todoId} {
        
        // Доступ к задачам только для авторизованного пользователя
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
*/

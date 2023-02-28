//
//  CheckBox.swift
//  TodoList
//
//  Created by Gabriel Campos on 20/2/23.
//

import Foundation

enum TodoState: String, Codable {
    case complete = "Complete"
    case pending = "Pending"
    
    mutating func toggle() {
        if self == .complete {
            self = .pending
        } else {
            self = .complete
        }
    }
}

enum TodoPriority: String, Codable {
    case urgent = "Urgent"
    case noUrgent = "No urgent"
    case noSelected = "No Priority Selected"

    
    
}


struct TodoItem: Codable {
    var id = UUID().uuidString
    var todoText: String
    var state: TodoState
    var priority: TodoPriority
    
}

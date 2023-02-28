//
//  TodoItemViewModel.swift
//  TodoList
//
//  Created by Gabriel Campos on 20/2/23.
//

import Foundation


class TodoItemViewModel: Codable {
    
    var todoItem: TodoItem {
        get {
            _todoItem ?? TodoItem(todoText: "", state: .pending, priority: .noSelected)
        } set {
           _todoItem = newValue
        }
    }
    
    private var _todoItem: TodoItem?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._todoItem = try container.decodeIfPresent(TodoItem.self, forKey: ._todoItem)
    }
    
    init() {
        
    }
    
    enum CodingKeys: CodingKey {
        case _todoItem
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self._todoItem, forKey: ._todoItem)
    }
    
}

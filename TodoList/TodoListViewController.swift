//
//  ViewController.swift
//  TodoList
//
//  Created by Gabriel Campos on 14/2/23.
//

import UIKit

class TodoListViewController: UIViewController, TodoTableViewCellDelegate {
    let tableView = UITableView()
    var items = [TodoItemViewModel]()
    let defaults = UserDefaults.standard
    
    var addNavigationBarImage = UIImage(systemName: "plus")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Todo List"
        

        
        if let savedTodoItems = defaults.object(forKey: "TodoItems") as? Data {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([TodoItemViewModel].self, from: savedTodoItems)
                items = decodedData
                print(decodedData[0].todoItem)
                tableView.reloadData()
            } catch {
                print("Error decoding todos: \(error.localizedDescription)")
            }
        }
        
        view.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(tableView)
        
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                        target: self,
                                                                        action: #selector(presentAddEditTodo))
    }
    
    @objc   private func presentAddEditTodo() {
        let taskEditVC = TaskEditViewController()
        taskEditVC.delegate = self
        let taskEditNavigationController = UINavigationController(rootViewController: taskEditVC)
        taskEditNavigationController.view.backgroundColor = .systemBackground
        taskEditNavigationController.modalPresentationStyle = .popover
        self.present(taskEditNavigationController, animated: true, completion: nil)
    }
    
    
    private func presentEditingTodoVC(indexPath: IndexPath) {
        let taskEditVC = TaskEditViewController()
        taskEditVC.delegate = self
        taskEditVC.newTodo = items[indexPath.row]
        taskEditVC.deleteTodoButton.isHidden = false
        taskEditVC.todoEditMode = true
        let taskEditNavigationController = UINavigationController(rootViewController: taskEditVC)
        taskEditNavigationController.view.backgroundColor = .systemBackground
        taskEditNavigationController.modalPresentationStyle = .popover
        self.present(taskEditNavigationController, animated: true, completion: nil)
    }
    
    func saveItemsToUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(items)
            defaults.set(data, forKey: "TodoItems")
        } catch {
            print("Error saving items: \(error.localizedDescription)")
        }
        
    }

    private func setUpView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
}

extension TodoListViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        cell.setup(with: items[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        cell.translatesAutoresizingMaskIntoConstraints = true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentEditingTodoVC(indexPath: indexPath)
    }
    
    private func handleDelete(indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        saveItemsToUserDefaults()
    }
    
    private func handleEditItem(indexPath: IndexPath) {
        presentEditingTodoVC(indexPath: indexPath)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.handleDelete(indexPath: indexPath)
            completionHandler(true)
        }
        delete.backgroundColor = .red
        
        let edit = UIContextualAction(style: .normal,
                                      title: "Edit") { [weak self ] (action, view, completionHandler) in
            self?.handleEditItem(indexPath: indexPath)
            completionHandler(true)
        }
        edit.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        return configuration
    }
    
    
    func addNewTodo(viewModel: TodoItemViewModel) {
        items.append(viewModel)
        tableView.reloadData()
        saveItemsToUserDefaults()
    }
    
    func deleteTodo(viewModel: TodoItemViewModel) {
        if let currentTodoItemIndex = items.firstIndex(where: {viewModel.todoItem.id == $0.todoItem.id }) {
            items.remove(at: currentTodoItemIndex)
            tableView.reloadData()
            saveItemsToUserDefaults()
        }
    }
    
    func editTodoItem(viewModel: TodoItemViewModel) {
        if let currentTodoItemIndex = items.firstIndex(where: {viewModel.todoItem.id == $0.todoItem.id }) {
            items[currentTodoItemIndex] = viewModel
            tableView.reloadData()
            saveItemsToUserDefaults()
        }
    }
    
    func didMarkTodoComplete() {
        saveItemsToUserDefaults()
    }
}

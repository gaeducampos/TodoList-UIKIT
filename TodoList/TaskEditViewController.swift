//
//  TaskEditViewController.swift
//  TodoList
//
//  Created by Gabriel Campos on 22/2/23.
//

import UIKit

class TaskEditViewController: UIViewController {
    // MARK: Delegate Property
    weak var delegate: TodoListViewController?
    
    var todoEditMode = false
    var newTodo: TodoItemViewModel = TodoItemViewModel()
    

    lazy var todoItemLabel: UILabel = {
        let label = UILabel()
        label.text = "Todo:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var todoPriorityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = TodoPriority.noSelected.rawValue
        label.isEnabled = false
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusPriorityLabel: UILabel = {
        let label = UILabel()
        label.text = "Priority:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var todoItemTextField: UITextField = {
       let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Enter your Todo"
        textfield.delegate = self
        return textfield
    }()
    
    lazy var todoCurrentStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pending"
        label.isEnabled = false
        return label
    }()
    
    
    lazy var noUrgentAction = UIAction(title: TodoPriority.noUrgent.rawValue,
                                      image: UIImage(systemName: "hourglass.bottomhalf.filled"),
                                      attributes: [],
                                      state: .off)
    { [unowned self] action in
        setupPrioritySelection(priority: .noUrgent)
    }
    
    lazy var urgentAction =  UIAction(title: TodoPriority.urgent.rawValue,
                                       image: UIImage(systemName: "exclamationmark.triangle.fill"),
                                       attributes: [],
                                       state: .off)
     { [unowned self] action in
         setupPrioritySelection(priority: .urgent)
     }
    
    lazy var todoStatePendingAction = UIAlertAction(title: TodoState.pending.rawValue,
                                                  style: .default)
    { [unowned self ] action in
        newTodo.todoItem.state = .pending
    }
    
    
    
    lazy var todoStateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select The Status", for: .normal)
        button.setImageWithColor(iconName: "arrow.down", color: .white)
        return button
    }()
    
    lazy var statusPriorityButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose your priority", for: .normal)
        button.setImageWithColor(iconName: "arrow.down", color: .white)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        button.showsMenuAsPrimaryAction = true
        button.menu = UIMenu(title: "", children: [noUrgentAction, urgentAction])
        return button
    }()
    
    lazy var addTodoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(todoEditMode ? "Edit Todo" : "Add Todo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleTodoActionButton), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }()
    
    
    lazy var deleteTodoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete Todo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(deleteTodo), for: .touchUpInside)
        button.backgroundColor = .red
        button.isHidden = true
        
        return button
    }()
    
    lazy var todoFormStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [todoItemLabel,
                                                       todoItemTextField,
                                                       statusLabel,
                                                       todoCurrentStatusLabel,
                                                      statusPriorityLabel,
                                                       todoPriorityLabel,
                                                       statusPriorityButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 25.0
        stackView.alignment = .leading
        
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.view,
                                         action: #selector(UIView.endEditing))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.addSubview(todoFormStackView)
        view.addSubview(addTodoButton)
        view.addSubview(deleteTodoButton)

        
        setUpView()
        setupForm()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                                 target: self,
                                                                 action: #selector(dismissTaskEditVC))
    }
    
    private func setUpView() {
        NSLayoutConstraint.activate([
            todoFormStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            todoFormStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            todoFormStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            
            todoItemTextField.trailingAnchor.constraint(equalTo: todoFormStackView.trailingAnchor),
            todoItemTextField.leadingAnchor.constraint(equalTo: todoFormStackView.leadingAnchor),
            
            statusPriorityButton.widthAnchor.constraint(equalToConstant: 200),
            statusPriorityButton.heightAnchor.constraint(equalToConstant: 35),
            
            addTodoButton.widthAnchor.constraint(equalToConstant: 100),
            addTodoButton.heightAnchor.constraint(equalToConstant: 35),
            addTodoButton.topAnchor.constraint(equalTo: todoFormStackView.bottomAnchor, constant: 20),
            addTodoButton.trailingAnchor.constraint(equalTo: todoFormStackView.trailingAnchor),
            
            deleteTodoButton.widthAnchor.constraint(equalToConstant: 100),
            deleteTodoButton.heightAnchor.constraint(equalToConstant: 35),
            deleteTodoButton.topAnchor.constraint(equalTo: todoFormStackView.bottomAnchor, constant: 20),
            deleteTodoButton.leadingAnchor.constraint(equalTo: todoFormStackView.leadingAnchor)
            
            
        ])
    }
    
    private func setupPrioritySelection(priority: TodoPriority) {
        newTodo.todoItem.priority = priority
        todoPriorityLabel.text = priority.rawValue
        statusPriorityButton.setTitle(priority.rawValue, for: .normal)
        if priority == .urgent {
            statusPriorityButton.setImageWithColor(iconName: "exclamationmark.triangle.fill", color: .white)
        } else {
            statusPriorityButton.setImageWithColor(iconName: "hourglass.bottomhalf.filled", color: .white)
        }
    }
    
    private func setupForm() {
        todoItemTextField.text = newTodo.todoItem.todoText
        todoCurrentStatusLabel.text = newTodo.todoItem.state.rawValue
        todoPriorityLabel.text = newTodo.todoItem.priority.rawValue
    }
    
    
   @objc private func dismissTaskEditVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
        
    @objc private func deleteTodo() {
        delegate?.deleteTodo(viewModel: newTodo)
        dismissTaskEditVC()
    
    }

    @objc private func addNewTodo() {
        newTodo.todoItem.state = TodoState.pending
        if let text = todoItemTextField.text, !text.isEmpty, newTodo.todoItem.priority != .noSelected {
            newTodo.todoItem.todoText = text
            delegate?.addNewTodo(viewModel: newTodo)
            dismissTaskEditVC()
        } else {
            let alert = UIAlertController(title: "",
                                          message: "You haven't complete the information of the Todo.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
    @objc private func editTodo() {
        guard let todoText = todoItemTextField.text else { return }
        newTodo.todoItem.todoText = todoText
        delegate?.editTodoItem(viewModel: newTodo)
        dismissTaskEditVC() 
    }
    
    @objc private func handleTodoActionButton() {
        if todoEditMode {
            return editTodo()
        } else {
            return addNewTodo()
        }
    }
    

}

extension TaskEditViewController:  UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

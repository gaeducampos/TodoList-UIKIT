//
//  TodoListTableViewCell.swift
//  TodoList
//
//  Created by Gabriel Campos on 20/2/23.
//

import UIKit

protocol TodoTableViewCellDelegate: AnyObject {
    func didMarkTodoComplete()
}


class TodoTableViewCell: UITableViewCell {
    
    var viewModel: TodoItemViewModel?
    
    var checkbox = UIButton(type: .system)
    var checkBoxImage = UIImage(systemName: "circle")
    let todoItemLabel = UILabel()
    
    weak var delegate: TodoTableViewCellDelegate?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        checkbox.setImage(checkBoxImage, for: .normal)
        checkbox.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        
        
        let stackView = UIStackView(arrangedSubviews: [todoItemLabel, checkbox])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalCentering
        
        let wrapperView = UIView()
        wrapperView.addSubview(stackView)
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.layer.borderWidth = 1.0
        wrapperView.layer.borderColor = self.traitCollection.userInterfaceStyle == .dark
        ? UIColor.white.cgColor
        : UIColor.black.cgColor
        wrapperView.layer.cornerRadius = 10.0
        wrapperView.clipsToBounds = true
        
        
        contentView.addSubview(wrapperView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 60),
            
            
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            wrapperView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),


            stackView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),

        ])
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        
    }
    
    
    @objc func toggleSelection(_ sender: UIButton) {
        viewModel?.todoItem.state.toggle()
        setupView()
        delegate?.didMarkTodoComplete()
    }
    
    
    func setup(with viewModel: TodoItemViewModel) {
        self.viewModel = viewModel
        todoItemLabel.text = viewModel.todoItem.todoText
        setupView()
    }
    
    private func setupView() {
        if viewModel?.todoItem.state == .complete {
            let StikeThroughAttributeText = NSMutableAttributedString(string: todoItemLabel.text ?? "")
            StikeThroughAttributeText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                       value: 2,
                                       range: NSMakeRange(0, StikeThroughAttributeText.length))
            
            todoItemLabel.attributedText = StikeThroughAttributeText
            checkbox .setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            
        } else {
            let nonStikeThroughAttributeText = NSMutableAttributedString(string: todoItemLabel.text ?? "")
            todoItemLabel.attributedText = nonStikeThroughAttributeText
            checkbox.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
    }

}

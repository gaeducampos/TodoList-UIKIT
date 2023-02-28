////
////  TodoNavigationViewController.swift
////  TodoList
////
////  Created by Gabriel Campos on 22/2/23.
////
//
//import UIKit
//
//class TodoNavigationViewController: UINavigationController {
//
//    let todoVC = TodoListViewController()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        
//        self.pushViewController(todoVC, animated: true)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
//                                                                 target: self,
//                                                                 action: #selector(presentAddEditTodo))
//        
//    }
//    
//    @objc private func presentAddEditTodo() {
//        print("hi")
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

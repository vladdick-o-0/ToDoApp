//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vlad Boguzh on 2023-03-03.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    private var tasks: [Task] = []
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGray5
        table.delegate = self
        table.dataSource = self
        table.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = fetchData()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButttonTapped(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButttonTapped))
        
        title = "To-Do"
        
        view.addSubview(tableView)
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc private func editButttonTapped(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    @objc private func addButttonTapped() {
        print("addButton tapped")
    }
    
}


// MARK: - Extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier, for: indexPath) as! ToDoCell
        
        let task = tasks[indexPath.row]
        cell.setupCell(task: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movedItem, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = markTaskAsDone(at: indexPath)
        let pinAction = markTaskAsPinned(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [doneAction, pinAction])
    }
    
    func markTaskAsDone(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") {
            [weak self] (_, _, completionHandler) in
            
            self?.tasks.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        
        return action
    }
    
    func markTaskAsPinned(at indexPath: IndexPath) -> UIContextualAction {
        var task = tasks[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Pin") {
            [weak self] (_, _, completionHandler) in

            task.isPinned = !task.isPinned
            self?.tasks[indexPath.row] = task
            completionHandler(true)
        }
        action.backgroundColor = .systemOrange
        action.image = task.isPinned ? UIImage(systemName: "pin.slash") : UIImage(systemName: "pin")
        return action
    }
}


// the method to put all the tasks to array
extension ViewController {
    private func fetchData() -> [Task] {
        return [
            Task(emoji: "😃", task: "Buy some vegetables", date: "22 nov", isPinned: false),
            Task(emoji: "😛", task: "Clean my teeth", date: "today", isPinned: false),
            Task(emoji: "😃", task: "Clean up my room", date: "4 dec", isPinned: false),
        ]
    }
}

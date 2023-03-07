//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vlad Boguzh on 2023-03-03.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Variables
    var tasks: [[Task]] = [[], [], []] // 0 is pinned, 1 is regular, 2 is done
    private var lastSelectedIndexPath: IndexPath?
    
    
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
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButttonTapped(_:)))
        return button
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButttonTapped))
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks[1] = fetchData()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = editButton
        
        navigationItem.rightBarButtonItem = addButton
        
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
        let viewController = AddViewController(currentTask: nil, isEditingExistingTask: false)
        viewController.passDataBackDelegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .popover
        
        showDetailViewController(navigationController, sender: self)
    }
    
}


// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pinned"
        case 1:
            return "Regular"
        case 2:
            return "Done"
        default:
            fatalError("section is undefined")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier, for: indexPath) as! ToDoCell
        
        let task = tasks[indexPath.section][indexPath.row]
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
        let allowedSection = indexPath.section
        return indexPath.section == allowedSection
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let lastRowInSection = tableView.numberOfRows(inSection: sourceIndexPath.section)
        // we do not subtract 1 because when we are trying to move the row to another section the number of rows in origin section becomes one less
        let movedItem = tasks[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        
        if sourceIndexPath.section < destinationIndexPath.section {
            tasks[sourceIndexPath.section].insert(movedItem, at: lastRowInSection)
        } else if sourceIndexPath.section > destinationIndexPath.section {
            tasks[sourceIndexPath.section].insert(movedItem, at: 0)
        } else {
            tasks[sourceIndexPath.section].insert(movedItem, at: destinationIndexPath.row)
            
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = markTaskAsDone(at: indexPath)
        let pinAction = markTaskAsPinned(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [doneAction, pinAction])
    }
    
    func markTaskAsDone(at indexPath: IndexPath) -> UIContextualAction {
        var task = tasks[indexPath.section][indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Done") {
            [weak self] (_, _, completionHandler) in
            
            var sectionToPut = 2
            if !task.isDone {
                sectionToPut = 2
            } else {
                sectionToPut = 1
            }
            self?.tasks[indexPath.section].remove(at: indexPath.row)
            task.isDone = !task.isDone
            self?.tasks[sectionToPut].append(task)
            
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .right)
            self?.tableView.insertRows(at: [IndexPath(row: self!.tasks[sectionToPut].count - 1, section: sectionToPut)], with: .left)
            self?.tableView.endUpdates()
            
            completionHandler(true)
        }
        action.backgroundColor = .systemGreen
        action.image = task.isDone ? UIImage(systemName: "circle") : UIImage(systemName: "checkmark.circle")
        return action
    }
    
    func markTaskAsPinned(at indexPath: IndexPath) -> UIContextualAction {
        var task = tasks[indexPath.section][indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Pin") {
            [weak self] (_, _, completionHandler) in
            
            var sectionToPut = 0
            if !task.isPinned {
                sectionToPut = 0
            } else {
                sectionToPut = 1
            }
            self?.tasks[indexPath.section].remove(at: indexPath.row)
            task.isPinned = !task.isPinned
            self?.tasks[sectionToPut].append(task)
            
            self?.tableView.beginUpdates()
            self?.tableView.deleteRows(at: [indexPath], with: .right)
            self?.tableView.insertRows(at: [IndexPath(row: self!.tasks[sectionToPut].count - 1, section: sectionToPut)], with: .left)
            self?.tableView.endUpdates()
            
            completionHandler(true)
        }
        action.backgroundColor = .systemOrange
        action.image = task.isPinned ? UIImage(systemName: "pin.slash") : UIImage(systemName: "pin")
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastSelectedIndexPath = tableView.indexPathForSelectedRow
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTask = tasks[indexPath.section][indexPath.row]
        
        let viewController = AddViewController(currentTask: selectedTask, isEditingExistingTask: true)
        viewController.passDataBackDelegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .popover
        
        showDetailViewController(navigationController, sender: self)
    }
}

extension MainViewController: PassDataBackDelegate {
    func sendNewTask(task: Task) {
        tasks[1].append(task)
        tableView.reloadData()
    }
    func sendExistingTask(task: Task) {
        if let selectedIndexPath = lastSelectedIndexPath {
            tasks[selectedIndexPath.section][selectedIndexPath.row] = task
        }
        tableView.reloadData()
    }
}


// the method to put all the tasks to array
extension MainViewController {
    private func fetchData() -> [Task] {
        return [
            Task(emoji: "😃", task: "Buy some vegetables", date: "22 nov", isPinned: false, isDone: false),
            Task(emoji: "😛", task: "Clean my teeth", date: "today", isPinned: false, isDone: false),
            Task(emoji: "😃", task: "Clean up my room", date: "4 dec", isPinned: false, isDone: false),
        ]
    }
}

//
//  ViewController.swift
//  ToDoApp
//
//  Created by Vlad Boguzh on 2023-03-03.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    
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
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = editButtonItem
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
    
    @objc private func addButttonTapped() {
        print("addButton tapped")
    }
                                                        
}


// MARK: - Extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier, for: indexPath) as! ToDoCell
        
        return cell
    }

    
}


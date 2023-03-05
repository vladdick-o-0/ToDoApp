//
//  AddViewController.swift
//  ToDoApp
//
//  Created by Vlad Boguzh on 2023-03-05.
//

import UIKit

class AddViewController: UIViewController {
    
    
    // MARK: - UI Elements
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Emoji"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emojiStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Task"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Wash the dishes"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var taskStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "22 nov"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - setupViews
    private func setupViews() {
        view.backgroundColor = .systemGray6
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButttonTapped(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButttonTapped))
        
        title = "Task"
        
        
        emojiStackView.addArrangedSubview(emojiLabel)
        emojiStackView.addArrangedSubview(emojiTextField)
        
        taskStackView.addArrangedSubview(taskLabel)
        taskStackView.addArrangedSubview(taskTextField)
        
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(dateTextField)
        
        mainStackView.addArrangedSubview(emojiStackView)
        mainStackView.addArrangedSubview(taskStackView)
        mainStackView.addArrangedSubview(dateStackView)
        
        view.addSubview(mainStackView)
        
    }
    
    // MARK: - setupConstraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            emojiStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            taskStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            taskStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            dateStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            dateStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            mainStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            emojiTextField.widthAnchor.constraint(equalTo: emojiStackView.widthAnchor),
            taskTextField.widthAnchor.constraint(equalTo: emojiStackView.widthAnchor),
            dateTextField.widthAnchor.constraint(equalTo: emojiStackView.widthAnchor),
        ])
    }
    
    @objc private func cancelButttonTapped(_ sender: UIBarButtonItem) {
        print("cancel")
    }
    
    @objc private func saveButttonTapped() {
        print("save")
    }
}


// MARK: - Extensions


//
//  PassDataBackDelegate.swift
//  ToDoApp
//
//  Created by Vlad Boguzh on 2023-03-05.
//

import UIKit

protocol PassDataBackDelegate {
    func sendNewTask(task: Task)
    func sendExistingTask(task: Task)
}

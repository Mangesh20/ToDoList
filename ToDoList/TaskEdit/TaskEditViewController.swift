//
//  TaskEditViewController.swift
//  ToDoList
//
//  Created by mangesht on 20/04/23.
//

import UIKit

protocol TaskEditDelegate: AnyObject {
    func taskAdded()
}


class TaskEditViewController: UIViewController {
    
    // MARK: - Properties
    
    var task: Task?
    weak var delegate: TaskEditDelegate?
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet var lblTitleTaskPriority: UILabel!
    @IBOutlet weak var lblTitleDeadline: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        configureTask()
    }
    
    // MARK: - Configuration
    
    private func configureView() {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: taskNameTextField.frame.height))
        taskNameTextField.leftView = paddingView
        taskNameTextField.leftViewMode = .always

        view.backgroundColor = AppTheme.View.backgroundColor
        taskNameTextField.layer.cornerRadius = 10
        taskNameTextField.layer.borderWidth = 1
        taskNameTextField.layer.borderColor = UIColor.gray.cgColor
        
        taskNameTextField.font = AppTheme.Text.subHeading
        taskNameTextField.textColor = AppTheme.Text.headingColor
        
        lblTitleDeadline.font = AppTheme.Text.title
        lblTitleDeadline.textColor = AppTheme.Text.titleColor
        
        lblTitleTaskPriority.font = AppTheme.Text.title
        lblTitleTaskPriority.textColor = AppTheme.Text.titleColor
        
    }
    
    
    // Returns a TaskEditViewController instance from a storyboard with a given identifier.
    static func storyboardInstance() -> TaskEditViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "TaskEditViewController") as? TaskEditViewController else {
            fatalError("Unable to instantiate TaskEditViewController from storyboard")
        }
        return viewController
    }

    private func configureNavigationBar() {
        navigationItem.title = "Add Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped(_:)))
    }
    
    private func configureTask() {
        guard let task = task else { return }
        taskNameTextField.text = task.name
        if let deadline = task.deadline {
            deadlinePicker.date = deadline
        }
        setSegmentedControlFromPriority(task.priority, segmentedControl: prioritySegmentedControl)
    }
    
    func setSegmentedControlFromPriority(_ priority: TaskPriority, segmentedControl: UISegmentedControl) {
        switch priority {
        case .high:
            segmentedControl.selectedSegmentIndex = 1
        case .medium:
            segmentedControl.selectedSegmentIndex = 2
        case .low:
            segmentedControl.selectedSegmentIndex = 3
        case .none:
            segmentedControl.selectedSegmentIndex = 0
        }
    }

    // MARK: - Actions
    
    @objc private func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = taskNameTextField.text, !name.isEmpty else {
            // Show an alert if the name field is empty
            let alert = UIAlertController(title: "Name is required", message: "Please enter a name for the task", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
        
        // Update the task with the entered data
        if let task = task {
            task.name = name
            task.deadline = deadlinePicker.date
            task.priority = TaskPriority.getPriorityFromSegmentedControl(prioritySegmentedControl)
            TaskDataSource.shared.updateTask(task)
        } else {
            // Create a new task with the entered data
            let task = Task(name: name, deadline: deadlinePicker.date, priority: TaskPriority.getPriorityFromSegmentedControl(prioritySegmentedControl), taskID: "\(Date().description)")
            TaskDataSource.shared.addTask(task)
        }
        
        delegate?.taskAdded()
        
        // Pop the TaskEditViewController from the navigation stack
        navigationController?.popViewController(animated: true)
    }
}

//
//  ViewController.swift
//  ToDoList
//
//  Created by mangesht on 20/04/23.
//

import UIKit


enum SortingMode: Int  {
    case byTimeAscending = 0
    case byTimeDescending = 1
    case byPriorityAscending = 2
    case byPriorityDescending = 3
    
    var lable : String {
        get {
            switch self {
                
            case .byTimeAscending:
                return "Time Ascending"
                
            case .byTimeDescending:
                return "Time Descending"
                
            case .byPriorityAscending:
                return "Priority Ascending"
                
            case .byPriorityDescending:
                return "Priority Descending"
                
            }
        }
    }
}


class TaskListViewController: UIViewController {
    
    
    @IBOutlet weak var taskCollectionView: UICollectionView!
    private var sourceIndexPath: IndexPath?
    private var snapshotView: UIView?
    



    var sortingMode: SortingMode = .byTimeAscending {
        didSet {
            lblSortMode.text = "Sorted by : \(sortingMode.lable)"
            
        }
    }
    @IBOutlet weak var lblSortMode: UILabel!
    
    
    var allTasks: [Task] = [] {
        didSet {
            splitTasks()
        }
    }
    var pendingTasks: [Task] = []
    var completedTasks: [Task] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To Do"
        lblSortMode.text = "Sorted: None"
        
        // Load tasks from data source
        allTasks = TaskDataSource.shared.fetchTasks()
        
        // Configure collection view
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        
        
        taskCollectionView.register(UINib(nibName: "TaskCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TaskCollectionViewCell")
        taskCollectionView.register(UINib(nibName: "DoneTaskCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DoneTaskCollectionViewCell")

        taskCollectionView.register(SortingHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SortingHeaderView")
        
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8 // Set the horizontal spacing between items
        layout.minimumLineSpacing = 8 // Set the vertical spacing between lines of items
        taskCollectionView.collectionViewLayout = layout
        
        // Create the add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        // Set the add button as the right bar button item
        navigationItem.rightBarButtonItem = addButton
        
        
        // Create the shuffle button
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(shuffleTasks))
        
        

        // Set the shuffle button as the left bar button item
        navigationItem.leftBarButtonItem = sortButton
        

        // Navigation title font and color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: AppTheme.NavigationBar.titleFont, NSAttributedString.Key.foregroundColor: AppTheme.NavigationBar.titleColor]
        

        lblSortMode.font = AppTheme.Text.subHeading
        lblSortMode.textColor = AppTheme.Text.subHeadingColor
        

        taskCollectionView.backgroundColor = AppTheme.CollectionView.backgroundColor

    }
    
    var sortingModeIndex = 0
    
    func getSortingModeForShuffle() -> SortingMode {
        sortingMode = SortingMode(rawValue: sortingModeIndex) ?? .byTimeAscending
        sortingModeIndex += 1
        sortingModeIndex = sortingModeIndex % 4
        return sortingMode
    }
    
    private func splitTasks() {
        pendingTasks = allTasks.filter { !$0.isDone }
        completedTasks = allTasks.filter { $0.isDone }
    }
    
    @objc func shuffleTasks() {
        
        
        var indexDict = [String: Int]()
        for (index, task) in pendingTasks.enumerated() {
            indexDict[task.taskID!]  = index
        }
        
        switch getSortingModeForShuffle() {
            
        case .byTimeAscending:
            pendingTasks.sort(by: { $0.deadline! > $1.deadline! })
            
        case .byTimeDescending:
            pendingTasks.sort(by: { $0.deadline! < $1.deadline! })
            
        case .byPriorityAscending:
            pendingTasks.sort(by: { $0.priority < $1.priority })
            
        case .byPriorityDescending:
            pendingTasks.sort(by: { $0.priority >  $1.priority })
            
        }
        
        let newIndexes = pendingTasks.map { element in
            return indexDict[element.taskID!]
        }
        
        
        // Update the task order in the data source
        
        
        //
        //        // Animate the cell changes
        taskCollectionView.performBatchUpdates({
            for (index, newIndex) in newIndexes.enumerated() {
                if let cell = taskCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                    taskCollectionView.moveItem(at: IndexPath(item: index, section: 0), to: IndexPath(item: newIndex!, section: 0))
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.2, animations: {
                            cell.transform = CGAffineTransform.identity
                        })
                    })
                }
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.taskCollectionView.reloadData()
        }
        
    }
    
    
    @objc func addTask() {
        // Instantiate the TaskEditViewController
        let taskEditVC = TaskEditViewController.storyboardInstance()
        taskEditVC.delegate = self
        // Push the TaskEditViewController onto the navigation stack
        navigationController?.pushViewController(taskEditVC, animated: true)
    }
    
    
    func deleteTask(at index: Int) {
        pendingTasks.remove(at: index)
        taskCollectionView.reloadData()
    }
    
}

extension TaskListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return pendingTasks.count
        } else {
            return completedTasks.count
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
            cell.delegate = self
            cell.task = pendingTasks[indexPath.item]
            cell.indexPath = indexPath
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoneTaskCollectionViewCell", for: indexPath) as! DoneTaskCollectionViewCell
            cell.titleLabel.text = completedTasks[indexPath.item].name
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var task:Task?
        if indexPath.section == 0 {
            task = pendingTasks[indexPath.item]
        } else {
            task = completedTasks[indexPath.item]
        }
        let taskEditViewController = TaskEditViewController.storyboardInstance()
        taskEditViewController.task = task
        taskEditViewController.delegate = self
        navigationController?.pushViewController(taskEditViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: ((UIScreen.main.bounds.width - 30) / 2), height: 120)
            
        } else {
            return CGSize(width: ((UIScreen.main.bounds.width - 30) / 2), height:80)
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Set the inset for the section (the spacing around the outside of the items)
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: (UIScreen.main.bounds.width), height: 0)
            
        } else {
            return CGSize(width: (UIScreen.main.bounds.width), height: 40)
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SortingHeaderView", for: indexPath) as! SortingHeaderView
            if indexPath.section == 1 {
                headerView.sortingLabel.font = AppTheme.SectionHeader.titleFont
                headerView.sortingLabel.textColor = AppTheme.SectionHeader.titleTextColor
                headerView.sortingLabel.text = "Archived"
            }
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
}


extension TaskListViewController: TaskEditDelegate {
    func taskAdded() {
        allTasks = TaskDataSource.shared.fetchTasks()
        taskCollectionView.reloadData()
    }
}


extension TaskListViewController: TaskCollectionViewCellDelegate {
    func markDoneFor(task: Task, indexPath: IndexPath) {
        TaskDataSource.shared.markDone(task)
        self.allTasks = TaskDataSource.shared.fetchTasks()
        self.taskCollectionView.reloadData()

    }
    
    func deleteTapFor(task: Task, indexPath: IndexPath) {
        TaskDataSource.shared.deleteTask(task)
        self.allTasks = TaskDataSource.shared.fetchTasks()
        self.taskCollectionView.reloadData()
    }
}

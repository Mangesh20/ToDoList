//
//  Task.swift
//  ToDoList
//
//  Created by mangesht on 20/04/23.
//

import Foundation
import CoreData
import UIKit

enum TaskPriority: String, Comparable {
    case high = "high"
    case medium = "Medium"
    case low = "low"
    case none = "none"
    
    static func getPriorityFromSegmentedControl(_ segmentedControl: UISegmentedControl) -> TaskPriority {
        switch segmentedControl.selectedSegmentIndex {
        case 3:
            return .high
        case 2:
            return .medium
        case 1:
            return .low
        default:
            return .none
        }
    }
    
    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        let priorities: [TaskPriority] = [.high, .medium, .low, .none]
        guard let lhsIndex = priorities.firstIndex(of: lhs),
              let rhsIndex = priorities.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }


}

class Task {
    var name: String
    var deadline: Date?
    var priority: TaskPriority
    var isDone: Bool
    var id: NSManagedObjectID?
    var taskID: String?

    init(name: String, deadline: Date?, priority: TaskPriority, taskID: String) {
        self.name = name
        self.deadline = deadline
        self.priority = priority
        self.isDone = false
        self.taskID = taskID
    }
    
    convenience init(entity: TaskEntity) {
        self.init(
            name: entity.name ?? "",
            deadline: entity.deadline,
            priority: TaskPriority(rawValue: entity.priority ?? "none") ?? .none,
            taskID: entity.taskID!
        )
        self.isDone = entity.isDone
        self.id = entity.objectID
    }
}




//
//  TaskDataSource.swift
//  ToDoList
//
//  Created by mangesht on 20/04/23.
//

import Foundation
import CoreData
import UIKit

class TaskDataSource {
    
    static let shared = TaskDataSource()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let entities = try persistentContainer.viewContext.fetch(request)
            return entities.map { Task(entity: $0) }
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    func addTask(_ task: Task) {
        let context = persistentContainer.viewContext
        let entity = TaskEntity(context: context)
        entity.name = task.name
        entity.deadline = task.deadline
        entity.priority = task.priority.rawValue
        entity.isDone = task.isDone
        entity.taskID = task.taskID
        saveContext()
    }
    
    func updateTask(_ task: Task) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "taskID = %@", task.taskID!)
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                entity.name = task.name
                entity.deadline = task.deadline
                entity.priority = task.priority.rawValue
                entity.isDone = task.isDone
                entity.taskID = task.taskID
            }
            saveContext()
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }
    }
    
    func markDone(_ task: Task) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "taskID = %@", task.taskID!)
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                entity.deadline = task.deadline
                entity.priority = task.priority.rawValue
                entity.isDone = true
                entity.taskID = task.taskID
            }
            saveContext()
        } catch {
            print("Error updating task: \(error.localizedDescription)")
        }

    }
    
    func deleteTask(_ task: Task) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "taskID = %@", task.taskID!)
        do {
            let entities = try context.fetch(request)
            for entity in entities {
                context.delete(entity)
            }
            saveContext()
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
}


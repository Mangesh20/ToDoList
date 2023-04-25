//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Mangesh Tekale on 21/04/23.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppTheme.configNavigatorBar()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storboard =  UIStoryboard(name: "Main", bundle: nil)
        let listVC = storboard.instantiateViewController(withIdentifier: "TaskListViewController") as? TaskListViewController
        let nVC = UINavigationController(rootViewController: listVC!)
        self.window?.rootViewController = nVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
}


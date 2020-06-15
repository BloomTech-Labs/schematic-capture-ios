//
//  SceneDelegate.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/23/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData
import SwiftyDropbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var dropboxController = DropboxController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        setupRootViewController()
        NotificationCenter.default.addObserver(self, selector: #selector(dropboxAuthorization(notification:)), name: .dropboxLogin, object: nil)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    @objc func dropboxAuthorization(notification: Notification) {
        if let info = notification.userInfo {
            if let _ = info["viewController"] as? UIViewController {
                let deadlineTime = DispatchTime.now() + .seconds(5)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    print("LOGIN TAPPED")
                    self.setupViewControllers()
                }
                // self.dropboxController.authorizeClient(viewController: viewController)
            }
        }
    }
    
    func setupRootViewController() {
        let navigationController = UINavigationController(rootViewController: LoginViewController())
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func setupViewControllers() {
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .label

        
        // Setup ClientsTableViewController
        let clientsTableViewController = GenericTableViewController(model: Model<Client>(), title: "Clients", configure: {
            (clientCell, client) in
            clientCell.configure(entityName: .client, value: client)
        }) { client in
            // Setup ProjectsTableViewController
            
            let projectsTableViewController = GenericTableViewController(model: Model<Project>(), title: "Projects", configure: { (projectCell, project) in
                projectCell.configure(entityName: .project, value: project)
            }) { project in
                // Setup JobsheetsTableViewController
                let jobsheetsTableViewController = GenericTableViewController(model: Model<JobSheet>(), title: project.name ?? "Jobsheet", configure: { (jobsheetCell, jobsheet) in
                    jobsheetCell.configure(entityName: .jobSheet, value: jobsheet)
                    }) { jobsheet in
                    print("JOBSHEET SELECTED: ", jobsheet.id)
                     // Setup ComponentsTableViewController
                        let componentsTableViewController = GenericTableViewController(model: Model<Component>(), title: "Components", configure: { (componentCell, component) in
                            print("COMPONENT: ", component)
                            
                        componentCell.configure(entityName: .component, value: component)
                            
                        }) { _ in
                            
                            
                        }
                        
                    navigationController.pushViewController(componentsTableViewController, animated: true)

                }
                navigationController.pushViewController(jobsheetsTableViewController, animated: true)
            }
            navigationController.pushViewController(projectsTableViewController, animated: true)
        }
        
        navigationController.viewControllers = [clientsTableViewController]
        clientsTableViewController.title = "Schematic Capture"
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if let authResult = DropboxClientsManager.handleRedirectURL(url) {
                switch authResult {
                case .success:
                    NSLog("Success! User is logged into Dropbox.")
                    setupViewControllers()
                case .cancel:
                    NSLog("Authorization flow was manually canceled by user!")
                case .error(_, let description):
                    NSLog("Error: \(description)")
                }
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}


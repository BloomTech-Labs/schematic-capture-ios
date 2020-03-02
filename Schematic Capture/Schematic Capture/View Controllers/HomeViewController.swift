//
//  HomeViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import WebKit
import SCLAlertView

class HomeViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var loginLabel: UILabel!
    
    var loginController: LogInController?
    var projectController = ProjectController()
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        if let url = Bundle.main.url(forResource: "Pulse-1s-200px", withExtension: "svg") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    
    @IBAction func downloadSchematics(_ sender: Any) {
        startLoadingScreen()
        projectController.downloadAssignedJobs { (error) in
            if let error = error {
                self.stopLoadingScreen()
                SCLAlertView().showError("Unable to download assigned jobs", subTitle: "\(error)")
                return
            }
            
            self.projectController.downloadSchematics { (error) in
                self.stopLoadingScreen()
                if let error = error {
                    SCLAlertView().showSuccess("Unable to download schematics", subTitle: "\(error)")
                    return
                }
                
                SCLAlertView().showSuccess("Download  Successful", subTitle: "")
            }
        }
    }
    
    
     

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectSegue" {
            if let projectsTableVC = segue.destination as? ProjectsTableViewController {
                projectsTableVC.loginController = loginController
                projectsTableVC.projectController = projectController
            }
        }
    }
    
    func startLoadingScreen() {
        guard let webView = webView else { return }
        
        DispatchQueue.main.async {
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.backgroundColor = .clear
            webView.isOpaque = false
            self.view.addSubview(webView)
            
            webView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
            webView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
            webView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            webView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -15).isActive = true
        }
    }
    
    func stopLoadingScreen() {
        guard let webView = webView else { return }
        
        DispatchQueue.main.async {
            webView.removeFromSuperview()
            self.webView = nil
        }
    }
    

}

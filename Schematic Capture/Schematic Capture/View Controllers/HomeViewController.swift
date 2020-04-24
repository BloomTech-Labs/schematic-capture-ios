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
import SwiftyDropbox

class HomeViewController: UIViewController, WKUIDelegate {

   @IBOutlet weak var downloadProjectsButton: UIButton!
    @IBOutlet weak var viewProjectsButton: UIButton!
    @IBOutlet weak var uploadJobSheetsButton: UIButton! // not implemented
    
    
    var loginController: LogInController?
    var projectController = ProjectController()
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       Style.styleFilledButton(downloadProjectsButton)
        Style.styleFilledButton(viewProjectsButton)
        Style.styleFilledButton(uploadJobSheetsButton)
        
        
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.uiDelegate = self
        if let url = Bundle.main.url(forResource: "Pulse-1s-200px", withExtension: "svg") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    
    
    @IBAction func uploadJobSheets(_ sender: Any) {
     DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                             controller: self,
                                                             openURL: { (url:URL) -> Void in UIApplication.shared.openURL(url)})
            }
                                                         
        
    
    @IBAction func downloadSchematics(_ sender: Any) {
        startLoadingScreen()
        
        projectController.downloadAssignedJobs { (error) in
            if let error = error {
                self.stopLoadingScreen()
                DispatchQueue.main.async {
                    SCLAlertView().showError("Unable to download assigned jobs", subTitle: "\(error)")
                }
                return
            }
           
            

            // adding these to stop download animation
            self.stopLoadingScreen()
            DispatchQueue.main.async {
                               SCLAlertView().showSuccess("Download  Successful", subTitle: "")
                           }
            
        }
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        guard let loginController = loginController else {
            return
        }
        loginController.signOut { (error) in
            if let error = error {
                print("\(error)")
                return
            }
            
            DispatchQueue.main.async {
                if self.presentingViewController != nil {
                    self.dismiss(animated: false, completion: {
                       self.navigationController!.popToRootViewController(animated: true)
                    })
                }
                else {
                    self.navigationController!.popToRootViewController(animated: true)
                }
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

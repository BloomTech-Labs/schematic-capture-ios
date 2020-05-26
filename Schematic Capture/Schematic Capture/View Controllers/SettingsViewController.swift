//
//  SettingsViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/26/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        self.title = "Settings"
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.id)
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.id) else { return UITableViewCell() }
        cell.textLabel?.text = "Log Out"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let logOut = UIAlertAction(title: "Log Out", style: .default) { (action) in
            UserDefaults.standard.removeObject(forKey: .token)
            let loginViewController = LoginViewController()
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(logOut)
        self.present(alert, animated: true, completion: nil)
    }
}

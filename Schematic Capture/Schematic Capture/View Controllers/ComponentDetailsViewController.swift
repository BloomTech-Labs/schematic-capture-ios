//
//  ComponentDetailsViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 21.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ComponentDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    var tableView: UITableView!
    var headerView = HeaderView()
    
    // MARK: - Properties
    
    var component: Component? {
        didSet {
            updateViews()
        }
    }
    
    var image: UIImage?
    
    var details = [String : String]()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    
    private func setupViews() {
        
        self.title = "Component \(component?.id ?? 0)"
        view.backgroundColor = .systemBackground
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.id)
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    func updateViews() {
        details = [
            "Description:" : component?.descriptions ?? "",
            "Manufacturer:" : component?.manufacturer ?? "",
            "Part #:" : component?.partNumber ?? "",
            "RL Category:" : component?.rlCategory ?? "",
            "RL Number:" : component?.rlNumber ?? "",
            "Stock Code:" : component?.stockCode ?? "",
            "Electrical Address:" : component?.electricalAddress ?? "",
            "Reference Tag:" : component?.referenceTag ?? "",
            "Settings:" : component?.settings ?? "",
            "Resources:" : component?.resources ?? "",
            "Cutsheet:" : component?.cutSheet ?? "",
            "Store's Part #:" : component?.storePartNumber ?? "",
            "Notes:" : component?.custom ?? "",
        ]
    }
    
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleComponentEditing() {
//        let viewController = ComponentViewController()
//        viewController.details = self.details
//        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ComponentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: 0, height: 0))
            label.sizeToFit()
            label.backgroundColor = .red
            label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label.text = "Information"
            return label
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var keys:[String] {
            get{
                return Array(details.keys)
            }
        }
        let key = keys[indexPath.row]
        let value = details[key]
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.id, for: indexPath) as! ImageTableViewCell
            cell.selectionStyle = .none
            cell.componentImageView.image = self.image
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.id, for: indexPath) as! TextFieldTableViewCell
            cell.updateViews(title: key, value: value)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

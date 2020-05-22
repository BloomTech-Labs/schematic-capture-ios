//
//  ComponentDetailsViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 21.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ComponentDetailsViewController: UIViewController {
    
    var tableView: UITableView!
    var headerView = HeaderView()
    
    var component: ComponentRepresentation? {
        didSet {
            headerView.setup(viewTypes: .componentDetails, value: [
                (component?.componentDescription ?? ""), "Details", ""
            ])
            details.append(component?.componentDescription ?? "")
            details.append(component?.manufacturer ?? "")
            details.append(component?.partNumber ?? "")
            details.append(component?.rlCategory ?? "")
            details.append(component?.rlNumber ?? "")
            details.append(component?.stockCode ?? "")
            details.append(component?.electricalAddress ?? "")
            details.append(component?.referenceTag ?? "")
            details.append(component?.settings ?? "")
            details.append(component?.resources ?? "")
            details.append(component?.cutSheet ?? "")
            details.append(component?.storePartNumber ?? "")
            details.append(component?.custom ?? "")
        }
    }
    
    var details = [String]()
    
    // Labels
    private func setupViews() {
        self.title = "Schematic Capture"
        view.backgroundColor = .systemBackground
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.register(GeneralTableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.addSubview(indicator)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
    }
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

extension ComponentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detail = details[indexPath.row]
        
        let cell = UITableViewCell()
        //cell.detailTextLabel?.text = detail
        
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Description:"
                cell.detailTextLabel?.text = detail
            case 1:
                cell.textLabel?.text = "Manufacturer:"
                cell.detailTextLabel?.text = detail
            case 2:
                cell.textLabel?.text = "Part #:"
                cell.detailTextLabel?.text = detail
            case 3:
                cell.textLabel?.text = "RL Category:"
                cell.detailTextLabel?.text = detail
            case 4:
                cell.textLabel?.text = "RL Number:"
                cell.detailTextLabel?.text = detail
            case 5:
                cell.textLabel?.text = "Stock Code:"
                cell.detailTextLabel?.text = detail
            case 6:
                cell.textLabel?.text = "Electrical Address:"
                cell.detailTextLabel?.text = detail
            case 7:
                cell.textLabel?.text = "Reference Tag:"
                cell.detailTextLabel?.text = detail
            case 8:
                cell.textLabel?.text = "Settings:"
                cell.detailTextLabel?.text = detail
            case 9:
                cell.textLabel?.text = "Resources"
                cell.detailTextLabel?.text = detail
            case 10:
                cell.textLabel?.text = "Cutsheet:"
                cell.detailTextLabel?.text = detail
            case 11:
                cell.textLabel?.text = "Store's Part #:"
                cell.detailTextLabel?.text = detail
            case 12:
                cell.textLabel?.text = "Notes:"
                cell.detailTextLabel?.text = detail
            default:
                cell.detailTextLabel?.text = detail
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = details[indexPath.row]
        let editCoponentDetailViewController = EditCoponentDetailViewController()
        editCoponentDetailViewController.value = detail
        navigationController?.pushViewController(editCoponentDetailViewController, animated: true)
    }
}

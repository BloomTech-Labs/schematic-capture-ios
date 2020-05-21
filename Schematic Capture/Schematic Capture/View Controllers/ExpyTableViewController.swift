//
//  ComponentsTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ComponentsTableViewController: UITableViewController {
    
    // MARK: - UI Elements
    
    var headerView = HeaderView()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    // MARK: - Propertiess
    
    var projectController: ProjectController?
    var token: String?
    var jobSheet: JobSheetRepresentation? {
        didSet {
            fetchComponents()
            guard let name = jobSheet?.name else { return }
            headerView.setup(viewTypes: .components, value: [name, "Components"])
        }
    }
    var components = [ComponentRepresentation]()
    var filteredComponents = [ComponentRepresentation]()
    
    var imagePicker: ImagePicker!

    
    //var pdfBarButtonItem: UIBarButtonItem!
    
    // MARK: - View Lifecycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        headerView.searchBar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchComponents()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        indicator.startAnimating()
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.addSubview(indicator)
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        headerView.searchDelegate = self
        tableView.tableHeaderView = headerView
        tableView?.register(ComponentTableViewCell.self, forCellReuseIdentifier: ComponentTableViewCell.id)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

    }
    
    // MARK: - Functions
    
    private func fetchComponents() {
        indicator.stopAnimating()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ComponentTableViewCell.id, for: indexPath) as? ComponentTableViewCell else { return UITableViewCell() }
        
//        let component = self.components[indexPath.row]
//        cell.updateViews(index: indexPath.row, component: component)
        cell.componentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let components = self.components[indexPath.row]
//        let expyTableViewViewController = ComponentsTableViewController()
//        expyTableViewViewController.projectController = projectController
//        expyTableViewViewController.jobSheet = jobSheet
//        expyTableViewViewController.token = token
        //navigationController?.pushViewController(expyTableViewViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    
    @objc func showImagePicker() {
        self.imagePicker.present(from: view)
    }
}

extension ComponentsTableViewController: SearchDelegate {
    func searchDidEnd(didChangeText: String) {
        //self.filteredComponents =  self.components.filter({($0.componentDescription .capitalized.contains(didChangeText.capitalized))}) else { return }
        tableView.reloadData()
    }
}


extension ComponentsTableViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            let annotationViewController = AnnotationViewController()
            let navigationController = UINavigationController(rootViewController: annotationViewController)
            annotationViewController.image = image
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}















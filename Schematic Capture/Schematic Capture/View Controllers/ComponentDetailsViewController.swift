//
//  ComponentDetailsViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 21.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox

extension String {
    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
}

class ComponentDetailsViewController: UITableViewController {
    
    // MARK: - UI Elements
    
    var headerView = HeaderView()
    var editButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    
    var rightBarButtonItems: [UIBarButtonItem] = []
    
    // MARK: - Properties
    
    var component: Component? {
        didSet {
            updateViews()
        }
    }
    
    var image: UIImage?
    
    var details = [String : String]()
    
    var dropboxController: DropboxController?
    
    var projectController: ProjectController?
    
    var imagePicker: ImagePicker!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    
    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        self.title = "Component \(component?.componentId ?? "")"
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.tableHeaderView = headerView
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.id)
        
        if image == nil {
            headerView.label.isHidden = true
            headerView.showButton(text: "Add an Image")
            headerView.secondaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
            headerView.button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        } else {
            headerView.imageView.image = self.image
            headerView.imageView.isUserInteractionEnabled = true
            headerView.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImageVC)))
        }
        
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        rightBarButtonItems = [editButton]
        navigationItem.rightBarButtonItems = rightBarButtonItems
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @objc func editTapped() {
        self.navigationItem.rightBarButtonItems = [saveButton]
        self.headerView.imageView.isHidden = true
        headerView.secondaryLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        headerView.button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        self.headerView.showButton(text: "Change Image")
        for cell in self.tableView.visibleCells {
            guard let cell = cell as? TextFieldTableViewCell else { return }
            cell.textField.isUserInteractionEnabled = true
        }
    }
    
    @objc func saveTapped() {
        self.navigationItem.addActivityIndicator()
        self.headerView.imageView.isHidden = false
        for cell in self.tableView.visibleCells {
            guard let cell = cell as? TextFieldTableViewCell else { return }
            cell.textField.isUserInteractionEnabled = false
            let values: [String: String] = [cell.label.text!: cell.textField.text ?? ""]
            for key in values.keys {
                if let value = values[key] {
                    let strimmedkey = key.filter { !$0.isWhitespace }.lowercasingFirst
                    component?.setValue(value, forKey: strimmedkey)
                    CoreDataStack.shared.save()
                }
            }
            
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItems = [self.editButton]
                self.showMessage("Details successfully saved.", type: .info)
            }
        }
    }
    
    @objc func showImageVC() {
        let imageViewController = UIViewController()
        let imageView = UIImageView()
        imageViewController.view.addSubview(imageView)
        imageView.frame = imageViewController.view.frame
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        navigationController?.pushViewController(imageViewController, animated: true)
    }
    
    func updateViews() {
        details = [
            "Descriptions" : component?.descriptions ?? "",
            "Manufacturer" : component?.manufacturer ?? "",
            "Part Number" : component?.partNumber ?? "",
            "Rl Category" : component?.rlCategory ?? "",
            "Rl Number" : component?.rlNumber ?? "",
            "Stock Code" : component?.stockCode ?? "",
            "Electrical Address" : component?.electricalAddress ?? "",
            "Reference Tag" : component?.referenceTag ?? "",
            "Settings" : component?.settings ?? "",
            "Resources" : component?.resources ?? "",
            "Cut Sheet" : component?.cutSheet ?? "",
            "Store Part Number" : component?.storePartNumber ?? "",
            "Custom" : component?.custom ?? "",
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
    
    @objc func showImagePicker() {
        self.imagePicker.present(from: self.view)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var keys:[String] {
            get {
                return Array(details.keys)
            }
        }
        let key = keys[indexPath.row]
        let value = details[key]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.id, for: indexPath) as! TextFieldTableViewCell
        cell.updateViews(title: key, value: value)
        cell.selectionStyle = .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - ImagePickerDelegate
extension ComponentDetailsViewController: ImagePickerDelegate {
    
    // Unannotated image
    func didSelect(image: UIImage?) {
        if image != nil {
            guard let imageData = image?.jpegData(compressionQuality: 1), let id = component?.id else { return }
            var path = dropboxController?.path
            path?.append("Normal")
            dropboxController?.updateDropbox(imageData: imageData, path: path!, imageName: "\(id)")
            let annotationViewController = AnnotationViewController()
            annotationViewController.delegate = self as ImageDoneEditingDelegate
            let navigationController = UINavigationController(rootViewController: annotationViewController)
            navigationController.modalPresentationStyle = .fullScreen
            annotationViewController.image = image
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}


// MARK: - ImageDoneEditingDelegate
extension ComponentDetailsViewController: ImageDoneEditingDelegate {
    
    // Annotated Image
    func ImageDoneEditing(image: UIImage?) {
        guard let imageData = image?.jpegData(compressionQuality: 1), let id = component?.id, var path = dropboxController?.path else { return }
        path.append("Annotated")
        DispatchQueue.global(qos: .background).async {
            self.dropboxController?.updateDropbox(imageData: imageData, path: path, imageName: "\(id)")
            DispatchQueue.main.async {
                self.component?.imageData = imageData
                self.headerView.imageView.isHidden = false 
                self.headerView.imageView.image = image
                CoreDataStack.shared.save()
                self.headerView.stackView.isHidden = true
                self.showMessage("Image successfully saved.", type: .info)
            }
        }
    }
}

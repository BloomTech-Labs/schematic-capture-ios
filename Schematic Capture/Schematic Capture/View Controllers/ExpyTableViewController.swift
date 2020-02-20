//
//  ExpyTableViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/17/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import ExpyTableView
import Photos
import SCLAlertView

class ExpyTableViewController: UIViewController {
    
    @IBOutlet weak var expandableTableView: ExpyTableView!
    
    var components: [Component]? {
        didSet {
            if !components!.isEmpty,
                let jobSheet = components![0].ownedJobSheet {
                navigationController?.title = jobSheet.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        expandableTableView.dataSource = self
        expandableTableView.delegate = self
        
        expandableTableView.rowHeight = UITableView.automaticDimension
        expandableTableView.estimatedRowHeight = 44
        
        expandableTableView.expandingAnimation = .fade
        expandableTableView.collapsingAnimation = .fade
        
        expandableTableView.tableFooterView = UIView()
        
        expandableTableView.reloadData()
    }
    
    private func checkPhotoAuthorization() {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    DispatchQueue.main.async {
                        SCLAlertView().showError("Error", subTitle: "In order to access the photo library, give permission to this application.")
                    }
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            DispatchQueue.main.async {
                SCLAlertView().showError("Error", subTitle: "In order to access the photo library, give permission to this application.")
            }
        case .restricted:
            DispatchQueue.main.async {
                SCLAlertView().showError("Error", subTitle: "Unable to access the photo library. Your device's restrictions do not allow access.")
            }
        @unknown default:
            fatalError("Unhandled case for photo library authorization status")
        }
        presentImagePickerController()
    }
    
    private func presentImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
}

extension ExpyTableViewController: ExpyTableViewDataSource, ExpyTableViewDelegate {
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return components?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentMainCell") as? ComponentMainTableViewCell else { return UITableViewCell() }
        
        cell.component = components?[section]
        cell.delegate = self
        cell.showSeparator()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentDetailCell") as? ComponentDetailTableViewCell else { return UITableViewCell() }
        cell.component = components?[indexPath.section]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ExpyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ExpyTableViewController: MainCellDelegate {
    func cameraButtonDidTabbed(component: Component) {
        checkPhotoAuthorization()
    }
}

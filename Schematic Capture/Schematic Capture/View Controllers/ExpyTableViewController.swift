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
import AVFoundation
import PencilKit

class ExpyTableViewController: UIViewController {
    @IBOutlet weak var pdfBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var expandableTableView: ExpyTableView!
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        guard let _ = selectedComponent,
            let _ = currentComponentPhoto else {return}
       
        performSegue(withIdentifier: "ShowComponentDetailImageSegue", sender: self)
        
    }
    
    
    @IBAction func editComponentButtonTapped(_ sender: Any) {
        guard let _ = selectedComponent else { print("No component on line 31, editComponentButtonTapped Exypy") ; return}
        
        performSegue(withIdentifier:"EditComponentSegue", sender:self)
    }
    
    
    var components: [Component]? {
        didSet {
            if !components!.isEmpty,
                let jobSheet = components![0].ownedJobSheet {
                navigationController?.title = jobSheet.name
            }
        }
    }
    
    var schematicData: Data?
    var selectedComponent: Component?
    var originalPhoto: UIImage?
    var currentComponentPhoto:UIImage? //+++
    var delegate: MainCellDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expandableTableView.reloadData()
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
        
        navigationItem.rightBarButtonItems = [pdfBarButtonItem]
        
        

    }
    
   
    

    
    
    
 
    
    private func checkAuthAndPresentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if sourceType == .photoLibrary {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
            
            switch authorizationStatus {
            case .authorized:
                presentImagePickerController(sourceType: sourceType)
            case .notDetermined:
                
                PHPhotoLibrary.requestAuthorization { (status) in
                    
                    guard status == .authorized else {
                        NSLog("User did not authorize access to the photo library")
                        DispatchQueue.main.async {
                            SCLAlertView().showError("Error", subTitle: "In order to access the photo library, give permission to this application.")
                        }
                        return
                    }
                    
                    self.presentImagePickerController(sourceType: sourceType)
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
        } else if sourceType == .camera {
            
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch authorizationStatus {
            case .authorized:
                presentImagePickerController(sourceType: sourceType)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (granted) in
                    if granted {
                        self.presentImagePickerController(sourceType: sourceType)
                    } else {
                        NSLog("User did not authorize access to the camera")
                        DispatchQueue.main.async {
                            SCLAlertView().showError("Error", subTitle: "In order to access the camera, give permission to this application.")
                        }
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                        SCLAlertView().showError("Error", subTitle: "In order to access the camera, give permission to this application.")
                    }
            case .restricted:
                    DispatchQueue.main.async {
                        SCLAlertView().showError("Error", subTitle: "Unable to access the camera. Your device's restrictions do not allow access.")
                    }
            @unknown default:
                fatalError("Unhandled case for camera authorization status")
            }
        }
    }
    
    private func presentImagePickerController(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = sourceType
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CanvasSegue" {
            if let annotationVC = segue.destination as? AnnotationViewController {
                guard let component = selectedComponent,
                    let originalPhoto = originalPhoto else { return }
                annotationVC.originalPhoto = originalPhoto
                annotationVC.component = component
            }
        } else if segue.identifier == "SchematicViewSegue" {
            if let schematicVC = segue.destination as? SchematicViewController {
                guard let shematicData = schematicData else { return }
                schematicVC.pdfData = shematicData
            }
        }
        
       else if segue.identifier == "ShowComponentDetailImageSegue" {
            if let detailVC = segue.destination as? ComponentDetailImageViewController {
             detailVC.delegate = self
                guard let _ = selectedComponent else { print("no component selected returning"); return }
               
              
              guard let selectedImage = currentComponentPhoto else { print("No currentComponentPhoto image returning"); return}
                 
                detailVC.passedInImage = selectedImage
                            
                    
                selectedComponent = nil
                currentComponentPhoto = nil

                  
              
                 }
            }
        
        else if segue.identifier == "EditComponentSegue" {
            if let detailVC = segue.destination as? EditComponentViewController {
                detailVC.delegate = self
                  guard let componentToEdit = selectedComponent else { print("no component selected returning"); return }
                
                detailVC.component = componentToEdit
                
                selectedComponent = nil
                
            }
        }


        }
        
       
    
    
    @IBAction func pdfTabbed(_ sender: Any) {
        guard schematicData != nil else {
            DispatchQueue.main.async {
                SCLAlertView().showError("Error", subTitle: "No schematic data found.")
            }
            return
        }
        
        // Segue to PDF view
        performSegue(withIdentifier: "SchematicViewSegue", sender: self)
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
        return 2 //likely refers to 2 cells. ComponentMainTableViewCell, ComponentDetailTableViewCell - TC
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentMainCell") as? ComponentMainTableViewCell else { return UITableViewCell() }
        

      


        
        cell.component = components?[section] // assigns first component to first section in TV - TC
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
        
        let saveImageToAlbum = picker.sourceType == .camera
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        originalPhoto = image
        
        // Present annotation view
        performSegue(withIdentifier: "CanvasSegue", sender: self)
        
        if saveImageToAlbum {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // If error occured while saving the original copy of the photo, present alert
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            SCLAlertView().showError("Could not save the photo!", subTitle: error.localizedDescription)
        }
    }
}

extension ExpyTableViewController: MainCellDelegate {
    func saveComponentEditsTapped() {
        self.expandableTableView.reloadData()
    }
    
 
    
  
    func viewImageButtonDidTapped(component:Component,selectedImage:UIImage? ){
        selectedComponent = component
        currentComponentPhoto = selectedImage
        
        
        guard let _ = selectedComponent else {return}
        guard   let  _ = selectedImage else {return}
        
    
            
       
        

            performSegue(withIdentifier: "ShowComponentDetailImageSegue", sender: self)
         }
        
        func cameraButtonDidTapped(component: Component) {
            selectedComponent = component
            DispatchQueue.main.async {
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alert = SCLAlertView(appearance: appearance)
                alert.addButton("Camera") {
                    self.checkAuthAndPresentImagePicker(sourceType: .camera)
                }
                alert.addButton("Photo Library") {
                    self.checkAuthAndPresentImagePicker(sourceType: .photoLibrary)
                }
                alert.addButton("Cancel") {
                    alert.hideView()
                }
                alert.showNotice("Image Source", subTitle: "")
                
            }
        }
    
    func editComponentButtonTapped(component: Component) {
        selectedComponent = component
        
        guard let _ = selectedComponent else {return}
        performSegue(withIdentifier: "EditComponentSegue", sender: self)
              }
    
    
    }
     

        
        
        
        
    
    
    

    





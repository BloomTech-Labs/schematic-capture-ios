//
//  CameraViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/19/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerController()
    }
    
    func setupPickerController() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .camera
    }
}

extension CameraViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
}

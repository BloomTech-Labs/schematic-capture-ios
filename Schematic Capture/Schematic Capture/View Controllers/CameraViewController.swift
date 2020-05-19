//
//  CameraViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/19/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    var imagePicker: ImagePicker!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: view)
    }
}

extension CameraViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        print("IMAGE SIZES: \(image?.size)")
    }
}

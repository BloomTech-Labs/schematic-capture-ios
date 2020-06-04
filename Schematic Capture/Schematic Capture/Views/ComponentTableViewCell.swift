//
//  ComponentTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/19/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyDropbox

protocol SelectedCellDelegate: NSObject {
    func selectedCell(cell: ComponentTableViewCell)
}

class ComponentTableViewCell: UITableViewCell {
    
    var indexLabel = UILabel()
    var nameLabel = UILabel()
    var componentImageView = UIImageView()
    var viewController: UIViewController?
    
    var dropboxController: DropboxController?
    var imagePicker: ImagePicker!
    
    weak var delegate: SelectedCellDelegate?
    
    var userPath: [String]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        indexLabel.text = "1"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Electric motor"
        
        componentImageView.translatesAutoresizingMaskIntoConstraints = false
        componentImageView.contentMode = .scaleAspectFill
        componentImageView.clipsToBounds = true
        componentImageView.image = UIImage(systemName: "camera")
        componentImageView.isUserInteractionEnabled = true
        
        componentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        
        addSubview(indexLabel)
        addSubview(nameLabel)
        addSubview(componentImageView)
        
        NSLayoutConstraint.activate([
            indexLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            indexLabel.heightAnchor.constraint(equalTo: heightAnchor),
            nameLabel.leftAnchor.constraint(equalTo: indexLabel.rightAnchor, constant: 16.0),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor),
            
            componentImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            componentImageView.heightAnchor.constraint(equalToConstant: 32.0),
            componentImageView.widthAnchor.constraint(equalToConstant: 32.0),
            componentImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLabel.rightAnchor.constraint(equalTo: componentImageView.leftAnchor, constant: -8.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Do we need index?
    func updateViews(component: ComponentRepresentation) {
        print("COMPONENT:", component)
        indexLabel.text = "\(component.id)"
        nameLabel.text = component.descriptions
        guard let imageData = component.imageData else { return }
        componentImageView.image = UIImage(data: imageData)
    }
    
    @objc func imageViewTapped(sender: UIImageView) {
        delegate?.selectedCell(cell: self)
    }
}

// MARK: - ImagePickerDelegate

extension ComponentTableViewCell: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil {
            let annotationViewController = AnnotationViewController()
            annotationViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: annotationViewController)
            navigationController.modalPresentationStyle = .fullScreen
            annotationViewController.image = image
            self.viewController?.present(navigationController, animated: true, completion: nil)
        }
    }
}

// MARK: - ImageDoneEditingDelegate

extension ComponentTableViewCell: ImageDoneEditingDelegate {
    
    func ImageDoneEditing(image: UIImage?) {
        self.componentImageView.image = image
    }
}

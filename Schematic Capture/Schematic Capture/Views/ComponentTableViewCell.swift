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

class ComponentTableViewCell: UITableViewCell {
    
    var indexLabel = UILabel()
    var nameLabel = UILabel()
    var columnALabel = UILabel()
    var columnELabel = UILabel()
    var columnFLabel = UILabel()
    var view = UIView()
    var componentImageView = UIImageView()
    
    var viewController: UIViewController?
    var selecteImageViewAction: ((Any) -> Void)?
    
    var dropboxController: DropboxController?
    var imagePicker: ImagePicker!
    
    weak var delegate: SelectedCellDelegate?
    
    var userPath: [String]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        columnALabel.font = .systemFont(ofSize: 12)
        columnELabel.font = .systemFont(ofSize: 12)
        columnFLabel.font = .systemFont(ofSize: 12)
        
        let views = [columnALabel, columnELabel, columnFLabel]
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 4
        addSubview(stackView)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        componentImageView.translatesAutoresizingMaskIntoConstraints = false
        componentImageView.contentMode = .scaleAspectFit
        componentImageView.clipsToBounds = true
        
        componentImageView.image = UIImage(systemName: "camera")
        
        view.addSubview(componentImageView)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTapped)))
                
        addSubview(view)
        addSubview(indexLabel)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            
            indexLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            indexLabel.heightAnchor.constraint(equalTo: heightAnchor),
            indexLabel.widthAnchor.constraint(equalToConstant: 50),
            
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -40),
            view.heightAnchor.constraint(equalToConstant: 80),
            view.widthAnchor.constraint(equalTo:  view.heightAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            componentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            componentImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            componentImageView.widthAnchor.constraint(equalToConstant: 50),
            componentImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.rightAnchor.constraint(equalTo: componentImageView.leftAnchor, constant: -8),
            nameLabel.leftAnchor.constraint(equalTo: indexLabel.rightAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            stackView.leftAnchor.constraint(equalTo: indexLabel.rightAnchor),
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleImageTapped(sender: UIView) {
        self.selecteImageViewAction?(self)
    }
    
    func updateViews(component: Component) {
        indexLabel.text = "\(component.componentId ?? "-")."
        nameLabel.text = component.descriptions
        columnALabel.text = "Component #: \(component.componentId ?? "-")"
        columnELabel.text = "Manufacturer: \(component.manufacturer ?? "-")"
        columnFLabel.text = "Part #: \(component.partNumber ?? "-")"
        if let imageData = component.imageData {
            componentImageView.contentMode = .scaleAspectFill
            componentImageView.image = UIImage(data: imageData)
        }
    }
}

// MARK: - ImagePickerDelegate

//extension ComponentTableViewCell: ImagePickerDelegate {
//
//    func didSelect(image: UIImage?) {
//        if image != nil {
//            let annotationViewController = AnnotationViewController()
//            annotationViewController.delegate = self
//            let navigationController = UINavigationController(rootViewController: annotationViewController)
//            navigationController.modalPresentationStyle = .fullScreen
//            annotationViewController.image = image
//            self.viewController?.present(navigationController, animated: true, completion: nil)
//        }
//    }
//}
//
//// MARK: - ImageDoneEditingDelegate
//
//extension ComponentTableViewCell: ImageDoneEditingDelegate {
//
//    func ImageDoneEditing(image: UIImage?) {
//        self.componentImageView.image = image
//    }
//}

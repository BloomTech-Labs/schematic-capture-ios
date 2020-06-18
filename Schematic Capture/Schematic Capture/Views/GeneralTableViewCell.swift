//
//  GeneralTableViewCell.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/12/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SDWebImage

protocol SelectedCellDelegate: NSObject {
    func selectedCell(cell: GeneralTableViewCell)
}

class GeneralTableViewCell: UITableViewCell {
    
    var stackView = UIStackView()
    var firstLabel = UILabel()
    var secondLabel = UILabel()
    var thirdLabel = UILabel()
    var fourthLabel = UILabel()
    var regularImageView = UIImageView()
    var indexLabel = UILabel()
    var views = [UIView]()
    
    var imagePicker: ImagePicker!
    weak var delegate: SelectedCellDelegate?
    
    var viewController: UIViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        indexLabel.textColor = .label
        indexLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        firstLabel.textColor = .label
        firstLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        firstLabel.translatesAutoresizingMaskIntoConstraints = false

        let regularFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        secondLabel.textColor = .label
        secondLabel.font = regularFont
        secondLabel.textAlignment = .center
        
        thirdLabel.textColor = .label
        thirdLabel.font = regularFont
        
        fourthLabel.textColor = .label
        fourthLabel.font = regularFont
        fourthLabel.textAlignment = .right
        fourthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        regularImageView.contentMode = .scaleAspectFit
        
        regularImageView.image = UIImage(systemName: "envelope")
        regularImageView.translatesAutoresizingMaskIntoConstraints = false
        
        views = [firstLabel, secondLabel, thirdLabel, fourthLabel, regularImageView]
        
        stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        addSubview(stackView)

    
        regularImageView.image = UIImage(systemName: "camera")
        regularImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped)))
        regularImageView.isUserInteractionEnabled = true
        
        views = [indexLabel, firstLabel, secondLabel, thirdLabel, fourthLabel, regularImageView]
        
        stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            indexLabel.widthAnchor.constraint(equalToConstant: 20),
            firstLabel.widthAnchor.constraint(equalToConstant: 96),
            
            regularImageView.heightAnchor.constraint(equalToConstant: 40),
            regularImageView.widthAnchor.constraint(equalToConstant: 40),
            regularImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -40.0),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(entityName: EntityNames, value: Any) {
       switch entityName {
         case .client:
           guard let client = value as? Client else { return }
           firstLabel.text = client.companyName
           fourthLabel.text = "\(client.projects!.count) projects"
           regularImageView.isHidden = true
           indexLabel.isHidden = true
         case .project:
           guard let project = value as? Project else { return }
           firstLabel.textColor = .systemBlue
           firstLabel.text = project.name
           if project.completed == true {
             secondLabel.text = "Completed"
           } else {
             secondLabel.text = "Incompleted"
           }
           thirdLabel.text = "Kerby Jeanjeanje"
           fourthLabel.text = "6/3/2020"
           regularImageView.isHidden = true
           indexLabel.isHidden = true
         case .jobSheet:
           guard let jobsheet = value as? JobSheet else { return }
           firstLabel.textColor = .systemBlue
           firstLabel.text = jobsheet.name
           secondLabel.text = "Kerby Jeanjeanje"
           thirdLabel.text = "Speed control"
           fourthLabel.text = "15"
           regularImageView.isHidden = true
           indexLabel.isHidden = true
         case .component:
           guard let component = value as? Component else { return }
           print("PROJECT IS BEING CONFIGURE: ", component.componentApplication ?? "")
           indexLabel.text = String(component.id)
           firstLabel.textColor = .systemBlue
           firstLabel.text = component.descriptions
           secondLabel.text = "15"
           thirdLabel.text = "Speed control"
           regularImageView.isHidden = false
       }
    }
    
    @objc func imageViewTapped(sender: UIImageView) {
        delegate?.selectedCell(cell: self)
    }
}

// MARK: - ImagePickerDelegate
extension GeneralTableViewCell: ImagePickerDelegate {
    
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
extension GeneralTableViewCell: ImageDoneEditingDelegate {
    
    func ImageDoneEditing(image: UIImage?) {
        self.regularImageView.image = image
    }
}

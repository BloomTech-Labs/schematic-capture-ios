//
//  ComponentMainTableViewCell.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/18/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import ExpyTableView

protocol MainCellDelegate {
    func cameraButtonDidTapped(component: Component)
    
    func viewImageButtonDidTapped(component:Component, selectedImage:UIImage?)
    
    func editComponentButtonTapped(component:Component)
    
    func saveComponentEditsTapped()
    
    
    

    
}
          
      
    


class ComponentMainTableViewCell: UITableViewCell, ExpyTableViewHeaderCell{
    var delegate: MainCellDelegate?
    var component: Component? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var componentIdLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var partNumberLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var annotatedImageView: UIImageView!
    
    @IBOutlet weak var viewImageButton: UIButton!
    
    
    @IBAction func viewImageButtonTapped(_ sender: Any) {
       
        guard let image = annotatedImageView.image,
        let component = component else {return}

            
    
            delegate?.viewImageButtonDidTapped(component:component, selectedImage: image)
      
    }
    
    
    @IBAction func editComponentButtonTapped(_ sender: Any) {
     guard  let component = component else {return}
        delegate?.editComponentButtonTapped(component: component)
    }
    
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func cameraButtonTabbed(_ sender: Any) {
        guard let component = component else { return }
        delegate?.cameraButtonDidTapped(component: component)
    }
    
   
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        switch state {
        case .willExpand:
            arrowDown(animated: !cellReuse)
            break
        case .willCollapse:
            arrowRight(animated: !cellReuse)
            break
        case .didExpand:
            break
        case .didCollapse:
            showSeparator()
            break
        }
    }
    
    private func updateViews() {
        guard let component = component else { return }
        
        componentIdLabel.text = "\(component.componentId ?? "")"
        descriptionLabel.text = "Description: \(component.componentDescription ?? "")"
        manufacturerLabel.text = "Manufacturer: \(component.manufacturer ?? "")"
        partNumberLabel.text = "Part #: \(component.partNumber ?? "")"
        
        guard let photo = component.photo,
            let imageData = photo.imageData,
            let image = UIImage(data: imageData) else {
                annotatedImageView.image = nil
                return
        }
        annotatedImageView.image = image
        
      
         
        
    }
    
 
    
    private func arrowDown(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
        }
    }
    
    private func arrowRight(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
        }
    }

}


extension UITableViewCell {

    func showSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func hideSeparator() {
        DispatchQueue.main.async {
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        }
    }
}


//
//  ComponentDetailImageViewController.swift
//  Schematic Capture
//
//  Created by Lambda_School_Loaner_219 on 3/20/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ComponentDetailImageViewController: UIViewController {
    var component:Component?
    var delegate: MainCellDelegate?
    var passedInImage:UIImage?
    
    @IBOutlet weak var componentDetailImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentDetailImageView?.image = passedInImage
        
     


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ComponentDetailImageViewController: MainCellDelegate {
    func saveComponentEditsTapped() {
        
    }
    
    func editComponentButtonTapped(component: Component) {
        
    }
    
    func cameraButtonDidTapped(component: Component) {
        
    }
    
    func viewImageButtonDidTapped(component: Component, selectedImage: UIImage?) {
        
        guard let selectedImage = selectedImage else {return}
            componentDetailImageView?.image = selectedImage
                
        }
        
    }
    
    



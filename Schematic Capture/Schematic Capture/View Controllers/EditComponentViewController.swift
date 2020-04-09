//
//  EditComponentViewController.swift
//  Schematic Capture
//
//  Created by Lambda_School_Loaner_219 on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class EditComponentViewController: UIViewController {
    var component:Component?
    
     var delegate: MainCellDelegate?
    
   
    @IBOutlet weak var currentComponentDescription: UILabel!
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        component = nil
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if component != nil {
            currentComponentDescription.text? = component?.componentDescription ?? "Can not display description"
        }

        // Do any additional setup after loading the view.
    }
    

        
   
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



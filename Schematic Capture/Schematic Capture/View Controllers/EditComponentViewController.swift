//
//  EditComponentViewController.swift
//  Schematic Capture
//
//  Created by Lambda_School_Loaner_219 on 4/9/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData 

class EditComponentViewController: UIViewController {
    var component:Component?
    
     var delegate: MainCellDelegate?
    var context = CoreDataStack.shared.mainContext
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var currentComponentDescription: UILabel!
    
    
    @IBOutlet weak var editDescriptionTextField: UITextField!
    
    @IBOutlet weak var ManufacturerTextField: UITextField!
    
    @IBOutlet weak var PartNumberTextField: UITextField!
    
    
    @IBOutlet weak var RLCategoryTextField: UITextField!
    
    @IBOutlet weak var RLNumberTextField: UITextField!
    
    
    @IBOutlet weak var StockCodeTextField: UITextField!
    
    
    @IBOutlet weak var ElectricalAddressTextField: UITextField!
    
    
    @IBOutlet weak var ComponentApplicationTextField: UITextField!
    
    
    @IBOutlet weak var ReferenceTagTextField: UITextField!
    
    @IBOutlet weak var SettingsTextField: UITextField!
    
  
    @IBOutlet weak var ResourcesTextField: UITextField!
    
    
    @IBOutlet weak var CutSheetTextField: UITextField!
    
    
    
    @IBOutlet weak var MaintenanceVideoTextField: UITextField!
    
    
    @IBOutlet weak var StorePartNumberTextField: UITextField!
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        component = nil
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newDescription = editDescriptionTextField.text
        if !newDescription!.isEmpty {
        component?.setValue(newDescription, forKey: "componentDescription")
        }
        
        let newManufacturer = ManufacturerTextField.text
        if !newManufacturer!.isEmpty {
            component?.setValue(newManufacturer, forKey: "manufacturer")
        }
        
        let newPartNumber = PartNumberTextField.text
        if !newPartNumber!.isEmpty {
            component?.setValue(newPartNumber, forKey: "partNumber")
        }
        
        let newStockCode = StockCodeTextField.text
        if !newStockCode!.isEmpty {
            component?.setValue(newStockCode, forKey: "stockCode")
        }
        
        let newElectricalAddress = ElectricalAddressTextField.text
        if !newElectricalAddress!.isEmpty {
            component?.setValue(newElectricalAddress, forKey: "electricalAddress")
        }
        
        let newApplication = ComponentApplicationTextField.text
        if !newApplication!.isEmpty {
            component?.setValue(newApplication, forKey: "componentApplication")
        }
        
        let newRefTag = ReferenceTagTextField.text
        if !newRefTag!.isEmpty {
            component?.setValue(newRefTag, forKey: "referenceTag")
        }
        
        let newSettings = SettingsTextField.text
        if !newSettings!.isEmpty {
            component?.setValue(newSettings, forKey: "settings")
        }
        
        let newResources = ResourcesTextField.text
        if !newResources!.isEmpty {
            component?.setValue(newResources, forKey: "resources")
        }
        
        let newCutSheet = CutSheetTextField.text
        if !newCutSheet!.isEmpty {
            component?.setValue(newCutSheet, forKey: "cutSheet")
        }
        
        let newMaintenanceVideo = MaintenanceVideoTextField.text
        if !newMaintenanceVideo!.isEmpty {
            component?.setValue(newMaintenanceVideo, forKey: "maintenanceVideo")
        }
        
        let newStorePartNumber = StorePartNumberTextField.text
        if !newStorePartNumber!.isEmpty {
            component?.setValue(newStorePartNumber, forKey: "storePartNumber")
        }
        
        let newRL = RLCategoryTextField.text
        if !newRL!.isEmpty {
            component?.setValue(newRL, forKey: "rlCategory")
        }
        
        let newRLNumber = RLNumberTextField.text
        if !newRLNumber!.isEmpty {
            component?.setValue(newRLNumber, forKey: "rlNumber")
        }
        
        CoreDataStack.shared.save(context: context)
        
        delegate?.saveComponentEditsTapped()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        component = nil
        
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if component != nil {
//            currentComponentDescription.text? = component?.componentDescription ?? "Can not display description"
            
            currentComponentDescription.text? = component?.value(forKey: "componentDescription") as? String ?? "Can not display description"
            
       
        }

        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        Style.styleFilledButton(saveButton)
        Style.styleFilledButton(dismissButton)
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



//
//  SchematicViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 18.06.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class SchematicViewController: UIViewController {
    
    let imageView = UIImageView()
    var jobSheet: JobSheet? {
        didSet {
            self.setUpViews()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        
        guard let jobSheet = jobSheet else { return }
        
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        
        
       
        if let imageString = jobSheet.schematic {
            
            print("IMAGEDATA CELL:", imageString)

                
                DispatchQueue.main.async {
                    
                    let imageData = try? Data(contentsOf: URL(string: "https://images.app.goo.gl/TyoH7zPQu28smGpS8")!)
                    
                    self.imageView.image = UIImage(data: imageData!)
                    self.imageView.backgroundColor = .blue
                    
                    print("IMAGEDATA", imageData)
                    
                    
                }
 
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
    
}

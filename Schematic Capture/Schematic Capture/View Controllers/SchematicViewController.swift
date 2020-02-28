//
//  SchematicViewController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 2/24/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import PDFKit

class SchematicViewController: UIViewController {
    
    var pdfData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add PDFView to view controller
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        // Fit content in PDFView
        pdfView.autoScales = true
        
        guard let pdfData = pdfData else { return }
        // Load schematics
        pdfView.document = PDFDocument(data: pdfData)
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

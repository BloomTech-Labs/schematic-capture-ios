//
//  SchematicViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/19/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import WebKit

class SchematicViewController: UIViewController {
    
    let imageView = WKWebView()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    
    var jobSheet: JobSheet? {
        didSet {
            self.setUpViews()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Schematic"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        view.addSubview(imageView)
        
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        indicator.startAnimating()
        
        view.addSubview(indicator)
    }
    
    @objc func handleDone() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func setUpViews() {
        
        //    guard let jobSheet = jobSheet else { return }
        
        self.indicator.stopAnimating()
        
        let request = URLRequest(url: URL(string: "https://www.dropbox.com/home/AlloyTest?preview=cnc-machine-component-250x250.jpg")!)
        DispatchQueue.main.async {
            self.imageView.load(request)

        }
        //
        //    if let imageString = jobSheet.schematic {
        //      print("IMAGEDATA CELL:", imageString)
        //
        //      let url = URL(string: "https://images.app.goo.gl/TyoH7zPQu28smGpS8")
        //    }
    }
}

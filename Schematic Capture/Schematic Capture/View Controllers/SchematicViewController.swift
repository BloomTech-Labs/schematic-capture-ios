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
    
    let webView = WKWebView()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    var schematicLink: String? {
        didSet {
            self.setUpViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.title = "Schematic"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        view.addSubview(webView)
        
        webView.frame = view.frame
        webView.contentMode = .scaleAspectFill
        webView.clipsToBounds = true
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        indicator.startAnimating()
        
        view.addSubview(indicator)
    }
    
    @objc func handleDone() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func setUpViews() {
        self.indicator.stopAnimating()

        let request = URLRequest(url: URL(string: self.schematicLink!)!)
        DispatchQueue.main.async {
            self.webView.load(request)
        }
    }
}

//
//  AnnotationView.swift
//  
//
//  Created by Ufuk Türközü on 20.05.20.
//

import UIKit

class AnnotationView: UIView {
    
    
    var shape: Shapes? {
        didSet {
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .darkGray
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}





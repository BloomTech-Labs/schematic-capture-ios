//
//  UIView+String.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 15.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit 

extension UIView {
    static var id: String {
        return String(describing: self)
    }
}

//
//  DropboxController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 5/26/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import SwiftyDropbox

class DropboxController {
    
    var client: DropboxClient? {
        return DropboxClientsManager.authorizedClient
    }
    
    func authorizeClient(viewController: UIViewController) {
        DropboxClientsManager.authorizeFromController(
            UIApplication.shared, controller: viewController, openURL: { (url: URL) -> Void in
        })
    }
}

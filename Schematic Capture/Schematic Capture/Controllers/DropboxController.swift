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
        guard client != nil else { return }
        DropboxClientsManager.authorizeFromController(
            UIApplication.shared, controller: viewController, openURL: { (url: URL) -> Void in
        })
    }
    
    typealias Completion = (Result<[Any], NetworkingError>) -> ()

    
    func getImage(imageName: String, completion: @escaping (UIImage, NetworkingError) -> ()) {
        // Get Image from dropbox
        
        
    }
}

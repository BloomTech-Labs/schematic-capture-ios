//
//  AppDelegate.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/23/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import SwiftyDropbox
import OktaOidc

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropboxClientsManager.setupWithAppKey("t5i27y2t3fzkiqj")
        return true
    }
    
    func configureOkta() {
        
        let configuration = try? OktaOidcConfig(with: [
            "issuer": "https://$com.okta.dev-833124/oauth2/default",
            "clientId": "0oac57x5hNOP4Qb0C4x6",
            "redirectUri": "com.okta.dev-833124:/",
            "scopes": "openid profile offline_access"
        ])
        
        let oktaOidc = try? OktaOidc(configuration: configuration)

    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


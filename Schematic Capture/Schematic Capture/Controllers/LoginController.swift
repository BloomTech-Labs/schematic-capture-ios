//  LoginController.swift
//  Schematic Capture
//
//  Created by Gi Pyo Kim on 1/28/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import OktaAuthSdk


class LogInController {
    
    let defaults = UserDefaults.standard
    var bearer: Bearer?
    var user: User?

    typealias Completion = () -> Void

    private var url = URL(string: "https://dev-833124-admin.okta.com/")!
    
    //MARK: AuthenticateUser
    
    func AuthenticateUser(username: String, password: String, completion: Completion) {
        OktaAuthSdk.authenticate(with: url, username: username, password: password, onStatusChange: { authStatus in
            let status = self.handleStatus(status: authStatus)
            print("STATUS: \(status!)")
        }) { error in
            NSLog("Error authenticating user: \(error)")
        }
    }
    
    
    // Handle status
    /*Handle current status in order to proceed with the initiated flow*/
    func handleStatus(status: OktaAuthStatus) -> OktaAuthStatus? {

        switch status.statusType {
        case .success:
            let successState: OktaAuthStatusSuccess = status as! OktaAuthStatusSuccess
            return successState
        case .passwordWarning:
            let warningPasswordStatus: OktaAuthStatusPasswordWarning = status as! OktaAuthStatusPasswordWarning
            return warningPasswordStatus
        case .passwordExpired:
            let expiredPasswordStatus: OktaAuthStatusPasswordExpired = status as! OktaAuthStatusPasswordExpired
            return expiredPasswordStatus
        case .MFAEnroll:
            let mfaEnroll: OktaAuthStatusFactorEnroll = status as! OktaAuthStatusFactorEnroll
            return mfaEnroll
        case .MFAEnrollActivate:
            let mfaEnrollActivate: OktaAuthStatusFactorEnrollActivate = status as! OktaAuthStatusFactorEnrollActivate
            return mfaEnrollActivate
        case .MFARequired:
            let mfaRequired: OktaAuthStatusFactorRequired = status as! OktaAuthStatusFactorRequired
            return mfaRequired
        case .MFAChallenge:
            let mfaChallenge: OktaAuthStatusFactorChallenge = status as! OktaAuthStatusFactorChallenge
            return mfaChallenge
        case .recovery:
            let recovery: OktaAuthStatusRecovery = status as! OktaAuthStatusRecovery
            return recovery
        case .recoveryChallenge:
            let recoveyChallengeStatus: OktaAuthStatusRecoveryChallenge = status as! OktaAuthStatusRecoveryChallenge
            return recoveyChallengeStatus
        case .passwordReset:
            let passwordResetStatus: OktaAuthStatusPasswordReset = status as! OktaAuthStatusPasswordReset
            return passwordResetStatus
        case .lockedOut:
            let lockedOutStatus: OktaAuthStatusLockedOut = status as! OktaAuthStatusLockedOut
            return lockedOutStatus
        case .unauthenticated:
            let unauthenticatedStatus: OktaAuthStatusUnauthenticated = status as! OktaAuthStatusUnauthenticated
            return unauthenticatedStatus
        case .unknown(_):
            break
        }
        return nil
    }
    
    //
//    // Proceed to HomeViewController
//    
//    //MARK:Sign-Out to refactor
//    func signOut(completion: @escaping (Error?) -> Void) {
//        do {
//            //try //Auth.auth().signOut()
//        } catch {
//            print("Error signing out: \(error)")
//            completion(error)
//            return
//        }
//        completion(nil)
//    }
//    
//    //MARK: - Update User
//    private func updateUser(user: User) {
//        guard let firstName = user.firstName,
//            let lastName = user.lastName,
//            let role = user.role else { return }
//        
//        do {
//            
//            let roleData = try JSONEncoder().encode(role)
//            
//            defaults.set(roleData, forKey: "roleJSONData")
//            defaults.set(firstName, forKey: "firstName")
//            defaults.set(lastName, forKey: "lastName")
//        } catch {
//            print("\(error)")
//            return
//        }
//    }
    
}

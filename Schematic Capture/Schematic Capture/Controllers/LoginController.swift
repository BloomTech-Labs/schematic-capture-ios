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
    
    typealias Completion = (Result<Any, Error>) -> ()
    
    // AuthenticateUser
    /*Authenticate user with username and password. Save user Id to UserDefaults */
    func authenticateUser(username: String, password: String, completion: @escaping Completion) {
        OktaAuthSdk.authenticate(with:URL(string: OktaUrls.baseUrl.rawValue)!, username: username, password: password, onStatusChange: { authStatus in
            if let status = self.handleStatus(status: authStatus), let user = status.user {
                self.defaults.set(user.id, forKey: .userId)
                completion(.success(user))
            }
        }) { error in
            NSLog("Error authenticating user: \(error)")
            completion(.failure(error))
        }
    }
    
    
    // Password recovery
    /*Starts a new password recovery transaction for a given user and issues a that
     can be used to reset a user's password*/
    func recoverPassword(username: String, completion: @escaping Completion) {
        OktaAuthSdk.recoverPassword(with: URL(string: OktaUrls.passwordRecoveryUrl.rawValue)!, username: username, factorType: .email, onStatusChange: { authStatus in
            completion(.success(authStatus))
        }) { error in
            completion(.failure(error))
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
}

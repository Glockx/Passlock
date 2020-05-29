//
//  AuthenticationService.swift
//  Passlock
//
//  Created by Muzaffarli Nijat on 2020/05/19.
//  Copyright © 2020 Muzaffarli Nijat. All rights reserved.
//

import Combine
import Foundation
import LocalAuthentication
import UIKit

public class AuthenticationService: ObservableObject {
    @Published var isAuthorized = false
    @Published var dbHasConnected = false
    @Published var hasFound = false
    @Published var reason = "Loading..."
    
    static var shared = AuthenticationService()
    // Update State of Application
    var ApplicationStatePublisher: AnyPublisher<Notification, Never> {
        Publishers.Merge3(NotificationCenter.default
            .publisher(for: UIApplication.didEnterBackgroundNotification),
            NotificationCenter.default
                .publisher(for: UIApplication.didBecomeActiveNotification),
            NotificationCenter.default
                .publisher(for: UIApplication.willEnterForegroundNotification)
        ).eraseToAnyPublisher()
    }

    // MARK: Authentication Function

    // Function: Authenticate User with Biometric Input
    func authenticate(completion: @escaping ((String) -> Void)) {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                        print("authorized")
                        self.isAuthorized = true

                    } else {
                        // there was a problem
                        print("Not Authorized")
                        let strMessage = self.errorMessage(errorCode: error!._code)
                        self.isAuthorized = false
                        completion(strMessage)
                    }
                }
            }
        } else {
            // no biometrics
            let strMessage = errorMessage(errorCode: (error?._code)!)
            completion(strMessage)
        }
    }
    
    func initDB(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let sqlManager = delegate.SQLite
        
        sqlManager?.connectToDb()
        sqlManager?.createTablesForDataTypes()
        self.dbHasConnected = true
        self.isAuthorized = true
    }

    func errorMessage(errorCode: Int) -> String {
        var strMessage = ""

        switch errorCode {
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Has Failed"

        case LAError.Code.biometryLockout.rawValue:
            strMessage = "Authentication was not successful, because there were too many failed biometry attempts and biometry is now locked."

        case LAError.Code.biometryNotAvailable.rawValue:
            strMessage = "Authentication could not start, because biometry is not available on the device."

        case LAError.Code.biometryNotEnrolled.rawValue:
            strMessage = "Authentication could not start, because biometry has no enrolled identities."

        case LAError.Code.notInteractive.rawValue:
            strMessage = "Displaying the required authentication user interface is forbidden."

        case LAError.Code.userCancel.rawValue:
            strMessage = "The user tapped the cancel button in the authentication dialog."

        case LAError.Code.userFallback.rawValue:
            strMessage = "The user tapped the fallback button in the authentication dialog, but no fallback is available for the authentication policy."

        case LAError.Code.systemCancel.rawValue:
            strMessage = "The system canceled authentication."

        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please goto the Settings & Turn On Passcode"

        case LAError.Code.appCancel.rawValue:
            strMessage = "The app canceled authentication."

        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"

        default:
            strMessage = ""
        }
        return strMessage
    }
}

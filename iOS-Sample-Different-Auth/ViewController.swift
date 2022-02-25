//
//  ViewController.swift
//  iOS-Sample-Different-Auth
//
//  Created by Anjum, Zeeshan on 25/02/2022.
//

import UIKit
import AWSMobileClient

class ViewController: UIViewController {
    enum AuthFlow: String {
        case USER_SRP_AUTH = "awsconfiguration-USER_SRP_AUTH"
        case USER_PASSWORD_AUTH = "awsconfiguration-USER_PASSWORD_AUTH"
        case CUSTOM_AUTH = "awsconfiguration-CUSTOM-AUTH"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configureFlow(authType: AuthFlow) {
        do {
            try AWSConfiguration.configure(authFile: authType.rawValue)
            print("Yayy SDK configured")
        } catch _ {
           print("Some kind of exception")
        }
    }
}

extension ViewController {
    @IBAction func configureSRPAuth(_ sender: Any) {
        configureFlow(authType: AuthFlow.USER_SRP_AUTH)
    }
    

    @IBAction func configureUserPasswordAuth(_ sender: Any) {
        configureFlow(authType: AuthFlow.USER_PASSWORD_AUTH)
    }
    
    @IBAction func configureCustomAuth(_ sender: Any) {
        configureFlow(authType: AuthFlow.CUSTOM_AUTH)
    }
    
    @IBAction func signIn(_ sender: Any) {
        AWSMobileClient.default().signOut()
        AWSMobileClient.default().signIn(username: "iamanjum", password: "Windows@123") { result, error in
            print("")
        }
    }
}

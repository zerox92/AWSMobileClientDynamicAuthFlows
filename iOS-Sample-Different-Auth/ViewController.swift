//
//  ViewController.swift
//  iOS-Sample-Different-Auth
//
//  Created by Anjum, Zeeshan on 25/02/2022.
//

import UIKit
import AWSMobileClient
import AWSAuthCore

class ViewController: UIViewController {
    enum AuthFlow: String {
        case USER_SRP_AUTH = "awsconfiguration-USER_SRP_AUTH"
        case USER_PASSWORD_AUTH = "awsconfiguration-USER_PASSWORD_AUTH"
        case CUSTOM_AUTH = "awsconfiguration-CUSTOM-AUTH"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func configureSRPAuth(_ sender: Any) {
        self.configureFlow(authType: AuthFlow.USER_SRP_AUTH)
    }
    

    @IBAction func configureUserPasswordAuth(_ sender: Any) {
        self.configureFlow(authType: AuthFlow.USER_PASSWORD_AUTH)
    }
    
    @IBAction func configureCustomAuth(_ sender: Any) {
        self.configureFlow(authType: AuthFlow.CUSTOM_AUTH)
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

class AWSConfiguration {
    enum AppError: Error {
        case configurationDontExist
    }
    
    static func retrieve(forResource: String) throws -> Data {
        guard let path = Bundle(for: self).path(forResource: forResource, ofType: "json") else {
            throw AppError.configurationDontExist
        }

        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
    
    static func configure(authFile: String) throws {
        let configurationData = try retrieve(forResource: authFile)
        let authConfig = (try? JSONSerialization.jsonObject(with: configurationData, options: [])
            as? [String: Any]) ?? [:]
        AWSInfo.configureDefaultAWSInfo(authConfig)
        AWSMobileClient.default().initialize { _, error in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            print("AWSMobileClient initialized.")
        }
    }
}

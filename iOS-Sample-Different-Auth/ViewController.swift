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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        do {
            try AWSConfiguration.configure()
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
    
    static func configure() throws {
        let configurationData = try retrieve(forResource: "awsconfiguration")
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

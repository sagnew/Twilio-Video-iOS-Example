//
//  ViewController.swift
//  Twilio-Video-iOS-Example
//
//  Created by Sam Agnew on 2/12/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var accessToken = "TWILIO_ACCESS_TOKEN"
    var tokenUrl = "http://localhost:8000/token.php"
    
    var accessManager: TwilioAccessManager?
    var client: TwilioConversationsClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure access token
        if accessToken == "TWILIO_ACCESS_TOKEN" {
            Alamofire.request(.GET, self.tokenUrl)
                .responseJSON(completionHandler: { response in
                    if let JSON = response.result.value {
                        if let token = JSON["token"] {
                            self.accessToken = token as! String
                            print(self.accessToken)
                        }
                    }
                })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeClient() {
        // create an access manager to take care of token expiration events
        self.accessManager = TwilioAccessManager(token:self.accessToken, delegate:self);
        
        self.client = TwilioConversationsClient(accessManager: self.accessManager!,
            delegate: self);
        
        // Start listening for invitations - delegate methods are fired when the
        // connection succeeds or fails
        self.client?.listen();
        print("The client identity is \(self.client?.identity)");
    }


}


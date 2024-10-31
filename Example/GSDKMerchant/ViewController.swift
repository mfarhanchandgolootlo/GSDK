//
//  ViewController.swift
//  GSDKMerchant
//
//  Created by mfarhanchandgolootlo on 10/25/2024.
//  Copyright (c) 2024 mfarhanchandgolootlo. All rights reserved.
//

import UIKit
import GSDKMerchant
class ViewController: UIViewController {

    let dataValue = "UserId=NBP&FirstName=TEST&LastName=USER&Phone=923360824990&Password=YMcxt4S1I3ZpG6dqsvxt"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func actionButtonShowControllerUsingPresnet()
    {
        let merchant = GolootloWebController(baseURL: "https://webview-staging.golootlo.pk/home?", delegate: self, dataObject: dataValue, appversion: "2.1.7", hideCross: false, crossAlignemtn: .left, pemfile: "Golootlo-Staging-Public-Key")
        
        self.present(merchant, animated: true) {
            print("loaded controller")
        }
    }
    
    @IBAction func actionButtonPresentAndencyptionUsingOwn()
    {
        // if you want to encrypt your data pass value like this
        let urlString  = "https://webview-staging.golootlo.pk/home?data=skTipOK4bJZ1%2F8VKHNwuYQw4EWhST2MGNYSwnUHSteul8RuBFxMf3xbLHt2wrrE%2Fsup3TKx7kEtpg8hnxHYyTZy5yKSAltcxQAXsD6wCaK4tXaq4j1oYYkQmjNSKB2PRWmEm9ze%2BlE%2FybfcQHmO6iY7otZDFadhcR5AuCYhpi6QebT1HTzIUq%2BA1xDsjVqFne8h5GR%2FaxANpZ%2Fw6%2FnVlemtchw0ief0U63b5JCDZd6dsewIp0pcswvzM4NQdWKdkArmXZ67G%2FOkthsFKErPsD%2BI%2FsZOF9LRgwb1y%2FAVsk8FDCxZNXoorGUe44MGnkuwuIM4IaWTAHYIl%2F1%2FK0mzuPA%3D%3D"
        
        let merchant = GolootloWebController(baseURL: urlString, delegate: self,appversion: "2.1.7", hideCross: false, crossAlignemtn: .left)
        self.present(merchant, animated: true) {
            print("loaded controller")
        }
    }
    
    @IBAction func actionButtonShowControllerUsingRightPresnet()
    {
        let merchant = GolootloWebController(baseURL: "https://webview-staging.golootlo.pk/home?", delegate: self, dataObject: dataValue, appversion: "2.1.7", hideCross: false, crossAlignemtn: .right, pemfile: "Golootlo-Staging-Public-Key")
        
        self.present(merchant, animated: true) {
            print("loaded controller")
        }
    }
    
    @IBAction func actionButtonShowControllerUsingNavigaControl()
    {
        let merchant = GolootloWebController(baseURL: "https://webview-staging.golootlo.pk/home?", delegate: self, dataObject: dataValue, appversion: "2.1.7", hideCross: false, crossAlignemtn: .none, pemfile: "Golootlo-Staging-Public-Key")
        
        self.navigationController?.pushViewController(merchant, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: GolootloEventDelegate
{
    func golootlo(event: String) {
        print("golootlo Event " + event)
    }
    
    func golootloViewDidLoad(animated: Bool) {
        print("golootloViewDidLoad")
    }
    
    func golootloViewWillAppear(_ animated: Bool) {
        print("golootloViewWillAppear")
    }
    
    func golootloViewDidAppear(_ animated: Bool) {
        print("golootloViewDidAppear")
    }
    
    func golootloViewDidDisappear(_ animated: Bool) {
        print("golootloViewDidDisappear")
    }
    
    func golootloViewWillDisappear(_ animated: Bool) {
        print("golootloViewWillDisappear")
    }
    
    func golootloWillMoveFromParent() {
        print("golootloWillMoveFromParent")
    }
}

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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        howToUseThisFunc()
    }
    
    func howToUseThisFunc()
    {
        let dataValue = "UserId=NBP&FirstName=TEST&LastName=USER&Phone=923360824990&Password=YMcxt4S1I3ZpG6dqsvxt"
        
        let merchant = GolootloWebController(baseURL: "https://webview-staging.golootlo.pk/home?", delegate: self, dataObject: dataValue, appversion: "2.1.7", hideCross: false, crossAlignemtn: 1, pemfile: "Golootlo-Staging-Public-Key")
        self.present(merchant, animated: true) {
            print("loaded controller")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: GolootloEventDelegate
{
    func golootlo(event: String) {
        print("asdfsadf")
    }
    
    func golootloViewDidLoad(animated: Bool) {
        print("asdfsadf")
    }
    
    func golootloViewWillAppear(_ animated: Bool) {
        print("asdfsadf")
    }
    
    func golootloViewDidAppear(_ animated: Bool) {
        print("asdfsadf")
    }
    
    func golootloViewDidDisappear(_ animated: Bool) {
        print("asdfsadf")
    }
    
    func golootloViewWillDisappear(_ animated: Bool) {
        print("asdfsadf")
    }
    
    func golootloWillMoveFromParent() {
        print("asdfsadf")
    }
}

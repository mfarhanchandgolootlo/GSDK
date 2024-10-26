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
        testion()
    }
    
    func testion()
    {
        var urlString  = "https://webview.golootlo.pk/home?data=rDBeANsIebUducq4MQRoRUaf3mHneuByBdP4uFKjjiSlRmNKonPKc1y%2BwYQlo1PFx0vSoJnlk7f%2B3pZAmhbDR0yq5RelQ8UFSppp%2BBZ%2BWRYFpqcM69H%2BoRNmD2h8VKTMnTNjOVxGoFthvlMr4wd7bXxZ3f97AmqHnd%2F8oYcdlggnD08RBkxNHDK7FRyJC5gBteoH66Usemr%2FsnPvmqXRGZ4Xv2XkQ2zR0Vus6vyV6XHeN3hhEmWIxWMfFSvDIhujMr6H9uJpDfvSk%2BF7mbaiL0NmS0NafTYXY01%2FcPBVwdIJ70xLLxvZv41PXcFH0k%2B9X7aPAC5uWyRVVzcAe0d4cQ%3D%3D&appversion=2.1.7"
        
        let dataValue = "rDBeANsIebUducq4MQRoRUaf3mHneuByBdP4uFKjjiSlRmNKonPKc1y%2BwYQlo1PFx0vSoJnlk7f%2B3pZAmhbDR0yq5RelQ8UFSppp%2BBZ%2BWRYFpqcM69H%2BoRNmD2h8VKTMnTNjOVxGoFthvlMr4wd7bXxZ3f97AmqHnd%2F8oYcdlggnD08RBkxNHDK7FRyJC5gBteoH66Usemr%2FsnPvmqXRGZ4Xv2XkQ2zR0Vus6vyV6XHeN3hhEmWIxWMfFSvDIhujMr6H9uJpDfvSk%2BF7mbaiL0NmS0NafTYXY01%2FcPBVwdIJ70xLLxvZv41PXcFH0k%2B9X7aPAC5uWyRVVzcAe0d4cQ%3D%3D"
        
        if let url = URL(string: urlString)
        {
            let merchant = GolootloWebController(baseURL: "https://webview.golootlo.pk/home?", delegate: self, dataObject: dataValue, appversion: "2.1.7", hideCross: false, crossAlignemtn: 0, pemfile: "")
//            merchant.modalPresentationStyle = .fullScreen
            self.present(merchant, animated: true) {
                print("asdfasdfsafd")
            }
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

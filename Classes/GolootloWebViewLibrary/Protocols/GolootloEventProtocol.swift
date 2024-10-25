//
//  GolootloEventProtocol.swift
//  GolootloWebViewLibrary
//
//  Created by Asad Khan on 23/08/2019.
//  Copyright © 2019 Decagon. All rights reserved.
//

import Foundation

@objc public protocol GolootloEventDelegate{
    
    func golootlo(event: String)
    
    func golootloViewDidLoad(animated:Bool)
    func golootloViewWillAppear(_ animated: Bool)
    func golootloViewDidAppear(_ animated: Bool)
    func golootloViewDidDisappear(_ animated: Bool)
    func golootloViewWillDisappear(_ animated: Bool)
    func golootloWillMoveFromParent()
}

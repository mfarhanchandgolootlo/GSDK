//
//  URL+QueryParams.swift
//  GolootloWebViewLibrary
//
//  Created by Asad Khan on 24/12/2019.
//  Copyright © 2019 Decagon. All rights reserved.
//

import Foundation

extension URL{
    
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
}

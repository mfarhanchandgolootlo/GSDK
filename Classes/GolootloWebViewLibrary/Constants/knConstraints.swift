//
//  knConstraints.swift
//  knConstraints
//
//  Created by Ky Nguyen on 4/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit


extension UIImage {
    
    static func fromPod(named name: String) -> (UIImage?, Bundle?) {
        // Loop through all bundles to find the correct one for the image
        for bundle in Bundle.allBundles + Bundle.allFrameworks {
            if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
                
                return (image, bundle)
            }
        }
        print("Image not found in any available bundle.")
        return (nil, nil)
    }
}

public class ImageLoader {
    public static func loadImage(named imageName: String) -> UIImage? {
        // Ensure that the bundle is correctly fetched
        let bundle = Bundle(for: self)
        
        // If your images are inside an assets folder, use this line
        if let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) {
            return image
        }
        
        // Alternative method if image not in assets folder
        if let imageURL = bundle.url(forResource: imageName, withExtension: "pdf"),
           let imageData = try? Data(contentsOf: imageURL) {
            return UIImage(data: imageData)
        }
        
        // Alternative method if image not in assets folder
        if let imageURL = bundle.url(forResource: imageName, withExtension: "png"),
           let imageData = try? Data(contentsOf: imageURL) {
            return UIImage(data: imageData)
        }
        
        // If image not found, return nil
        return nil
    }
}

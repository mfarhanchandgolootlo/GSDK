//
//  Constants.swift
//  GolootloWebViewLibrary
//
//  Created by Asad Khan on 7/23/19.
//  Copyright © 2019 Decagon. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation

enum Constants {
    enum GolootloConstants: String {
        case navTitle = "Golootlo";
    }
    
}

func requestCameraAccess() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        // The user has already granted permission
        print("Camera access already granted")
    case .notDetermined:
        // The user has not been asked yet; request permission
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Camera access granted")
                } else {
                    print("Camera access denied")
                }
            }
        }
    case .denied:
        print("Camera access was previously denied")
        // Optionally, guide the user to Settings to enable access
    case .restricted:
        print("Camera access is restricted and cannot be requested")
    @unknown default:
        print("Unknown authorization status")
    }
}

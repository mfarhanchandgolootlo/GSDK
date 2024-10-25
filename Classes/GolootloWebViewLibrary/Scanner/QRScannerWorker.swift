//
//  QRScannerWorker.swift
//  Golootlo
//
//  Created by Asad Khan on 2/26/18.
//  Copyright (c) 2018 Golootlo. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVFoundation

enum QRError : Error{
    
    case permissionNotGranted
    case cameraNotDetected
}

protocol QRCameraAccessPermission {
    func userAllowed(cameraAccess : Bool)
}

protocol QRDetectedProtocol {
    func detected(code : String)
}

class QRScannerWorker
{
    
    
    let supportedBarCodes  : [AVMetadataObject.ObjectType] = [AVMetadataObject.ObjectType]()
    
    // Added to support different barcodes
    static let qrTypes : [AVMetadataObject.ObjectType] = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec]
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureSession : AVCaptureSession?
    
    var position  : AVCaptureDevice.Position
    var metaFilter : [AVMetadataObject.ObjectType]
    var parentView : UIView
    var outputDelegate : AVCaptureMetadataOutputObjectsDelegate
    
    var permissionDelegate : QRCameraAccessPermission
    
    
    init(camerType : AVCaptureDevice.Position = .back, metadataObjectTypes :[AVMetadataObject.ObjectType] = qrTypes  ,view : UIView,delegate :AVCaptureMetadataOutputObjectsDelegate ) {
        
        position = camerType
        metaFilter = metadataObjectTypes
        parentView = view
        outputDelegate = delegate
        permissionDelegate = delegate as! QRCameraAccessPermission
        captureSession = AVCaptureSession()
        
    }
    
    func userHasAllowedCameraAccess()->Bool{
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            return true
        }
            return false
    }
    
    func askForCameraPermission(){
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (access) in
               self.permissionDelegate.userAllowed(cameraAccess: access)
        }
    }
    func scan(errorHandler : @escaping (() throws -> QRError?) -> Void)
  {
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    
    if userHasAllowedCameraAccess(){
        
        var captureDeviceCamera:AVCaptureDevice!
        
        if #available(iOS 10.0, *) {
            
             captureDeviceCamera = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: position)
        }else{
            
            captureDeviceCamera = AVCaptureDevice.default(for:AVMediaType.video)
            
        }
        
        
        
        if let captureDevice = captureDeviceCamera{
            do {
                // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                // Initialize the captureSession object.
                
                // Set the input device on the capture session.
                captureSession?.addInput(input)
                
                // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession?.addOutput(captureMetadataOutput)
                
                // Set delegate and use the default dispatch queue to execute the call back
                captureMetadataOutput.setMetadataObjectsDelegate(outputDelegate, queue: DispatchQueue.main)
                
                // Detect all the supported bar code
                captureMetadataOutput.metadataObjectTypes = metaFilter
                
                // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer?.frame = parentView.layer.bounds
                parentView.layer.addSublayer(videoPreviewLayer!)
                
            } catch {
                // If any error occurs, simply print it out and don't continue any more.
                
                print(error)
                
                
                errorHandler{throw error}
                
                
                
            }
            
        }else{
           errorHandler{throw QRError.cameraNotDetected}
        }
    }else{
        
        errorHandler{throw QRError.permissionNotGranted}
    }
    
  }
}

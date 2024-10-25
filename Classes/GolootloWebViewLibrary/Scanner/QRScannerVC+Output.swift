//
//  QRScannerViewControllerOutput.swift
//  Golootlo
//
//  Created by Asad Khan on 2/26/18.
//  Copyright © 2018 Golootlo. All rights reserved.
//

import Foundation
import AVFoundation

extension QRScannerViewController : AVCaptureMetadataOutputObjectsDelegate,QRCameraAccessPermission{
    
    func userAllowed(cameraAccess: Bool) {
        
        if cameraAccess{
            self.startScanning()
            return
        }
        DispatchQueue.main.async {
            self.showPermissionAlert()
        }
      //  showAlertWith(title: alertTitleTextPermission, message: "We need camera access permission to read QR code")
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            //            qrCodeFrameView?.frame = CGRect.zero
            //            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if QRScannerWorker.qrTypes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            _ = worker?.videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            //qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if let encryptedString = metadataObj.stringValue  {
                
                self.worker?.captureSession?.stopRunning()
                    print(encryptedString)
                
                DispatchQueue.main.async {[unowned self] in
                  
                    self.detected(code: encryptedString)
                }
   
            }
        }
        
        
    }
    
    
}

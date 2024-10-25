//
//  QRScannerViewController.swift
//  Golootlo
//
//  Created by Asad Khan on 2/26/18.
//  Copyright (c) 2018 Golootlo. All rights reserved.
//
//
//

import UIKit



enum DiscountFlow :Int{
    case kfcDiscount
    case singleDiscount
    case multiDiscount
    case dunyaPSLQR
    case pslScratchNWinQR
    case eidiCampaign
}

internal class QRScannerViewController: UIViewController
{
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    var worker : QRScannerWorker?
    var detected : Bool = false
    
    
    
    private var hashCode : String?
    
    private var showAccessAlert : Bool = false
    
    private var QRFlow : DiscountFlow!
    
    var baseUrl: String?
    
    var PropertyNameText : String?
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        
        
    }
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        startCamera()
        //showScanAlert(channelName: channel)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.extendedLayoutIncludesOpaqueBars = true
        // self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if let worker = self.worker, let _ = self.worker?.captureSession{
            if !(worker.captureSession?.isRunning)!{
                worker.captureSession?.startRunning()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let worker = self.worker, let _ = self.worker?.captureSession{
            if (worker.captureSession?.isRunning)!{
                worker.captureSession?.stopRunning()
            }
        }
        
        self.tabBarController?.tabBar.isHidden = false
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func startCamera(){
        
        self.worker  = QRScannerWorker.init(view: self.view, delegate: self)
        
        if !self.worker!.userHasAllowedCameraAccess(){
            
            self.worker!.askForCameraPermission()
        }else{
            
            self.startScanning()
        }
    }
    func startScanning()
    {
        
        DispatchQueue.main.async { [unowned self] in
            
            self.worker?.scan(errorHandler: { (reason : () throws -> QRError?) ->Void in
                
                do {
                    let _ = try reason()
                }catch{
                    
                    var str : String
                    
                    switch error as! QRError{
                    case .permissionNotGranted:
                        str = "Need camera permission to read QR code."
                    case .cameraNotDetected:
                        str = "Need camera permission to read QR code."
                    default:
                        str = error.localizedDescription
                    }
                    
                    
                }
                
                
            })
            
            self.worker?.captureSession?.startRunning()
            
            let bundle = Bundle(for: type(of: self))
            let image = UIImage(named: "Camera Overlay", in: bundle, compatibleWith: nil)
            let imageView = UIImageView(image: image)
            imageView.frame = self.view.bounds
            self.view.addSubview(imageView)
            
            #if swift(>=5.0)
                self.view.bringSubviewToFront(imageView)
            
            #else
                self.view.bringSubview(toFront:imageView)
            #endif
            
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.text   = "Place your Golootlo QR in the middle of the screen"
            label.font = UIFont.boldSystemFont(ofSize: 14)
            self.view.addSubview(label)
            label.sizeToFit()
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            
            //let centreX     = label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            let leading     = label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10)
            let trailing    = label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
            
            var bottomAnchor : NSLayoutConstraint
            if #available(iOS 11.0, *) {
                bottomAnchor = label.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            } else {
                // Fallback on earlier versions
                bottomAnchor = label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
            }
            
            NSLayoutConstraint.activate([leading,trailing, bottomAnchor])
            
            #if swift(>=5.0)
                self.view.bringSubviewToFront(label)
            
            #else
                self.view.bringSubview(toFront:label)
            #endif
            
            
            let propertyLabel = UILabel()
            propertyLabel.textColor = .white
            propertyLabel.textAlignment = .center
            propertyLabel.text   = self.PropertyNameText
            propertyLabel.font = UIFont.boldSystemFont(ofSize: 28.8)
            self.view.addSubview(propertyLabel)
            propertyLabel.sizeToFit()
            propertyLabel.numberOfLines = 2
            propertyLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let propertyLabelCentreX     = propertyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            //let leading     = propertyLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10)
            //let trailing    = propertyLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
            let width = propertyLabel.width(230)
            var topAnchor : NSLayoutConstraint
            if #available(iOS 11.0, *) {
                topAnchor = propertyLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20)
            } else {
                // Fallback on earlier versions
                topAnchor = propertyLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20)
            }
            
            NSLayoutConstraint.activate([propertyLabelCentreX, topAnchor,width])
            
            #if swift(>=5.0)
            self.view.bringSubviewToFront(propertyLabel)
            
            #else
            self.view.bringSubview(toFront:propertyLabel)
            #endif
            //self.view.bringSubview(toFront:label)
            //self.view.layer.addSublayer(self.topBar.layer)
        }
        
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        if (self.navigationController?.viewControllers.count)! > 1{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    func showErrorAlert(message : String){
        
        let alertController : UIAlertController = UIAlertController.init(title: "Oops", message: message, preferredStyle: .alert)
        
        let closeAction : UIAlertAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            
            self.worker?.captureSession?.startRunning()
            
        }
        
        alertController.addAction(closeAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showPermissionAlert(){
        
        let alertController : UIAlertController = UIAlertController.init(title: "Camera Permission", message: "Golootlo requires your camera to scan QR code.", preferredStyle: .alert)
        
        let settingAction : UIAlertAction = UIAlertAction.init(title: "Settings", style: .default) { (action) in
            self.openSetting()
        }
        let cancel : UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertController.addAction(settingAction)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
        let label = UILabel()
        
        self.view.addSubview(label)
        #if swift(>=5.0)
        self.view.bringSubviewToFront(label)
        #else
            self.view.bringSubview(toFront:label)
        #endif
        
        label.text = "Golootlo requires camera access to scan QR code."
        
        label.numberOfLines = 2
        label.textColor = .darkText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        let centreX = label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centreY = label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let width   = label.widthAnchor.constraint(equalToConstant: 250)
        
        NSLayoutConstraint.activate([centreX, centreY,width])
        
        let settingButton = UIButton.init(type: .system)
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.setTitle("Change setting", for: .normal)
        settingButton.backgroundColor = .clear
        settingButton.layer.cornerRadius = 10
        settingButton.layer.borderWidth = 1
        settingButton.layer.borderColor = UIColor.black.cgColor
        settingButton.addTarget(self, action: #selector(openSetting), for: .touchUpInside)
        settingButton.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(settingButton)
        #if swift(>=5.0)
        self.view.bringSubviewToFront(settingButton)
        #else
        self.view.bringSubview(toFront:settingButton)
        #endif
        
        let settingCentreX  = settingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let settingY        = settingButton.top(toAnchor:label.bottomAnchor , space: 20)
        let settingWidth    = settingButton.widthAnchor.constraint(equalToConstant: 250)
        let settingHeight    = settingButton.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([settingCentreX, settingY,settingWidth,settingHeight])
        
        
    }
    
    @objc func openSetting(){
        
        if #available(iOS 10.0, *){
            #if swift(>=5.0)
            UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
            #else
                UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
            #endif
            
        }else{
             #if swift(>=5.0)
            UIApplication.shared.openURL(URL(string:UIApplication.openSettingsURLString)!)
            #else
                UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
            #endif
        }
        
    }
    func showScanAlert(channelName:String){
        
        var messageStr : String = ""
        
        messageStr = "Please scan the \(channelName) QR to get access."
        
        let alertController : UIAlertController = UIAlertController.init(title: "Chat Access", message: messageStr, preferredStyle: .alert)
        
        let scanAction : UIAlertAction = UIAlertAction.init(title: "Scan", style: .default) { (action) in
            
            self.startCamera()
        }
        
        alertController.addAction(scanAction)
        
        
        if self.navigationController != nil{
            self.navigationController?.present(alertController, animated: true)
        }else{
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    func showInvalidQRAlert(){
        
        let alertController : UIAlertController = UIAlertController.init(title: "Invalid QR", message: "Scanned QR is not property of Golootlo. Please scan valid Golootlo QR code", preferredStyle: .alert)
        
        let closeAction : UIAlertAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            
            self.worker!.captureSession?.startRunning()
            
        }
        
        alertController.addAction(closeAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
extension QRScannerViewController {
    
    // call service to post data to server
    func detected(code: String) {
        
        guard let url = self.baseUrl else {return}
            
            //let stringURL = "https://\(url)/scanner?ref=index&qrCode=\(code)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            if let navigation = self.navigationController{
                #if swift(>=5.0)
                    let childrens = navigation.children
                #else
                    let childrens = navigation.childViewControllers
                #endif
                
                let vc = childrens.filter{$0.isKind(of:GolootloWebController.self)}.first as! GolootloWebController
                //vc.stringURL = stringURL
                vc.verifyQRData(QRData:code )
               
                self.navigationController?.popViewController(animated: true)
            }else if let presentingVC = self.presentingViewController,let vc =  presentingVC as? GolootloWebController{
                
                //vc.stringURL = stringURL
                vc.verifyQRData(QRData:code )
                
                
                self.dismiss(animated: true, completion: nil)
            }
        
          
    }
}

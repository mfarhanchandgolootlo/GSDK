//
//  ViewController.swift
//  TelenorWebView
//
//  Created by Asad Khan on 14/05/2019.
//  Copyright © 2019 Asad Khan. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation
//import SwiftyRSA
import GSDKMerchant

public enum CrossButtonAlignemnt
{
    case left
    case right
    case none
}

@objc public class GolootloWebController: UIViewController, WKNavigationDelegate,CLLocationManagerDelegate {

    //@IBOutlet weak var loaderImageView: UIImageView!
    
    @objc public var navigationAttributedTitle: NSAttributedString = NSMutableAttributedString(string:Constants.GolootloConstants.navTitle.rawValue, attributes:[
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17)])
    
    var alignemtn:CrossButtonAlignemnt? = .left
   
    @objc public var webView: WKWebView?{
        
        didSet{
            
            self.loadRequest()
        }
    }
    
    var podBundle: Bundle? = nil
    
    private var closeButton: UIButton?
    private var bgImageView: UIImageView?
    private var gIcon:UIImageView?
    //internal var activityIndicator: UIActivityIndicatorView  = UIActivityIndicatorView.init(style: .gray)
    public var isHideCrossButton = false
    
    internal var stringURL:String? {
        
        didSet{
            
            self.loadRequest()
        }
    }
    
    private var errorView: UIView?
    
    private var locationManager = LocationService()
    private var currentLocation : CLLocation?
    
    private var baseUrl: String?
    
    private var eventDelegate: GolootloEventDelegate?
    
    /**
        top padding from  view's top anchor
    */
    @objc public var topPadding:CGFloat = 0{
        didSet{
            
            guard let tpCon = topConstraint else {return}
            let topSpace = topPadding < allowedSpacing ? topPadding:allowedSpacing
            tpCon.constant = topLayoutGuide.length + topSpace
            
            self.view.setNeedsDisplay()
        }
    }
    
    private var topConstraint:NSLayoutConstraint? = nil
    //@IBOutlet weak var errorView: UIView!
    let allowedSpacing = (UIScreen.main.bounds.height * 0.35)
    
//  MARK: - Comment Old Code
//    @objc
//    public init(webURL: URL, delegate: GolootloEventDelegate, hideCross: Bool, crossAlignemtn: Int) {
//        super.init(nibName: nil, bundle: nil)
//        
//        self.baseUrl        = webURL.host
//        self.stringURL      = webURL.absoluteString + "&client=ios"
//        self.eventDelegate  = delegate
//        self.isHideCrossButton = hideCross
//        self.alignemtn = (crossAlignemtn == 0) ? .left : .right
//    }
//  MARK: - Comment Old Code
    
    @objc
    public init(baseURL: String?, delegate: GolootloEventDelegate, dataObject: String, appversion: String, hideCross: Bool, crossAlignemtn: Int, pemfile: String)
    {
        super.init(nibName: nil, bundle: nil)
        self.baseUrl        = baseURL
        let encodedDataResult = getEncoded(plainData: dataObject, pemFileName: pemfile)
        
        let webviewURL = (self.baseUrl ?? "") + "data=" + (encodedDataResult ?? "") + "&appversion=" + appversion + "&client=ios"
        self.stringURL = webviewURL
        
        self.eventDelegate  = delegate
        
        self.isHideCrossButton = hideCross
        self.alignemtn = (crossAlignemtn == 0) ? .left : .right
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.setupWebView()
    }
    
    public override func loadView() {
        super.loadView()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.setupWebView()
        self.setupBGImage()
        self.addGLoader()
      //  self.setupActivityIndicator()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // For use in foreground
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        self.view.backgroundColor = .white
        
        self.setupErrorView()
        
       if self.navigationController != nil{
            setNavBarTitle()
        }
        
        if let customImage = UIImage.fromPod(named: "Sad Face") {
            // Use the image
            print("han")
        }
        
        if let customImage = UIImage.fromPod(named: "Black G Icon") {
            // Use the image
            print("han")
        }
        
        if let customImage = UIImage.fromPod(named: "Close Icon") {
            // Use the image
            print("han")
        }
        
        if let customImage = UIImage.fromPod(named: "Camera Overlay") {
            // Use the image
            print("han")
        }
        
        //self.view.bringSubviewToFront(self.loaderImageView!)
    }
    
    deinit {
        
        // Without this, it'll crash when your WebViewController instance is deinit'd
        webView?.scrollView.delegate = nil
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.eventDelegate?.golootloViewWillAppear(animated)
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.eventDelegate?.golootloViewDidAppear(animated)
        if self.presentingViewController != nil{
            if self.isHideCrossButton == false{
                addCloseButton()
            }
        }
    }
   
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.eventDelegate?.golootloViewDidDisappear(animated)
    }
    public override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
        
        self.eventDelegate?.golootloViewWillDisappear(animated)
        
        #if swift(>=5.0)
            if self.isMovingFromParent{
                self.eventDelegate?.golootloWillMoveFromParent()
            }
        #else
//            if self.isMovingFromParentViewController{
//                self.eventDelegate?.golootloWillMoveFromParent()
//            }
        #endif
        
        if self.isMovingFromParent
        {
            self.eventDelegate?.golootloWillMoveFromParent()
        }
    }
    
    @objc public func addNavigationBar(leftButtons:[UIBarButtonItem]? = nil,rightButtons:[UIBarButtonItem]? = nil){
        
        self.navigationItem.leftBarButtonItems = leftButtons
        self.navigationItem.rightBarButtonItems = rightButtons
    }
    
    @objc public func refreshWebView(){
        
        self.webView?.reload()
    }
    private func addCloseButton(){
        
        closeButton = UIButton.init()
        type(of: self)
        
//        let bundle = Bundle(for: type(of: self))
                
        let image = UIImage(named: "Close Icon", in: self.podBundle, compatibleWith: nil)
        closeButton!.setImage(image, for: .normal)
        closeButton!.tintColor = .white
        closeButton?.layer.cornerRadius = 22
        closeButton?.backgroundColor = .clear
        closeButton?.translatesAutoresizingMaskIntoConstraints = false
        closeButton!.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        self.view.addSubview(closeButton!)
        setupButtonConstraint()
    }
    private func setNavBarTitle(){
        
        let navLabel = UILabel()
        
        let navTitle = navigationAttributedTitle
        
        
        navLabel.attributedText = navTitle
        
        navLabel.sizeToFit()
        self.navigationItem.titleView = navLabel
    }

    private func getWKUserContentController()->WKUserContentController{
        
        let currentPosition = "navigator.geolocation.getCurrentPosition = function(success, error, options) {};"
        
        let locationScript = WKUserScript(source:currentPosition , injectionTime: WKUserScriptInjectionTime.atDocumentEnd
            , forMainFrameOnly:     false)
        
        let callPostionMethod = "window.webkit.messageHandlers.locationHandler.postMessage('getCurrentPosition');"
        
        let functionScript = "function didUpadteLocation(coordinates){successBlock(coordinates)}"
        
        let script = WKUserScript(source:callPostionMethod , injectionTime: WKUserScriptInjectionTime.atDocumentEnd
            , forMainFrameOnly:     false)
        
        let funcScript = WKUserScript(source:functionScript , injectionTime: WKUserScriptInjectionTime.atDocumentEnd
            , forMainFrameOnly:     false)
        
        
        let contentController = WKUserContentController()
        
        contentController.add(self, name: "locationHandler")
        contentController.add(self, name: "webViewEvent")
        //contentController.add(self, name: "getCurrentPosition")
        contentController.addUserScript(funcScript)
        contentController.addUserScript(locationScript)
        contentController.addUserScript(script)
        
        return contentController
    }
    
    
    private func setupWebView(){
        
        /// scripts to handle location
        let contentController = getWKUserContentController()
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.websiteDataStore =  WKWebsiteDataStore.default()
        //let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        //webView!.uiDelegate = self
        webView!.navigationDelegate  = self
        webView!.scrollView.delegate = self
        webView!.scrollView.minimumZoomScale = 1.0
        webView!.allowsBackForwardNavigationGestures = true
        webView!.allowsLinkPreview = false
        webView!.scrollView.bounces = false

        self.view.addSubview(webView!)
        
        //add observer to get estimated progress value
        webView!.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        setupWebViewConstraints()
        
        webView!.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        //webView!.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        
        
    }
    
    private func setupErrorView(){
        
        errorView = UIView()
        errorView?.isHidden = true
        errorView!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(errorView!)
//        #if swift(>=5.0)
//            self.view.bringSubviewToFront(errorView!)
//        #else
//             self.view.bringSubview(toFront:errorView!)
//        #endif
        self.view.bringSubviewToFront(errorView!)
        
        let centerY = errorView!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor,constant: -100)
        let centerX = errorView!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        let width   = errorView!.widthAnchor.constraint(equalToConstant: 300)
        let height  = errorView!.widthAnchor.constraint(equalToConstant: 300)
        
        NSLayoutConstraint.activate([centerY, centerX, width, height])
        
//        let bundle              = Bundle(for: type(of: self))
                
        guard let image = UIImage(named: "Sad Face", in: self.podBundle, compatibleWith: nil) else {return}
        
        let imageView           = UIImageView.init(image:image)
        imageView.contentMode   = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        errorView?.addSubview(imageView)
        
        let top             = imageView.topAnchor.constraint(equalTo: self.errorView!.topAnchor)
        let imgCenterX      = imageView.centerXAnchor.constraint(equalTo: self.errorView!.centerXAnchor)
        
        let imgWidth        = imageView.widthAnchor.constraint(equalToConstant: 200)
        let imgHeight       = imageView.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([top, imgCenterX, imgWidth, imgHeight])
        
        let errorLabel              = UILabel()
        errorLabel.text             = "No Internet Connection"
        errorLabel.font             = .systemFont(ofSize: 20)
        errorLabel.textAlignment    = .center
        errorLabel.textColor        = UIColor(red: 52/255.0, green: 58/255.0, blue: 64/255.0, alpha: 1.0)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorView?.addSubview(errorLabel)
        
        let errortop             = errorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        let errorCenterX         = errorLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        
        NSLayoutConstraint.activate([errortop, errorCenterX])
        
        
        
    }
    private func setupWebViewConstraints() {
        
        webView!.translatesAutoresizingMaskIntoConstraints = false
        
        let topSpace = topPadding < allowedSpacing ? topPadding:allowedSpacing
         topConstraint = webView!.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length + topSpace)
        let bottom = webView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        if #available(iOS 11.0, *) {
            let leading = webView!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            let trailing = webView!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            NSLayoutConstraint.activate([topConstraint!, bottom, trailing, leading])
        } else {
            let leading = webView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            let trailing = webView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            NSLayoutConstraint.activate([topConstraint!, bottom, trailing, leading])
        }
        
        
    }
//
//    /// A way to add padding to webview
//    ///
//    /// Use this method to set webview custom padding from view top anchor
//    /// - Warning: padding should'nt be longer then 35% of the view height
//
//    /// - Parameter padding: `CGFloat` you want spacing from top
//
//    public func setTopPadding(_ padding:CGFloat){
//        guard topConstraint != nil else {return}
//        guard padding < (self.view.frame.height * 0.35) else {return}
//        topConstraint!.constant = padding
//        self.view.setNeedsDisplay()
//    }
    
    private func setupButtonConstraint(){
        
        let btnHeight = closeButton!.heightAnchor.constraint(equalToConstant: 44)
        let btnWidth  = closeButton!.widthAnchor.constraint(equalToConstant: 44)
        if self.alignemtn == .left
        {
            if #available(iOS 11.0, *) {
                let btnTop =   closeButton!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
                let leading = closeButton!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,constant: 24 )
                
                NSLayoutConstraint.activate([btnTop, btnHeight, btnWidth, leading])
            } else {
                let btnTop = closeButton!.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 24)
                let leading = closeButton!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 24)
                
                NSLayoutConstraint.activate([btnTop, btnHeight, btnWidth, leading])
            }
        }
        else{
            if #available(iOS 11.0, *) {
                let btnTop =   closeButton!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
                let leading = closeButton!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,constant: -24 )
                
                NSLayoutConstraint.activate([btnTop, btnHeight, btnWidth, leading])
            } else {
                let btnTop = closeButton!.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 24)
                let leading = closeButton!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 24)
                
                NSLayoutConstraint.activate([btnTop, btnHeight, btnWidth, leading])
            }
        }
    }
    
    private func setupBGImage(){
        
//        let bundle = Bundle(for: type(of: self))
        
        guard let image = UIImage(named: "Golootlo Webview Background", in: self.podBundle, compatibleWith: nil) else {return}
        
        bgImageView = UIImageView.init(image: image)
        bgImageView?.contentMode = .scaleAspectFill
        
        self.view.addSubview(bgImageView!)
        
        bgImageView!.translatesAutoresizingMaskIntoConstraints = false
        
        let top = bgImageView!.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)
        let bottom = bgImageView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        if #available(iOS 11.0, *) {
            let leading = bgImageView!.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
            let trailing = bgImageView!.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        } else {
            let leading = bgImageView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            let trailing = bgImageView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            NSLayoutConstraint.activate([top, bottom, trailing, leading])
        }
    }
    
    private func addGLoader(){
        
//        let bundle = Bundle(for: type(of: self))

        // ponka
        guard let image = UIImage(named: "Black G Icon", in: self.podBundle, compatibleWith: nil) else {return}

        gIcon = UIImageView.init(image: image)
        gIcon?.contentMode = .scaleAspectFit
        gIcon?.clipsToBounds = false
        self.view.addSubview(gIcon!)
        gIcon?.translatesAutoresizingMaskIntoConstraints = false
        gIcon?.centerX(toView: self.view)
        gIcon?.centerY(toView: self.view)
        self.view.bringSubviewToFront(gIcon!)
        gIcon?.width(70)
        gIcon?.height(50)
        
        gIcon?.rotateAndScale()
        
    }
    
    private func QRScanned(){
        
    }
    private func loadRequest(){
        
        //let encodedUrl = stringURL!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        guard let urlString =  stringURL else { return }
        
        guard let url = URL.init(string:urlString) else{
            return
        }
        
        //print("final url = \(url.absoluteString)")
        
        webView?.load(URLRequest(url: url))
    }
    
    @objc func dismissVC(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func verifyQRData(QRData:String){
        //print("data = \(QRData)")
        //let js = "app.QRScan();"
        webView!.evaluateJavaScript("app.QRScan('\(QRData)')", completionHandler: { (result, error) in
            
            //print("result = \(error)")
            //print("error = \(error)")
            
        })
    }
}

extension GolootloWebController:LocationServiceDelegate{
    
    func tracingLocation(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
        
        guard let location = self.currentLocation else {return}
        
        //print("tracingLocation  = \(location)")
        
        
        webView!.evaluateJavaScript("__LATITUDE__ = \(Double (location.coordinate.latitude))", completionHandler: { (result, error) in
            
        })
        
        webView!.evaluateJavaScript("__LONGITUDE__ = \(Double(location.coordinate.longitude))") { (result, error) in
            
        }

      
        webView!.evaluateJavaScript("updateLocation('\(location.coordinate.latitude)','\(location.coordinate.longitude)')") { (result, error) in
            
        }
        
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        
    }
    static func showAlert(){
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            
            
            let alertController = UIAlertController(title:"Access Denied", message:"Golootlo needs your location permission to show nearby discounts."
                       , preferredStyle: UIAlertController.Style.alert)
                       
                       
                       alertController.addAction(UIAlertAction.init(title: "Settings", style: .default, handler: { (action) in
                       
                           if let url = URL(string:UIApplication.openSettingsURLString) {
                               if UIApplication.shared.canOpenURL(url) {
                                   if #available(iOS 10.0, *) {
                                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                   } else {
                                       UIApplication.shared.openURL(url)
                                   }
                               }
                           }
                           
                       }))
                       
                       
                alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in
            
                    
                    
                    
                }))
                
                       if var topController = UIApplication.shared.keyWindow?.rootViewController {
                           while let presentedViewController = topController.presentedViewController {
                               topController = presentedViewController
                           }
                           // topController should now be your topmost view controller
                           topController.present(alertController, animated: true, completion: nil)
                       }
                      
                       
                       //print("Show Setting Alert")
        })
    }
    
    
}

extension GolootloWebController:WKScriptMessageHandler{

    // MARK: - WKScriptMessageHandler
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "locationHandler" {
            
            guard let location = self.currentLocation else {return}
            
           // print("Location  = \(location)")
            
            
            webView!.evaluateJavaScript("__LATITUDE__ = \(Double (location.coordinate.latitude))", completionHandler: { (result, error) in
                
            })
            
            webView!.evaluateJavaScript("__LONGITUDE__ = \(Double(location.coordinate.longitude))") { (result, error) in
                
            }

            webView!.evaluateJavaScript("updateLocation(\((location.coordinate.latitude)),\((location.coordinate.longitude)))") { (result, error) in
                           
                       }
            
        }else if message.name == "webViewEvent"{
            if let dict = message.body as? NSDictionary {
              // print("dictionary = \(dict)")
                if let event = dict.value(forKey: "event"), let eventName = event as? String{
                    self.eventDelegate?.golootlo(event:eventName )
                }
            }
            
            //print("ANONYMOUS FLOW EXECUTED")
        }
    }
    
}

extension GolootloWebController{
    
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == #keyPath(WKWebView.url) {
//            print("### URL:", self.webView!.url!)
//        }
        
        if keyPath == "estimatedProgress" {
            
           debugPrint(" webView estimatedProgress = \(self.webView?.estimatedProgress)")
            
            if let wkweb = self.webView, wkweb.estimatedProgress > 0.6{
                 self.gIcon?.isHidden = true
            }
        }else if let web = webView, let url = web.url {
            
            let components = url.absoluteString.components(separatedBy: "/")
            
            if let component = components.last, component.contains("qrCode"){
                
                
                return
            }
            else if let component = components.last, component.hasPrefix("scanner?ref=index") || component.hasPrefix("scanner?ref=detail"){
                
                
                let urlQueryDictComponents = url.queryParameters
                
                let vc = QRScannerViewController()
                vc.PropertyNameText = urlQueryDictComponents?["title"] ?? ""
                
                vc.baseUrl = self.baseUrl
                if let navigation = self.navigationController{
                    navigation.pushViewController(vc, animated: false)
                    
                    
                }else{
                    self.present(vc, animated: true, completion: nil)
                }
                return
            }

            else if url.absoluteString == "https://telenor.page.link/mta-golootlo"{
                
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url)
                }else{
                        UIApplication.shared.openURL(url)
                }
                
                self.webView?.stopLoading()
                return
            }
        }
        
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        if((error as NSError).code == NSURLErrorNotConnectedToInternet || (error as NSError).code == NSURLErrorTimedOut){
            
            /// This line was not added in version 1.0.1
            self.gIcon?.isHidden = true
            
            errorView?.isHidden = false
            
           
        }
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        let request = navigationAction.request
        if let url = request.url {
            //print("loading url = \(url)")
            let components = url.absoluteString.components(separatedBy: "/")
            
            if let component = components.last, component.contains("qrCode"){
                
                decisionHandler(WKNavigationActionPolicy.allow)
                return
            }
            else if let component = components.last, component.hasPrefix("scanner?ref=index") || component.hasPrefix("scanner?ref=detail"){
                
                decisionHandler(WKNavigationActionPolicy.cancel)
                
                let urlQueryDictComponents = url.queryParameters
        
                let vc = QRScannerViewController()
                vc.PropertyNameText = urlQueryDictComponents?["title"] ?? ""
                vc.baseUrl = self.baseUrl
                if let navigation = self.navigationController{
                    navigation.pushViewController(vc, animated: false)
                   // print("base Url = \(self.baseUrl)")
                   // self.stringURL = (self.baseUrl ?? "") + "/"
                    
                }else{
                    self.present(vc, animated: true, completion: nil)
                }
                
                
                
                return
            }
//            else if let component = components.last, component.contains("data"){
//
//                if self.webView?.backForwardList.backList.count ?? -1 > 0{
//                    self.webView?.go(to: (self.webView?.backForwardList.backList.first)!)
//                    decisionHandler(WKNavigationActionPolicy.cancel)
//                    return
//                }
//            }
            else if url.scheme == "tel" {
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }else{
                    UIApplication.shared.openURL(url)
                }
                
                decisionHandler(.cancel)
                return
            }else if url.absoluteString == "https://telenor.page.link/mta-golootlo"{
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url)
                }else{
                     UIApplication.shared.openURL(url)
                }
                decisionHandler(.cancel)
                return
            }
            
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIView.animate(withDuration: 0.2) {
            
            self.gIcon?.isHidden = true
            self.bgImageView?.isHidden = true
            self.errorView?.isHidden = true
        }
        
        self.webView?.isUserInteractionEnabled = true
    }
    
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIView.animate(withDuration: 0.2) {
            
            self.gIcon?.isHidden = true
            self.bgImageView?.isHidden = true
        }
        self.webView?.isUserInteractionEnabled = true
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"
        
        webView.evaluateJavaScript(javascript, completionHandler: nil)
        
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
        self.webView?.reload()
    }
}

extension GolootloWebController:UIScrollViewDelegate{
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        scrollView.pinchGestureRecognizer?.isEnabled = false
        return nil
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}


extension UIView {
    
    func addConstraint(attribute: NSLayoutConstraint.Attribute, equalTo view: UIView, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        
        let myConstraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: toAttribute, multiplier: multiplier, constant: constant)
        return myConstraint
    }
    
    func addConstraints(withFormat format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }

    func addConstraints(withFormat format: String, arrayOf views: [UIView]) {

        var viewsDictionary = [String: UIView]()

        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func removeSelfConstraints() {
        removeConstraints(constraints)
    }
    
    public func removeAllConstraints() {
        var _superview = self.superview

        while let superview = _superview {
            for constraint in superview.constraints {

                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }

                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }

            _superview = superview.superview
        }

        self.removeConstraints(self.constraints)
//        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    @discardableResult
    public func left(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func left(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func right(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func right(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: view.rightAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func top(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func top(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topLeft(toView view: UIView, top: CGFloat = 0, left: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let topConstraint = self.top(toView: view, space: top)
        let leftConstraint = self.left(toView: view, space: left)
        
        return [topConstraint, leftConstraint]
    }
    
    @discardableResult
    public func topRight(toView view: UIView, top: CGFloat = 0, right: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let topConstraint = self.top(toView: view, space: top)
        let rightConstraint = self.right(toView: view, space: right)
        
        return [topConstraint, rightConstraint]
    }
    
    @discardableResult
    public func bottomRight(toView view: UIView, bottom: CGFloat = 0, right: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self.bottom(toView: view, space: bottom)
        let rightConstraint = self.right(toView: view, space: right)
        
        return [bottomConstraint, rightConstraint]
    }
    
    @discardableResult
    public func bottomLeft(toView view: UIView, bottom: CGFloat = 0, left: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self.bottom(toView: view, space: bottom)
        let leftConstraint = self.left(toView: view, space: left)
        
        return [bottomConstraint, leftConstraint]
    }
    
    @discardableResult
    public func bottom(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottom(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func verticalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func horizontalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint = rightAnchor.constraint(equalTo: view.leftAnchor, constant: -space)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func leftHorizontalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {

        let constraint = leftAnchor.constraint(equalTo: view.rightAnchor, constant: -space)
        constraint.isActive = true
        return constraint
    }

    
    
    public func size(_ size: CGSize) {
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
    }
    
    public func size(toView view: UIView, greater: CGFloat = 0) {
        widthAnchor.constraint(equalTo: view.widthAnchor, constant: greater).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, constant: greater).isActive = true
    }
    
    public func square(edge: CGFloat) {
        
        size(CGSize(width: edge, height: edge))
    }
    
    public func square() {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1, constant: 0).isActive = true
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func width(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    
    @discardableResult
    public func width(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerX(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerX(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    public func center(toView view: UIView, space: CGFloat = 0){
        centerX(toView: view, space: space)
        centerY(toView: view, space: space)
    }
    
    @discardableResult
    public func centerY(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerY(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    
    public func horizontal(toView view: UIView, space: CGFloat = 0) {
        
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: space).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -space).isActive = true
    }
    
    public func horizontal(toView view: UIView, leftPadding: CGFloat, rightPadding: CGFloat) {
        
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftPadding).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightPadding).isActive = true
    }
    
    public func vertical(toView view: UIView, space: CGFloat = 0) {
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: space).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space).isActive = true
    }
    
    public func vertical(toView view: UIView, topPadding: CGFloat, bottomPadding: CGFloat) {
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
    }
    
    
    public func fill(toView view: UIView, space: UIEdgeInsets = .zero) {
        
        left(toView: view, space: space.left)
        right(toView: view, space: -space.right)
        top(toView: view, space: space.top)
        bottom(toView: view, space: -space.bottom)
    }
    
    
    
}






extension UIEdgeInsets {
    
    init(space: CGFloat) {
        self.init(top: space, left: space, bottom: space, right: space)
    }
    
    
}

extension GolootloWebController
{
    public func getEncoded(plainData:String, pemFileName: String)->String?{
//        do{
//            //let publicKey = try PublicKey.init(pemNamed:"live-public-key" , in: Bundle.main)
//            let publicKey = try PublicKey.init(pemNamed:pemFileName , in: Bundle.main)
//            let clear = try ClearMessage(string: plainData, using: .utf8)
//            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
//            
//            // Then you can use:
//            //    let data = encrypted.data
//            let base64String = encrypted.base64String
//            
//            let allowedCharacterSet = CharacterSet.init(charactersIn: "!*'();:@&=+$,/?#[]").inverted
//            let encodedData = base64String.addingPercentEncoding(withAllowedCharacters:allowedCharacterSet)!
//            
//            return encodedData
//            
//        }catch{
//            print(error)
//        }
        
        return nil
    }
}



extension UIImage {
    //    static func fromPod(named name: String) -> UIImage? {
    //
    //        guard let bundle = Bundle(identifier: "org.cocoapods.GSDKMerchant") else {
    //            print("Bundle not found.")
    //            return nil
    //        }
    //
    //        return UIImage(named: name, in: bundle, compatibleWith: nil)
    //    }
    
    static func fromPod(named name: String) -> UIImage? {
        // Loop through all bundles to find the correct one for the image
        for bundle in Bundle.allBundles + Bundle.allFrameworks {
            if let image = UIImage(named: name, in: bundle, compatibleWith: nil) {
                return image
            }
        }
        print("Image not found in any available bundle.")
        return nil
    }
}



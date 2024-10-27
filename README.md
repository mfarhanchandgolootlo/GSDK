# GSDKMerchant

[![CI Status](https://img.shields.io/travis/mfarhanchandgolootlo/GSDKMerchant.svg?style=flat)](https://travis-ci.org/mfarhanchandgolootlo/GSDKMerchant)
[![Version](https://img.shields.io/cocoapods/v/GSDKMerchant.svg?style=flat)](https://cocoapods.org/pods/GSDKMerchant)
[![License](https://img.shields.io/cocoapods/l/GSDKMerchant.svg?style=flat)](https://cocoapods.org/pods/GSDKMerchant)
[![Platform](https://img.shields.io/cocoapods/p/GSDKMerchant.svg?style=flat)](https://cocoapods.org/pods/GSDKMerchant)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

GSDKMerchant is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GSDKMerchant'
```

## Installation using tags

```ruby
  pod 'GSDKMerchant', git: 'https://github.com/mfarhanchandgolootlo/GSDK.git', :tag => '0.0.30'
```

## Xcode Setting
```ruby
    Update your Xcode project build (target) option put ENABLE_USER_SCRIPT_SANDBOXING to 'No', default is 'YES'
```

## Usage

```ruby
import GSDKMerchant
```
Then

```ruby
    let merchant = GolootloWebController(baseURL: "put your base url here", delegate: self, dataObject: dataValue, appversion: "appversion", hideCross: false, crossAlignemtn: 0, pemfile: "Public-Key")
    self.present(merchant, animated: true) {
        
    }
```
where 

```ruby
    crossAlignemtn = 0 -> left
    crossAlignemtn = 1 -> right
    hideCross = false -> it will not hide cross button when you are presenting our controller, if you use hideCross = true then it will hide that cross button
    appversion -> api version which we will give you
```
And

```ruby
    dataValue = "UserId=abc&Password=123456&FirstName=Test&LastName=User&Phone=00000000348"  -> you need to  put this datavalue in or sdk object value i.e, dataObject
```

And

```ruby
    pem = Public-Key.pem 
    put your .pem file in the main project and give proper name in order to encode data (put pem file name without extension .pem)
```

## GolootloWebController Delegates
```ruby
    func golootlo(event: String)
    func golootloViewDidLoad(animated: Bool)
    func golootloViewWillAppear(_ animated: Bool)
    func golootloViewDidAppear(_ animated: Bool)
    func golootloViewDidDisappear(_ animated: Bool)
    func golootloViewWillDisappear(_ animated: Bool)
    func golootloWillMoveFromParent()
```  
## Author

Muhammad Farhan, muhammad.farhan@golootlo.pk, farhan.chnd88@gmail.com
Abdul Moiz, abdul.moiz@golootlo.pk

## License

GSDKMerchant is available under the MIT license. See the LICENSE file for more info.

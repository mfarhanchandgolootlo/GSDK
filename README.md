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

## Usaage

```ruby
import GSDKMerchant
```
Then

```ruby
    let merchant = GolootloWebController(baseURL: "put your base url here", delegate: self, dataObject: dataValue, appversion: "appversion", hideCross: false, crossAlignemtn: 0, pemfile: "")
    
        crossAlignemtn = 0 -> left
        crossAlignemtn = 1 -> right
        
    self.present(merchant, animated: true) {
        
    }
```
## Author

Muhammad Farhan, muhammad.farhan@golootlo.pk, farhan.chnd88@gmail.com

## License

GSDKMerchant is available under the MIT license. See the LICENSE file for more info.

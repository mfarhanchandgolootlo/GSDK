#
# Be sure to run `pod lib lint GSDKMerchant.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GSDKMerchant'
  s.version          = '0.0.38'  # '0.0.30' -> use 0.0.# (for development) and for clients use 1.0.#
  s.summary          = 'A short description of GSDKMerchant.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/mfarhanchandgolootlo/GSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author = { 'muhammad.farhan@golootlo.pk' => 'Muhammad Farhan', 'farhan.chnd88@gmail.com' => 'Muhamamd Farhan', 'abdul.moiz@golootlo.pk' => 'Abdul Moiz' }

  s.source           = { :git => 'https://github.com/mfarhanchandgolootlo/GSDK.git', :tag => s.version.to_s }
   s.social_media_url = 'https://www.linkedin.com/in/muhammedfarhan/'
  s.swift_version = '5.0'
  s.ios.deployment_target = '12.0'

  s.source_files = 'Classes/**/*.{h,m,swift}'
  
  s.script_phase = { :name => 'Disable Code Signing', :script => 'export CODE_SIGNING_ALLOWED=NO', :execution_position => :before_compile }

   s.resources = 'Assests/*.xcassets'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  s.dependency 'SwiftyRSA/ObjC'
end

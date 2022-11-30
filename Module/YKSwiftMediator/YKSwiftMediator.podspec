#  Be sure to run `pod spec lint YKSwiftMediator.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.

Pod::Spec.new do |spec|
  spec.name         = "YKSwiftMediator"
  spec.version      = "0.0.3"
  spec.summary      = "A short description of YKSwiftMediator."
  spec.homepage     = "https://gitee.com/Edwrard/YKSwiftMediator.git"
  spec.license      = "MIT"
  spec.author       = { "edward" => "534272374@qq.com" }
  spec.ios.deployment_target = "9.0"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://gitee.com/Edwrard/YKSwiftMediator.git",:tag => spec.version.to_s }
  spec.framework  = "UIKit","Foundation","AVFoundation","Photos","Security"
  
  
  spec.source_files = 'YKSwiftMediator/Classes/*.{swift}'
  
  
  
end



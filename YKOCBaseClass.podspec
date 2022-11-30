#
# Be sure to run `pod lib lint YKOCBaseClass.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKOCBaseClass'
  s.version          = '0.2.4'
  s.summary          = 'A short description of YKOCBaseClass.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                      
                      工具基类
                       DESC

  s.homepage         = 'https://gitee.com/Edwrard/YKOCBaseClass'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'edward' => 'edward' }
  s.source           = { :git => 'https://gitee.com/Edwrard/YKOCBaseClass.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'YKOCBaseClass/Classes/**/*'
  s.resources = "YKOCBaseClass/Assets/**/*"
  s.dependency 'YKNetWorking'
  s.dependency 'YKDB'
  s.dependency 'ReactiveObjC'
  s.dependency 'MJExtension'
  s.dependency 'MJRefresh'
  s.dependency 'FDFullscreenPopGesture'
  

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

# 

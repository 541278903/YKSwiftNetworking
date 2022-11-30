#
# Be sure to run `pod lib lint YKSwiftCommandModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKSwiftCommandModule'
  s.version          = '1.0.0'
  s.summary          = 'A short description of YKSwiftCommandModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  通用模块
  
  基础请使用Core子模块
                       DESC

  s.homepage         = 'https://gitee.com/Edwrard/YKSwiftCommandModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'edward' => '534272374@qq.com' }
  s.source           = { :git => 'https://gitee.com/Edwrard/YKSwiftCommandModule.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  
  s.dependency 'IQKeyboardManagerSwift'
  s.source_files = 'YKSwiftCommandModule/Classes/*.{swift}'
  
  s.swift_versions = ['4.2', '5', '5.1', '5.2', '5.3', '5.4', '5.5']
  
  # s.resource_bundles = {
  #   'YKSwiftCommandModule' => ['YKSwiftCommandModule/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

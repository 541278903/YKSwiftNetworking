#
# Be sure to run `pod lib lint YKSwiftExectionModel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKSwiftExectionModel'
  s.version          = '1.0.1'
  s.summary          = 'A short description of YKSwiftExectionModel.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitee.com/Edwrard/YKSwiftExectionModel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'edward' => '534272374@qq.com' }
  s.source           = { :git => 'https://gitee.com/Edwrard/YKSwiftExectionModel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'YKSwiftExectionModel/Classes/UIKit/Core/*.{swift}','YKSwiftExectionModel/Classes/NSObject/Core/*.{swift}','YKSwiftExectionModel/Classes/*.{swift}'
  end
   
  s.subspec 'UIKit' do |ss|
    ss.dependency "YKSwiftExectionModel/Core"
    ss.source_files = 'YKSwiftExectionModel/Classes/UIKit/*.{swift}'
  end
    
  s.subspec 'NSObject' do |ss|
    ss.source_files = 'YKSwiftExectionModel/Classes/NSObject/*.{swift}'
  end
  

  
  # s.resource_bundles = {
  #   'YKSwiftExectionModel' => ['YKSwiftExectionModel/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

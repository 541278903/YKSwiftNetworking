#
# Be sure to run `pod lib lint YKSwiftNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKSwiftNetworking'
  s.version          = '0.1.0'
  s.summary          = 'A short description of YKSwiftNetworking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    swift网络请求框架
                       DESC

  s.homepage         = 'https://gitee.com/Edwrard/YKSwiftNetworking'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '534272374@qq.com' => '534272374@qq.com' }
  s.source           = { :git => 'https://gitee.com/Edwrard/YKSwiftNetworking.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.dependency  'Alamofire', '4.9.1'
  s.dependency  'RxSwift'
  s.dependency  "YK_Swift_BaseTools/SwiftyJSON"

  s.source_files = 'YKSwiftNetworking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YKSwiftNetworking' => ['YKSwiftNetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

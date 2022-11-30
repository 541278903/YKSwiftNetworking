#
# Be sure to run `pod lib lint YKSwiftBaseClass.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKSwiftBaseClass'
  s.version          = '1.0.1'
  s.summary          = 'A short description of YKSwiftBaseClass.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
              YKMVVM基础组件
                       DESC

  s.homepage         = 'https://gitee.com/Edwrard/YKSwiftBaseClass'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'edward' => '534272374@qq.com' }
  s.source           = { :git => 'https://gitee.com/Edwrard/YKSwiftBaseClass.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'YKSwiftBaseClass/Classes/**/*'
  
  
  s.dependency  'SnapKit'
  s.dependency  'RxSwift'
  s.dependency  'RxCocoa'
  s.dependency  "YKSwiftCommandModule"
  s.dependency  "YKSwiftNetworking"
  s.dependency  'YKSwiftAlert'
  s.dependency  'KakaJSON'
  s.dependency  'SHFullscreenPopGestureSwift'
  
  s.resources = "YKSwiftBaseClass/Assets/*.png"
  
end

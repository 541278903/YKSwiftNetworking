#
# Be sure to run `pod lib lint YKSwiftNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKSwiftNetworking'
  s.version          = '2.1.1'
  s.summary          = 'swift网络请求框架'


  s.description      = <<-DESC
          swift网络请求框架
                       DESC

  s.homepage         = 'https://github.com/541278903/YKSwiftNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '534272374@qq.com' => '534272374@qq.com' }
  s.source           = { :git => 'https://github.com/541278903/YKSwiftNetworking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.default_subspec = 'Core'
  
  
  s.subspec "Core" do |ss|
    ss.dependency  'Alamofire', "~> 5.0"
    ss.source_files = 'YKSwiftNetworking/Classes/Core/**/*'
  end
  
  s.subspec 'RxSwift' do |ss|
    ss.dependency  'YKSwiftNetworking/Core'
    ss.dependency  'RxSwift', "~> 5.0"
    ss.source_files = 'YKSwiftNetworking/Classes/RxSwift/**/*'
  end
  
end

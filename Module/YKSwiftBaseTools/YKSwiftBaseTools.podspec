#
# Be sure to run `pod lib lint YKSwiftBaseTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YKSwiftBaseTools'
  s.version          = '0.1.0'
  s.summary          = 'A short description of YKSwiftBaseTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitee.com/Edwrard/YKSwiftBaseTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'edward' => '534272374@qq.com' }
  s.source           = { :git => 'https://gitee.com/Edwrard/YKSwiftBaseTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'YKSwiftBaseTools/Classes/*'
  
  s.subspec 'DesHelper' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/DesHelper/*.{swift}'
  end
  
  s.subspec 'TaskUtil' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/TaskUtil/*.{swift}'
  end
  
  s.subspec 'UserDefault' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/UserDefault/*.{swift}'
  end
  
  s.subspec 'VersionManager' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/VersionManager/*.{swift}'
  end
  s.subspec 'StatusMachine' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/StatusMachine/*.{swift}'
  end
  s.subspec 'AudioManager' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/AudioManager/*.{swift}'
  end
  s.subspec 'Record' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/Record/*.{swift}'
  end
  s.subspec 'AppSetting' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/AppSetting/*.{swift}'
  end
  s.subspec 'RabbitMQManager' do |ss|
    ss.dependency 'RMQClient'
    ss.source_files = 'YKSwiftBaseTools/Classes/RabbitMQManager/*.{swift}'
  end
  s.subspec 'SVGImage' do |ss|
    ss.source_files = 'YKSwiftBaseTools/Classes/SVGImage/*.{swift}'
  end
end

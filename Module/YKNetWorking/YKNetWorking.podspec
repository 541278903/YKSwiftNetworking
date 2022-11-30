
Pod::Spec.new do |s|
  s.name             = 'YKNetWorking'
  s.version          = '1.1.0'
  s.summary          = '基于AFNetwork进行的二次封装网络请求框架'

  s.description      = <<-DESC
                基于AFNetwork进行的二次封装网络请求框架
                       DESC

  s.homepage         = 'https://gitee.com/Edwrard/YKNetWorking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'edwardyyk' => '534272374@qq.com' }
  s.source           = { :git => 'https://gitee.com/Edwrard/YKNetWorking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  
  s.default_subspec = 'Core'
  
  s.subspec "Core" do |ss|
      ss.source_files = 'YKNetWorking/Classes/Base/*.{h,m,xib}'
      ss.dependency "AFNetworking"
  end

  s.subspec 'RAC' do |ss|
    ss.source_files = 'YKNetWorking/Classes/RACExtension/*.{h,m,xib}'
    ss.dependency "YKNetWorking/Core"
    
    ss.dependency "ReactiveObjC"
  end
  
end

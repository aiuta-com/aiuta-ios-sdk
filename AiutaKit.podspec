Pod::Spec.new do |s|
  s.name         = 'AiutaKit'
  s.version      = '3.0.0'
  s.summary      = 'Aiuta Core Kit.'
  s.description  = 'Supporting components for Aiuta Virtual Try-On Solution.'
  s.homepage     = 'https://github.com/aiuta-com/aiuta-ios-sdk'
  s.license      = { type: 'Apache 2.0', file: 'LICENSE' }
  s.author       = { 'Aiuta' => 'Partnership@aiuta.com' }
  s.source       = { :git => 'https://github.com/aiuta-com/aiuta-ios-sdk.git', :tag => '#{s.version}' }
  s.source_files  = 'Sources/AiutaKit/**/*.swift'
  s.module_name   = 'AiutaKit'
  
  s.dependency    'Alamofire', '~> 5.8.1'
  s.dependency    'Kingfisher', '~> 7.12.0'
  s.dependency    'Resolver', '~> 1.5.1'
  
  s.swift_version = '5.9'

  s.ios.deployment_target = '12.0'
  s.ios.framework  = 'UIKit'
end

Pod::Spec.new do |s|
  s.name         = 'AiutaKit'
  s.version      = '4.2.3'
  s.summary      = 'Aiuta Core Kit.'
  s.description  = 'Supporting components for Aiuta Virtual Try-On Solution.'
  s.homepage     = 'https://github.com/aiuta-com/aiuta-ios-sdk'
  s.license      = { type: 'Apache 2.0', file: 'LICENSE' }
  s.author       = { 'Aiuta' => 'Partnership@aiuta.com' }
  s.source       = { :git => 'https://github.com/aiuta-com/aiuta-ios-sdk.git', :tag => s.version.to_s }
  s.source_files  = 'Sources/AiutaKit/**/*.swift'
  s.resource_bundles = {
    'AiutaKit' => ['Sources/AiutaKit/Resources/PrivacyInfo.xcprivacy']
  }
  s.module_name   = 'AiutaKit'
  
  s.dependency    'Alamofire', '~> 5.8.1'
  s.dependency    'Kingfisher', '~> 7.12.0'
  s.dependency    'Resolver', '~> 1.5.1'
  
  s.swift_version = '5.10'
  s.ios.deployment_target = '12.0'
  s.ios.framework  = 'UIKit'
end

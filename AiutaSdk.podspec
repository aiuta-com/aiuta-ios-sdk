Pod::Spec.new do |s|
  s.name         = 'AiutaSdk'
  s.version      = '3.3.11'
  s.summary      = 'Aiuta Virtual Try-On SDK.'
  s.description  = 'Virtual Try-On Solution for Apparel and Fashion Businesses.'
  s.homepage     = 'https://github.com/aiuta-com/aiuta-ios-sdk'
  s.license      = { type: 'Apache 2.0', file: 'LICENSE' }
  s.author       = { 'Aiuta' => 'Partnership@aiuta.com' }
  s.source       = { :git => 'https://github.com/aiuta-com/aiuta-ios-sdk.git', :tag => s.version.to_s }
  s.source_files  = 'Sources/AiutaSdk/**/*.swift'
  s.resource_bundles = {
    'AiutaSdk' => ['Sources/AiutaSdk/Resources/PrivacyInfo.xcprivacy'],
    'AiutaSdk_AiutaSdk' => ['Sources/AiutaSdk/Resources/*.{xcassets}']
  }
  s.module_name   = 'AiutaSdk'
  
  s.dependency    'AiutaKit', '3.3.11'
  s.dependency    'Alamofire', '~> 5.8.1'
  s.dependency    'Kingfisher', '~> 7.12.0'
  s.dependency    'Resolver', '~> 1.5.1'
  
  s.swift_version = '5.9'

  s.ios.deployment_target = '12.0'
  s.ios.framework  = 'UIKit'
end

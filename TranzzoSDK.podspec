#
# Be sure to run `pod lib lint TranzzoSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TranzzoSDK'
  s.version          = '0.0.1'
  s.summary          = 'TranzzoSDK helps you get a token for a bank card through Tranzzo Payment Provider.'
  s.description      = "TranzzoSDK provides a simple interface to get a token for a payment card, that your users specify. This token will further be used when working with other Tranzzo services."

  s.homepage         = 'https://tranzzo.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tranzzo' => 'tranzzo.com' }
  s.source           = { :git => 'https://bitbucket.org/tranzzo/ios-widget-light-sdk.git', :tag => s.version.to_s }
s.pod_target_xcconfig = {
  'INFOPLIST_FILE' => '${PODS_TARGET_SRCROOT}/TranzzoSDK/Info.plist'
}

  s.ios.deployment_target = '9.0'

  s.source_files = 'TranzzoSDK'
  s.swift_versions = ['5.0', '5.1']
end

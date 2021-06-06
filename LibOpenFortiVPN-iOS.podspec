#
# Be sure to run `pod lib lint LibOpenFortiVPN-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LibOpenFortiVPN-iOS'
  s.version          = '0.1.0'
  s.summary          = 'LibOpenFortiVPN-iOS is iOS framework for adrienverge/openfortivpn.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'LibOpenFortiVPN-iOS is a library for openfortivpn'

  s.homepage         = 'https://github.com/neoroman/LibOpenFortiVPN-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'neoroman' => 'neoroman' }
  s.source           = { :git => 'https://github.com/neoroman/LibOpenFortiVPN-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/neoroman'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LibOpenFortiVPN-iOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LibOpenFortiVPN-iOS' => ['LibOpenFortiVPN-iOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'OpenSSL-Universal'
end

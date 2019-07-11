#
# Be sure to run `pod lib lint YomLoginKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LoginKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of LoginKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yomw/LoginKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yomw' => 'guillaume.bellue@dv.fr' }
  s.source           = { :git => 'https://github.com/yomw/LoginKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'LoginKit/Classes/**/*'
  
  s.resource_bundles = {
    'LoginKit' => ['LoginKit/Localization/*.lproj', 'LoginKit/Assets/*.xcassets']
  }
  # s.preserve_paths = "LoginKit/Localization/*.lproj"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.static_framework = true
  s.dependency 'AccountKit', '~> 5.0'
  s.dependency 'FacebookCore', '~> 0.7'
  s.dependency 'FacebookLogin', '~> 0.7'
  s.dependency 'GoogleSignIn', '~> 4.4'
  s.dependency 'AnimatedField', '~> 2.2'
end

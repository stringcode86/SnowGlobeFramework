#
# Be sure to run `pod lib lint SnowGlobe.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SnowGlobe"
  s.version          = "2.0"
  s.summary          = "Delightful / cheesy Christmas easter egg to. Shake iPhone to snow"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC SnowGlobe.framework its easy to use, open source iOS framework written in swift. It allows you to ad delightful / cheesy Christmas easter egg to your awesome app for holiday season. When user shakes the device, your app “turns into a snow globe”. Leveraging CAEmitterLayer to create snow fall, snow globe like animation while device is shaken. I am a sucker for that kinda of thing. I don’t see anything wrong with falling for spirit of the holiday season and getting bit cheesy.DESC

  s.homepage         = "http://www.stringcode.co.uk/snowglobe-framework-ios-xmas-easter-egg-shake-iphone-to-make-it-snow/"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "stringcode" => "michael@stringcode.co.uk" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/SnowGlobe.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SnowGlobe' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

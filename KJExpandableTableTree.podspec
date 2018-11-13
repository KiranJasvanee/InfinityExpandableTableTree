#
# Be sure to run `pod lib lint KJExpandableTableTree.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KJExpandableTableTree'
  s.version          = '1.2.0'
  s.summary          = 'A Expandable Tableview Cells'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
Provides a tableview cell expansion (expanding cell area - subcells'), you can expand cells up to level ∞-1. It's on Swift 4.2.
                       DESC

  s.homepage         = 'https://github.com/KiranJasvanee/KJExpandableTableTree'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kiran Jasvanee' => 'kiran.jasvanee@yahoo.com' }
  s.source           = { :git => 'https://github.com/KiranJasvanee/KJExpandableTableTree.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'KJExpandableTableTree/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KJExpandableTableTree' => ['KJExpandableTableTree/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

#
# Be sure to run `pod lib lint IMRemoteImageSize.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "IMRemoteImageSize"
  s.version          = "1.0.1"
  s.summary          = "a library for iOS that allows you to retrieve the size of a remote image without having to download it."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
IMRemoteImageSize is a simple library for iOS that allows you to retrieve the dimensions of a remote image (JPG, GIF, PNG or BMP), without having to download the image. It retrieves the first few bytes of the file and then stops downloading.
                       DESC

  s.homepage         = "https://github.com/IMcD23/IMRemoteImageSize"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ian McDowell" => "mcdow.ian@gmail.com" }
  s.source           = { :git => "https://github.com/IMcD23/IMRemoteImageSize.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ian_mcdowell'

  s.platform     = :ios, '8.3'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'IMRemoteImageSize' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

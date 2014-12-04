#
# Be sure to run `pod lib lint gtm-oauth2-local.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "gtm-oauth2-local"
  s.version          = "0.1.0"
  s.summary          = "A short description of gtm-oauth2-local."
  s.description      = <<-DESC
                       An optional longer description of gtm-oauth2-local

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/gtm-oauth2-local"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "wanghaogithub720" => "wanghaomspace@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/gtm-oauth2-local.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'gtm-oauth2-local' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

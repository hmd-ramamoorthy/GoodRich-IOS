#
# Be sure to run `pod lib lint ViSearch.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ViSearch"
  s.version          = "0.0.3"
  s.summary          = "A Visual Search API solution."
  s.description      = <<-DESC
                        ViSearch is a Visual Recognition Service API developed by ViSenze Pte. Ltd.
                        This iOS SDK provides a quick way to integrate with the ViSearch API.
                       DESC
  s.homepage         = "https://github.com/visenze/visearch-sdk-ios"
  s.license          = 'MIT'
  s.author           = { "Shaohuan Li" => "shaohuan.li@gmail.com" }
  s.source           = { :git => "https://github.com/Lincolnnus/visearch-sdk-ios.git", :tag => s.version.to_s }
  s.social_media_url = 'https://facebook.com/Lincolnnus'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'ViSearchSDK/**/*.{h,m}'

end

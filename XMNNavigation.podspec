#
#  Be sure to run `pod spec lint XMNNavigation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "XMNNavigation"
  s.version      = "0.1.1"
  s.summary      = "全屏手势返回,仿网易手势返回效果"
  s.homepage     = "https://github.com/ws00801526/XMNNavigation"
  s.license      = "MIT"
  s.author       = { "XMFraker" => "3057600441@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ws00801526/XMNNavigation.git", :tag => "#{s.version}" }

  s.source_files  = "Classes/**/*.{h,m}"
  s.requires_arc = true
end

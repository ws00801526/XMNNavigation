Pod::Spec.new do |s|
  s.name         = "XMNNavigation"
  s.version      = "1.0.0"
  s.summary      = "全屏手势返回,类似网易的返回效果"
  s.homepage     = "https://github.com/ws00801526/XMNNavigation"
  s.license      = "MIT"
  s.author       = { "XMFraker" => "3057600441@qq.com" }
  s.source       = { :git => "https://github.com/ws00801526/XMNNavigation.git", :tag => s.version }
  s.platform     = :ios,8.0
  s.frameworks   = 'UIKit'
  s.source_files = 'XMNNavigation/**/*.{h,m}'
  s.requires_arc = true
end
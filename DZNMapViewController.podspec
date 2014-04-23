Pod::Spec.new do |s|
  s.name         = "DZNMapViewController"
  s.version      = "0.0.3"
  s.summary      = ""
  s.homepage     = "https://github.com/dzenbot/DZNMapViewController"
  s.license      = 'MIT'
  s.author       = { "Ignacio Romero Z." => "iromero@dzen.cl" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/dzenbot/DZNMapViewController.git", :tag => "v0.0.3" }
  s.source_files  = 'Classes', '**/*.{h,m}'
  s.framework  = 'MapKit'
  s.requires_arc = true
end

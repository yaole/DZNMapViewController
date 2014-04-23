Pod::Spec.new do |s|
  s.name         = "DZNMapViewController"
  s.version      = "0.0.3"
  s.summary      = "A map view controller with the ability to easy display annotations and export options."
  s.homepage     = "https://github.com/dzenbot/DZNMapViewController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Ignacio Romero Z." => "iromero@dzen.cl" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/dzenbot/DZNMapViewController.git", :tag => "v0.0.3" }
  s.source_files  = 'Classes', 'Source/**/*.{h,m}'
  s.framework  = 'MapKit'
  s.requires_arc = true
end

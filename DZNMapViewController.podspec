Pod::Spec.new do |s|
  s.name         = "DZNMapViewController"
  s.version      = "1.0"
  s.summary      = "A map view controller with the ability to easy display annotations and export options."
  s.homepage     = "https://github.com/dzenbot/DZNMapViewController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Ignacio Romero Z." => "iromero@dzen.cl" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/dzenbot/DZNMapViewController.git", :tag => "v#{s.version}" }
  s.source_files  = 'Classes', 'Source/**/*.{h,m}'
  s.framework  = 'MapKit'
  s.dependency 'DZNCategories/MapKit', '~> 1.1'
  s.requires_arc = true
end

Pod::Spec.new do |s|
  s.name             = 'SCTiledImage'
  s.version          = '0.2.0'
  s.summary          = 'Tiled Image view for iOS: display images with multiple layers of zoom / tiles'
 
  s.description      = <<-DESC
Tiled Image view for iOS: display images with multiple layers of zoom / tiles, in Swift
                       DESC
 
  s.homepage         = 'https://github.com/Siclo-Mobile/SCTiledImage'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maxime Pouwels / Siclo Mobile' => 'maxime.pouwels@siclo-mobile.com' }
  s.source           = { :git => 'https://github.com/Siclo-Mobile/SCTiledImage.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '8.0'
  s.source_files = 'SCTiledImage/SCTiledImage/*.swift'
 
end
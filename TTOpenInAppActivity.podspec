Pod::Spec.new do |s|
  s.name             = 'TTOpenInAppActivity'
  s.version          = '1.2'
  s.ios.deployment_target = '8.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'TTOpenInAppActivity is a UIActivity subclass that provides an "Open In ..." action to a UIActivityViewController.'
  s.description      = 'TTOpenInAppActivity is a UIActivity subclass that provides an "Open In ..." action to a UIActivityViewController. TTOpenInAppActivity uses an UIDocumentInteractionController to present all Apps than can handle the document specified by the activity item. Supported item types are NSURL instances that point to local files and UIImage instances.'
  s.homepage         = 'https://github.com/honkmaster/TTOpenInAppActivity'
  s.authors          = { 'Tobias Tiemerding' => 'tobias@tiemerding.com' }
  s.source           = { :git => 'https://github.com/honkmaster/TTOpenInAppActivity.git', :tag => s.version.to_s }
  s.source_files     = 'TTOpenInAppActivity/*.{h,m}'
  s.resources = 'TTOpenInAppActivity/TTOpenInAppActivity.bundle'
  s.frameworks       = 'UIKit', 'MobileCoreServices', 'ImageIO', 'Foundation'
  s.requires_arc     = true
end

Pod::Spec.new do |spec|
  spec.name            = 'CMHUD'
  spec.version         = '0.2.0'
  spec.license         = 'MIT'
  spec.authors         = { 'incetro' => 'incetro@ya.ru' }
  spec.homepage        = "https://github.com/Incetro/CMHUD.git"
  spec.summary         = 'A Simple HUD for iOS 12 and up'
  spec.platform        = :ios, "12.0"
  spec.swift_version   = '5.3'
  spec.source          = { git: "https://github.com/Incetro/CMHUD.git", tag: "#{spec.version}" }
  spec.source_files    = "Sources/CMHUD/**/*.{h,swift}"
  spec.resources       = 'Sources/CMHUD/**/*.xcassets'
  spec.dependency "swift-layout"
  spec.dependency "swifty-toast"
end
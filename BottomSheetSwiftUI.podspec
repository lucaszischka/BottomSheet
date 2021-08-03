Pod::Spec.new do |s|
  s.name             = 'BottomSheetSwiftUI'
  s.version          = '2.4.0'
  s.summary          = 'A sliding Sheet from the bottom of the Screen with 3 States build with SwiftUI.'

  s.homepage         = 'https://github.com/LucasMucGH/BottomSheet'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'Lucas Zischka' => 'spiele.lucas@gmail.com' }
  s.source           = { :git => 'https://github.com/LucasMucGH/BottomSheet.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.3'

  s.weak_frameworks = 'SwiftUI'
  s.source_files = 'Sources/BottomSheet/**/*'
end

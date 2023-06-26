Pod::Spec.new do |spec|
  spec.name                   = 'BottomSheetSwiftUI'
  spec.version                = '3.1.1'
  spec.swift_version          = '5.5'
  spec.authors                = { 'Lucas Zischka' => 'lucas_zischka@outlook.com' }
  spec.license                = { :type => 'MIT', :file => 'LICENSE.txt' }
  spec.homepage               = 'https://github.com/lucaszischka/BottomSheet'
  spec.readme                 = 'https://github.com/lucaszischka/BottomSheet/blob/main/README.md'
  spec.changelog              = 'https://github.com/lucaszischka/BottomSheet/blob/main/CHANGELOG.md'
  spec.source                 = { :git => 'https://github.com/lucaszischka/BottomSheet.git',
                                  :tag => spec.version.to_s }
  spec.summary                = 'A sliding sheet from the bottom of the screen with custom states build with SwiftUI.'
  spec.screenshots            = [ 'https://user-images.githubusercontent.com/63545066/132514316-c0d723c6-37fc-4104-b04c-6cf7bbcb0899.gif',
                                  'https://user-images.githubusercontent.com/63545066/132514347-57c5397b-ec03-4716-8e01-4e693082e844.gif',
                                  'https://user-images.githubusercontent.com/63545066/132514283-b14b2977-c5d1-4b49-96b1-19995cd5a41f.gif' ]
  
  spec.ios.deployment_target  = '13.0'
  spec.osx.deployment_target  = '10.15'
  
  spec.source_files           = 'Sources/BottomSheet/**/*.swift'
  spec.resource_bundle        = { 'BottomSheet_BottomSheet' => 'Sources/BottomSheet/**/*.xcassets' }
  
end

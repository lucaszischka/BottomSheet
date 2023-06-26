BottomSheet Changelog
==================

#### v3.1.1
- Fix #101 (thx @grandsir)
- Fix #97 (#130)
- Fix #119 (#120)
- Fix #106

#### v3.1.0
- Added the `.enableAccountingForKeyboardHeight(Bool)` modifier #97
- Added the `.enableFloatingIPadSheet(Bool)` modifier
- Added the `.sheetWidth(BottomSheetWidth)` modifier
- Fix #94

#### v3.0.2
- Added `.customThreshold(Double)` modifier #8, #88

#### v3.0.1
- Fix CocoaPods build #85
- Fix close button not shown in dark mode #86

#### v3.0.0
- Recoded the project
- Added iPhone landscape support
- Added iPad support
- Added MacOS support
- Changed from options to view modifiers
- Cleaned up the code (swiftLint and splitting it up)
- Added dynamic size support
- Added onDismiss modifier
- Added dragIndicatorAction modifier
- Added dragPositionSwitchAction modifier
- Added dragGesture listener
- Changed customBackground to not rely on AnyView
- Fixed onAppear only called once #65

#### v2.8.0
- Add `disableBottomSafeAreaInsets` option #63
- Add `disableFlickThrough` option #61

#### v2.7.0
- Fix drag indicator not draggable #45
- Fix content not responding to tap gestures #51
- Reworked `.appleScrollBehavior` to fix #46, #47 (also closes #53)
- Redo explicit animation #59, #55

#### v2.6.0
- Fix critical bug with `.appleScrollBehavior` #40
- Update code-style
- Remove not used file
- Update Readme
- Renamed tapToDissmiss option tapToDismiss #43

#### v2.5.0
- Update Copyright
- Update swift-tools-version
- Update deprecated code (real fix for #19, replaces #20)
- Add `.absolutePositionValue` option #37
- Add `BottomSheetPositionAbsolute`
- Use explicit animations #31
- Hide examples in ReadMe
- Update and fix `.appleScrollBehavior` #37
- Code clean up

#### v2.4.0
- Add option to enable shadow
- Add pod install

#### v2.3.0
- Fix compile for iOS 15 and Xcode 13 #19 #20
- Add possibility to change the blur effect
- Add possibility to change the corner radius

#### v2.2.0
- Add background option
- Updated examples
- File clean up

#### v2.1.0
- Add animation option (thx @deermichel)
- Add appleScrollBehavior option
- Add allowContentDrag option
- Clean up code
- Update Readme

#### v2.0.0
- Implementation of the "options" system
- Add noDragIndicator option
- Add swipeToDismiss option
- Add tapToDissmiss option
- Add backgroundBlur option
- Add dragIndicatorColor(Color) option
- Splitting the code in different files for better clarity (ViewExtension)
- Reorganised Files
- Design fixes
- Update Documentation accordingly

#### v1.0.7
- Added flick through feature
- Fixed drag indicator button not working issue #2 (thx @dbarsamian)
- Improved Preview (thx @dbarsamian)
- Plenty README.md updates
- Fixed Dependencies
- Custom States feature #4, #5
- Extended SearchBar support

#### v1.0.6
- Updated .bottom BottomSheetPosition to mimic Apple Maps

#### v1.0.5
- Made the BottomSheet easier to drag
- Updated .top BottomSheetPosition to mimic Apple Maps
- Search Bar enhancements
- Fixed .bottom BottomSheetPosition #1
- Added Bottom Padding to the Title

#### v1.0.4
- Updated Transitions
- Design updates

#### v1.0.3
- New Animation

#### v1.0.2
- Added Access control levels

#### v1.0.1
- Fix Animation
- Readme Updates

#### v1.0.0
- Initial Release

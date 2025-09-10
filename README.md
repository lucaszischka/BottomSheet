# BottomSheet

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![GitHub version](https://img.shields.io/github/v/release/lucaszischka/BottomSheet?sort=semver)](https://github.com/lucaszischka/BottomSheet/releases)
[![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-brightgreen)](http://cocoapods.org/)
[![CocoaPods version](https://img.shields.io/cocoapods/v/BottomSheetSwiftUI.svg)](https://cocoapods.org/pods/BottomSheetSwiftUI)
[![License](https://img.shields.io/github/license/lucaszischka/BottomSheet)](https://github.com/lucaszischka/BottomSheet/blob/main/LICENSE.txt)
[![Issues](https://img.shields.io/github/issues/lucaszischka/BottomSheet)](https://github.com/lucaszischka/BottomSheet/issues)

A sliding sheet from the bottom of the screen with custom states build with SwiftUI.

# Version 3 is out now!
Please look [here](https://github.com/lucaszischka/BottomSheet/pull/79) and read the README for more information on the changes.

## Why

There have been many different attempts to recreate the BottomSheet from Apple Maps, Shortcuts and Apple Music, because Apple unfortunately does not provide it in their SDK.
(*Update: It was more or less added in iOS 16*)

However, most previous attempts share a common problem: The **height does not change** in the different states. Thus, the BottomSheet is always the same size (e.g. 800px) and thus remains 800px, even if you only see e.g. 400px - the rest is **inaccessible** unless you pull the BottomSheet up to the very top.

There are also many implementations out there that **only have 2 states** - **not 3** like e.g. Apple Maps.

### Features
- Very **easy to use**
- Build in **header/title** (see [Parameters](#Parameters))
- Many view modifiers for **customisation** (see [Modifiers](#Modifiers))
- Fully customisable States (**any number of states at any height**) (see [BottomSheetPosition](#BottomSheetPosition))
- States can have the height of their content, absolute pixel values or percentages of the screen height (see [BottomSheetPosition](#BottomSheetPosition))
- Support for **SearchBar** in the header
- It works with `ScrollView`, `List` and **every** other view
- Can hide the content when in `...Bottom` position like Apple does
- Imbedded `.appleScrollBehaviour()` modifier, to replicate Apple's ScrollView behaviour
- Completely animated
- And much more...

## Requirements 

- iOS 13, macCatalyst 13, macOS 10.15
- Swift 5.5
- Xcode 12

## Installation

### Swift Package Manager

The preferred way of installing BottomSheet is via the [Swift Package Manager](https://swift.org/package-manager/).

>Xcode 11 integrates with libSwiftPM to provide support for iOS, watchOS, and tvOS platforms.

1. In Xcode, open your project and navigate to **File** → **Add Packages**
2. Paste the repository URL (`https://github.com/lucaszischka/BottomSheet`) and click **Next**.
3. For **Rules**, select **Up to Next Major Version**.
4. Click **Add Package**.

### CocoaPods

BottomSheet is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'BottomSheetSwiftUI'
```

Now run `pod install` in the Terminal to install this dependency. 

## Usage

**WARNING:**
This is Sample Code for visualisation where and how to use, without a working initializer. Please see [Examples](#Examples) for working code.

BottomSheet is similar to the built-in Sheet:

```swift
struct ContentView: View {

    @State var bottomSheetPosition: BottomSheetPosition = .middle //1
    
    var body: some View {
    
        Map() //2
            .bottomSheet() //3
    }
}
```

`//1` The current State of the BottomSheet.
- For more information about the possible positions see [BottomSheetPosition](#BottomSheetPosition).
- If you don't want the BottomSheet to be drag-able and the state to be switchable, you can use the `.isResizable(false)` modifier.

`//2` The view which the BottomSheet overlays.
- **Important:** If you want to overlay a `TabBar` or a `NavigationView`, you need to add the BottomSheet on a higher level.

`//3` This is how you add the BottomSheet - easy right?

## Parameters

### Title as Header Content

```swift
.bottomSheet(
    bottomSheetPosition: Binding<BottomSheetPosition>,
    switchablePositions: [BottomSheetPosition],
    title: String?,
    content: () -> MContent
)
```

`bottomSheetPosition`: A binding that holds the current position/state of the BottomSheet.
- If you don't want the BottomSheet to be drag-able and the state to be switchable, you can use the `.isResizable(false)` modifier.
- For more information about the possible positions see [BottomSheetPosition](#BottomSheetPosition).

`switchablePositions`: An array that contains the positions/states of the BottomSheet.
- Only the positions/states contained in the array can be switched into (via tapping the drag indicator or swiping the BottomSheet).
- For more information about the possible positions see [BottomSheetPosition](#BottomSheetPosition).

`title`: A `String` that is displayed as title.
- You can use a view that is used as header content instead.

`content`: A view that is used as main content for the BottomSheet.

### Custom Header Content

```swift
.bottomSheet(
    bottomSheetPosition: Binding<BottomSheetPosition>,
    switchablePositions: [BottomSheetPosition],
    headerContent: () -> HContent?,
    mainContent: () -> MContent
)
```

`bottomSheetPosition`: A binding that holds the current position/state of the BottomSheet.
- If you don't want the BottomSheet to be drag-able and the state to be switchable, you can use the `.isResizable(false)` modifier.
- For more information about the possible positions see [BottomSheetPosition](#BottomSheetPosition).

`switchablePositions`: An array that contains the positions/states of the BottomSheet.
- Only the positions/states contained in the array can be switched into (via tapping the drag indicator or swiping the BottomSheet).
- For more information about the possible positions see [BottomSheetPosition](#BottomSheetPosition).

`headerContent`: A view that is used as header content for the BottomSheet.
- You can use a `String` that is displayed as title instead.

`mainContent`: A view that is used as main content for the BottomSheet.

## Modifiers

The ViewModifiers are used to customise the look and feel of the BottomSheet.

`.enableAccountingForKeyboardHeight(Bool)`: Adds padding to the bottom of the main content when the keyboard appears so all of the main content is visible.
- If the height of the sheet is smaller than the height of the keyboard, this modifier will not make the content visible.
- This modifier is not available on Mac, because it would not make sense there.

`.enableAppleScrollBehavior(Bool)`: Packs the mainContent into a ScrollView.
- Behaviour on the iPhone:
  - The ScrollView is only enabled (scrollable) when the BottomSheet is in a `...Top` position.
  - If the offset of the ScrollView becomes less than or equal to 0, the BottomSheet is pulled down instead of scrolling.
  - In every other position the BottomSheet will be dragged instead
- This behaviour is not active on Mac and iPad, because it would not make sense there.
- Please note, that this feature has sometimes weird flickering, when the content of the ScrollView is smaller than itself. If you have experience with UIKit and UIScrollViews, you are welcome to open a pull request to fix this.

`.enableBackgroundBlur(Bool)`: Adds a fullscreen blur layer below the BottomSheet.
- The opacity of the layer is proportional to the height of the BottomSheet.
- The material can be changed using the `.backgroundBlurMaterial()` modifier.
    
`.backgroundBlurMaterial(VisualEffect)`: Changes the material of the blur layer.
- Changing the material does not affect whether the blur layer is shown.
- To toggle the blur layer please use the `.enableBackgroundBlur()` modifier.

`.showCloseButton(Bool)`: Adds a close button to the headerContent on the trailing side.
- To perform a custom action when the BottomSheet is closed (not only via the close button), please use the `.onDismiss()` option.

`.enableContentDrag(Bool)`: Makes it possible to resize the BottomSheet by dragging the mainContent.
- Due to imitations in the SwiftUI framework, this option has no effect or even makes the BottomSheet glitch if the mainContent is packed into a ScrollView or a List.

`.customAnimation(Animation?)`: Applies the given animation to the BottomSheet when any value changes.

`.customBackground(...)`: Changes the background of the BottomSheet.
- This works exactly like the native SwiftUI `.background(...)` modifier.
- Using offset or shadow may break the hiding transition.

`.onDragChanged((DragGesture.Value) -> Void)`: Adds an action to perform when the gesture’s value changes.

`.onDragEnded((DragGesture.Value))`: Adds an action to perform when the gesture ends.

`.dragPositionSwitchAction((GeometryProxy, DragGesture.Value) -> Void)`: Replaces the action that will be performed when the user drags the sheet down.
- The `GeometryProxy` and `DragGesture.Value` parameter can be used for calculations.
- You need to switch the positions, account for the reversed drag direction on iPad and Mac and dismiss the keyboard yourself.
- Also the `swipeToDismiss` and `flickThrough` features are triggered via this method. By replacing it, you will need to handle both yourself.
- The `GeometryProxy`'s height contains the bottom safe area inserts on iPhone.
- The `GeometryProxy`'s height contains the top safe area inserts on iPad and Mac.

`.showDragIndicator(Bool)`: Adds a drag indicator to the BottomSheet.
- On iPhone it is centered above the headerContent.
- On Mac and iPad it is centered above the mainContent,
- To change the color of the drag indicator please use the `.dragIndicatorColor()` modifier.
    
`.dragIndicatorColor(Color)`: Changes the color of the drag indicator.
- Changing the color does not affect whether the drag indicator is shown.
- To toggle the drag indicator please use the `.showDragIndicator()` modifier.

`.dragIndicatorAction((GeometryProxy) -> Void)`: Replaces the action that will be performed when the drag indicator is tapped.
- The `GeometryProxy` parameter can be used for calculations.
- You need to switch the positions and dismiss the keyboard yourself.
- The `GeometryProxy`'s height contains the bottom safe area inserts on iPhone.
- The `GeometryProxy`'s height contains the top safe area inserts on iPad and Mac.

`.enableFlickThrough(Bool)`: Makes it possible to switch directly to the top or bottom position by long swiping.

`.enableFloatingIPadSheet(Bool)`: Makes it possible to make the sheet appear like on iPhone.

`.iPadSheetAlignment(Alignment)`: Allows for different alignments of the sheet on iPad.

`.sheetSidePadding(CGFloat)`: Gives equal padding to all edges of the bottom sheet.
`.sheetSidePadding(Edge.Set, CGFloat)`: Gives padding on iPad when enableFloatingIPadSheet is disabled.

`.onDismiss(() -> Void)`: A action that will be performed when the BottomSheet is dismissed.
-  Please note that when you dismiss the BottomSheet yourself, by setting the bottomSheetPosition to .hidden, the action will not be called.

`.isResizable(Bool)`: Makes it possible to resize the BottomSheet.
- When disabled the drag indicator disappears.

`.sheetWidth(BottomSheetWidth)`: Makes it possible to configure a custom sheet width.
- Can be relative through `BottomSheetWidth.relative(x)`.
- Can be absolute through `BottomSheetWidth.absolute(x)`.
- Set to `BottomSheetWidth.platformDefault` to let the library decide the width.

`.enableSwipeToDismiss(Bool)`: Makes it possible to dismiss the BottomSheet by long swiping.

`.enableTapToDismiss(Bool)`: Makes it possible to dismiss the BottomSheet by tapping somewhere else.

`.customThreshold(Double)`: Sets a custom threshold which determines, when to trigger swipe to dismiss or flick through.
- The threshold must be positive and higher than 10% (0.1).
- Changing the threshold does not affect whether either option is enabled.
- The default threshold is 30% (0.3).


## BottomSheetPosition

The `BottomSheetPosition` enum holds all states you can switch into.
There are 3 mayor types:
- `.dynamic...`, where the height of the BottomSheet is equal to its content height
- `.relative...`, where the height of the BottomSheet is a percentage of the screen height
- `.absolute...`, where the height of the BottomSheet is a pixel value

You can combine those types as much as you want.
You can also use multiple instances of one case (for example `.relative(0.4)` and `.relative(0.6)`).

The positions/states in detail:
```swift
/// The state where the BottomSheet is hidden.
case hidden

/// The state where only the headerContent is visible.
case dynamicBottom

/// The state where the height of the BottomSheet is equal to its content size.
/// Only makes sense for views that don't take all available space (like ScrollVIew, Color, ...).
case dynamic

/// The state where the height of the BottomSheet is equal to its content size.
/// It functions as top position for appleScrollBehaviour,
/// although it doesn't make much sense to use it with dynamic.
/// Only makes sense for views that don't take all available space (like ScrollVIew, Color, ...).
case dynamicTop

/// The state where only the headerContent is visible.
/// The height of the BottomSheet is x%.
/// Only values between 0 and 1 make sense.
/// Instead of 0 please use `.hidden`.
case relativeBottom(CGFloat)

/// The state where the height of the BottomSheet is equal to x%.
/// Only values between 0 and 1 make sense.
/// Instead of 0 please use `.hidden`.
case relative(CGFloat)

/// The state where the height of the BottomSheet is equal to x%.
/// It functions as top position for appleScrollBehaviour.
/// Only values between 0 and 1 make sense.
/// Instead of 0 please use `.hidden`.
case relativeTop(CGFloat)

/// The state where only the headerContent is visible
/// The height of the BottomSheet is x.
/// Only values above 0 make sense.
/// Instead of 0 please use `.hidden`.
case absoluteBottom(CGFloat)

/// The state where the height of the BottomSheet is equal to x.
/// Only values above 0 make sense.
/// Instead of 0 please use `.hidden`.
case absolute(CGFloat)

/// The state where the height of the BottomSheet is equal to x.
/// It functions as top position for appleScrollBehaviour.
/// Only values above 0 make sense.
/// Instead of 0 please use `.hidden`.
case absoluteTop(CGFloat)
```

## Examples

**PLEASE NOTE:** When installed via Cocoapods, please keep in mind that the pod is called `BottomSheetSwiftUI` and not `BottomSheet`; so please use `import BottomSheetSwiftUI` instead.

### Book Detail View

This BottomSheet shows additional information about a book.
You can close it by swiping it away, by tapping on the background or the close button.
The drag indicator is hidden.
The content can be used for resizing the sheet.

<img src="https://user-images.githubusercontent.com/63545066/132514316-c0d723c6-37fc-4104-b04c-6cf7bbcb0899.gif" height="600" width="278">

<details>
<summary>Source Code</summary>

```swift
import SwiftUI
import BottomSheet

struct BookDetailView: View {
    @State var bottomSheetPosition: BottomSheetPosition = .absolute(325)
    
    let backgroundColors: [Color] = [Color(red: 0.2, green: 0.85, blue: 0.7), Color(red: 0.13, green: 0.55, blue: 0.45)]
    let readMoreColors: [Color] = [Color(red: 0.70, green: 0.22, blue: 0.22), Color(red: 1, green: 0.32, blue: 0.32)]
    let bookmarkColors: [Color] = [Color(red: 0.28, green: 0.28, blue: 0.53), Color(red: 0.44, green: 0.44, blue: 0.83)]
    
    var body: some View {
        //A green gradient as a background that ignores the safe area.
        LinearGradient(gradient: Gradient(colors: self.backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
        
            .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [
                .dynamicBottom,
                .absolute(325)
            ], headerContent: {
                //The name of the book as the heading and the author as the subtitle with a divider.
                VStack(alignment: .leading) {
                    Text("Wuthering Heights")
                        .font(.title).bold()
                    
                    Text("by Emily Brontë")
                        .font(.subheadline).foregroundColor(.secondary)
                    
                    Divider()
                        .padding(.trailing, -30)
                }
                .padding([.top, .leading])
            }) {
                //A short introduction to the book, with a "Read More" button and a "Bookmark" button.
                VStack(spacing: 0) {
                    Text("This tumultuous tale of life in a bleak farmhouse on the Yorkshire moors is a popular set text for GCSE and A-level English study, but away from the demands of the classroom it’s easier to enjoy its drama and intensity. Populated largely by characters whose inability to control their own emotions...")
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Button(action: {}, label: {
                            Text("Read More")
                                .padding(.horizontal)
                        })
                            .buttonStyle(BookButton(colors: self.readMoreColors)).clipShape(Capsule())
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Image(systemName: "bookmark")
                        })
                            .buttonStyle(BookButton(colors: self.bookmarkColors)).clipShape(Circle())
                    }
                    .padding(.top)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
            }
            .showDragIndicator(false)
            .enableContentDrag()
            .showCloseButton()
            .enableSwipeToDismiss()
            .enableTapToDismiss()
    }
}

//The gradient ButtonStyle.
struct BookButton: ButtonStyle {
    
    let colors: [Color]
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
```
</details>

### Word Search View

This BottomSheet shows nouns which can be filtered by searching.
It adapts the scrolling behaviour of apple, so that you can only scroll the `ScrollView` in the `.top` position (else the BottomSheet gets dragged); on iPad and Mac this behaviour is not present and a normal ScrollView is used.
The higher the BottomSheet is dragged, the more blurry the background becomes (with the BlurEffect .systemDark) to move the focus to the BottomSheet.

<img src="https://user-images.githubusercontent.com/63545066/132514347-57c5397b-ec03-4716-8e01-4e693082e844.gif" height="600" width="278">

<details>
<summary>Source Code</summary>

```swift
import SwiftUI
import BottomSheet

struct WordSearchView: View {
    
    @State var bottomSheetPosition: BottomSheetPosition = .relative(0.4)
    @State var searchText: String = ""
    
    let backgroundColors: [Color] = [Color(red: 0.28, green: 0.28, blue: 0.53), Color(red: 1, green: 0.69, blue: 0.26)]
    let words: [String] = ["birthday", "pancake", "expansion", "brick", "bushes", "coal", "calendar", "home", "pig", "bath", "reading", "cellar", "knot", "year", "ink"]
    
    var filteredWords: [String] {
        self.words.filter({ $0.contains(self.searchText.lowercased()) || self.searchText.isEmpty })
    }
    
    
    var body: some View {
        //A green gradient as a background that ignores the safe area.
        LinearGradient(gradient: Gradient(colors: self.backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
        
            .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [
                .relativeBottom(0.125),
                .relative(0.4),
                .relativeTop(0.975)
            ], headerContent: {
                //A SearchBar as headerContent.
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: self.$searchText)
                }
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(.vertical, 8)
                .padding(.horizontal, 5)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.quaternaryLabel)))
                .padding([.horizontal, .bottom])
                //When you tap the SearchBar, the BottomSheet moves to the .top position to make room for the keyboard.
                .onTapGesture {
                    self.bottomSheetPosition = .relativeTop(0.975)
                }
            }) {
                //The list of nouns that will be filtered by the searchText.
                ForEach(self.filteredWords, id: \.self) { word in
                    Text(word)
                        .font(.title)
                        .padding([.leading, .bottom])
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity)
                .animation(.easeInOut, value: self.filteredWords)
                .padding(.top)
            }
            .enableAppleScrollBehavior()
            .enableBackgroundBlur()
            .backgroundBlurMaterial(.systemDark)
    }
}
```
</details>

### Artist Songs View

This BottomSheet shows the most popular songs by an artist.
It has a custom animation and color for the drag indicator and the background, as well as it deactivates the bottom position behaviour and uses a custom corner radius and shadow.

<img src="https://user-images.githubusercontent.com/63545066/132514283-b14b2977-c5d1-4b49-96b1-19995cd5a41f.gif" height="600" width="278">

<details>
<summary>Source Code</summary>

```swift
import SwiftUI
import BottomSheet

struct ArtistSongsView: View {
    
    @State var bottomSheetPosition: BottomSheetPosition = .relative(0.4)
    
    let backgroundColors: [Color] = [Color(red: 0.17, green: 0.17, blue: 0.33), Color(red: 0.80, green: 0.38, blue: 0.2)]
    let songs: [String] = ["One Dance (feat. Wizkid & Kyla)", "God's Plan", "SICKO MODE", "In My Feelings", "Work (feat. Drake)", "Nice For What", "Hotline Bling", "Too Good (feat. Rihanna)", "Life Is Good (feat. Drake)"]
    
    var body: some View {
        //A green gradient as a background that ignores the safe area.
        LinearGradient(gradient: Gradient(colors: self.backgroundColors), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
        
            .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, switchablePositions: [
                .relative(0.125),
                .relative(0.4),
                .relativeTop(0.975)
            ], title: "Drake") {
                //The list of the most popular songs of the artist.
                ScrollView {
                    ForEach(self.songs, id: \.self) { song in
                        Text(song)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading, .bottom])
                    }
                }
            }
            .customAnimation(.linear.speed(0.4))
            .dragIndicatorColor(Color(red: 0.17, green: 0.17, blue: 0.33))
            .customBackground(
                Color.black
                    .cornerRadius(30)
                    .shadow(color: .white, radius: 10, x: 0, y: 0)
            )
            .foregroundColor(.white)
            // Adding the shadow here does not break the hiding transition, but the shadow may gets added to your other views too
            // .shadow(color: .white, radius: 10, x: 0, y: 0)
    }
}
```
</details>

## Test project
A project to test the BottomSheet can be found [here](https://github.com/lucaszischka/BottomSheetTests).
This project is used by me to test new features and to reproduce bugs, but can also be used very well as a demo project.

## Contributing

BottomSheet welcomes contributions in the form of GitHub issues and pull-requests.
Please check [the Discussions](https://github.com/lucaszischka/BottomSheet/discussions) before opening an issue or pull request.

## License

BottomSheet is available under the MIT license. See [the LICENSE file](LICENSE.txt) for more information.

## Credits

BottomSheet is a project of [@lucaszischka](https://github.com/lucaszischka).

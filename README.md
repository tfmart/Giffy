# Giffy

Giffy is a lightweight package that allows you to display animated GIF in SwiftUI views. Powered by the field-tested [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage), all your displayed animations will be very performant while beign memory efficient.

Giffy can be used to display both GIF files stored locally and from remote URLs, providing a very familiar API that will feel right at home in a SwiftUI environment

## Requirements

- iOS 14.0 or later

## Usage

### Local Files

To display an animation from a local GIF file, use the `Giffy` component:

```swift
Giffy("cat")
```

If your GIF is stored on another bundle outside your project's main bundle, you can specify the Bundle to load the animation from.

```swift
// Loads an animation from the provided bundle
LottieView("cat", bundle: DesignSystem.Bundle.main)
```

Or if you want to use the path to your GIF file, you can simply pass it as well:

```swift
// Loads a GIF file from the provided path
LottieView(path: URL(string: "path/to/cat.gif")!)
```

### Remote Files

If you want to display a GIF from the web, use the `AsyncGiffy` component. You can also setup a placeholder view to be displayed while the view is beign loaded and a view to be displayed in place in case the GIF fails to load:

```swift
let url = URL(string: "https://media.giphy.com/media/vFKqnCdLPNOKc/giphy.gif")!

AsyncGiffy(url: url) { phase in
    switch phase {
    case .loading:
        ProgressView()
    case .error:
        ErrorView
    case .success(let giffy):
        giffy
    }
}
```

## Features

Apart from displaying GIFs, you can also set an action to be executed each time an animation loops with the `.onLoop(:)` modifier:

```swift
AsyncGiffy(url: url) { phase in
    if case .sucess(let giffy) == phase {
        giffy
            .onLoop {
                print("Kitty says hi!")
            }
    }
}
```

## Installation

Currently, Giffy can be installed through Swift Package Manager

To add this package to your project, go to `File -> Swift Package Manager -> Add Package Dependency...` in Xcode's menu and paste this Github page URL on the search bar

You can also add Giffy by adding it as a dependecy on your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/tfmart/Giffy.git", .upToNextMajor(from: "1.0.0"))
],
targets: [
    .target(name: "MyProject", dependencies: ["Giffy""])
]
```

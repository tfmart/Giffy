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

![Gravação de Tela 2023-05-01 às 12 36 15](https://user-images.githubusercontent.com/23082132/235479461-8364b51a-e779-429e-a4bb-f4e0b82806ce.gif)

Or if you want to use the path to your GIF file, you can simply pass it as well:

```swift
// Loads a GIF file from the provided path
LottieView(path: URL(string: "path/to/cat.gif")!)
```

### Remote Files

If you want to display a GIF from the web, use the `AsyncGiffy` component. You can also setup a placeholder view to be displayed while the view is beign loaded and a view to be displayed in place in case the GIF fails to load:

```swift
let url = URL(string: "https://media.giphy.com/media/RrVzUOXldFe8M/giphy.gif")!

AsyncGiffy(url: url) { phase in
    switch phase {
    case .loading:
        ProgressView()
    case .error:
        Text("Failed to load GIF")
    case .success(let giffy):
        giffy
    }
}
```

![Gravação de Tela 2023-05-01 às 12 45 16](https://user-images.githubusercontent.com/23082132/235481035-89686cab-d40f-4f3c-b870-2acbe514e72a.gif)


## Features

Apart from displaying GIFs, you can also set an action to be executed each time an animation loops with the `.onLoop(:)` modifier:

```swift
@State let jumpCount = 0
VStack {
    AsyncGiffy(url: gifURL) { phase in
        switch phase {
        case .loading:
            ProgressView()
        case .error:
            Text("Failed to load GIF")
        case let .success(giffy):
            giffy
                .onLoop {
                    jumpCount += 2
                }
        }
    }
    Text("Jump count: \(jumpCount)")
}
```

![Gravação de Tela 2023-05-01 às 12 51 21](https://user-images.githubusercontent.com/23082132/235482141-0be948d6-c759-4402-8625-efdaa3f5e237.gif)


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

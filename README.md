# mapbox-ios-examples
Mapbox examples using Swift

# Getting Started

Note: In order to run the app you need CocoaPods. At the time of writing, CocoaPods 1.1 is still not released but it is required for a bunch of pods.

```
$ sudo gem install cocoapods --pre
```

Clone the repository and change directory

```
$ git clone https://github.com/rmnblm/mapbox-ios-examples
$ cd mapbox-ios-examples
```

Install all necessary packages (pods).

```
$ pod install
```

Rename the `Keys.example.plist` file to `Keys.plist` and set your Mapbox Access inside the file.

Open the project by double-clicking the `*.xcworkspace` file (not the `*.xcodeproj` file!).
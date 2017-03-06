# mapbox-ios-examples
Mapbox examples using [Swift 3](https://swift.org/) and [Mapbox iOS SDK](https://github.com/mapbox/mapbox-gl-native/tree/master/platform/ios).

> This repo serves as a base for experiments during my two semesters working on my study and Bachelor thesis with @iphilgood.

# Prerequisites

In order to run the app you need CocoaPods. At the time of writing, CocoaPods 1.1 is still not released but it is required for a bunch of pods.

```
$ sudo gem install cocoapods --pre
```

Make sure your CocoaPods version is >=1.1.0

```
$ pod --version
1.1.0.rc.2
```

# Getting Started

Clone the repository and change directory

```
$ git clone https://github.com/rmnblm/mapbox-ios-examples
$ cd mapbox-ios-examples
```

Install all necessary pods (again, please make sure that your CocoaPods version is >=1.1.0, otherwise problems may occur!)

```
$ pod install
```

**Note**: To use any of Mapbox’s tools, APIs, or SDKs, you’ll need a Mapbox **access token**. Mapbox uses access tokens to associate requests to API resources with your account. You can find all your access tokens, create new ones, or delete existing ones on your [API Access Tokens page](https://www.mapbox.com/studio/account/tokens/). If you don't have a Mapbox access token, [sign up](https://www.mapbox.com/studio/signup/) on Mapbox.

Rename the `Keys.example.plist` file to `Keys.plist`, open the file and replace **YOUR API KEY HERE** with your private Mapbox access token. 

Open the project by double-clicking the `*.xcworkspace` file (not the `*.xcodeproj` file!).

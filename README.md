# mapbox-ios-examples
Mapbox examples using Swift

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

Install all necessary packages (pods).

```
$ pod install
```

Rename the `Keys.example.plist` file to `Keys.plist`, open the file and set your private Mapbox Access Token.

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>MAPBOX_ACCESS_TOKEN</key>
	<string>YOUR API KEY HERE</string>
</dict>
</plist>
```

Open the project by double-clicking the `*.xcworkspace` file (not the `*.xcodeproj` file!).
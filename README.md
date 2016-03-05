# IMRemoteImageSize

[![CI Status](http://img.shields.io/travis/IMcD23/IMRemoteImageSize.svg?style=flat)](https://travis-ci.org/IMcD23/IMRemoteImageSize)
[![Version](https://img.shields.io/cocoapods/v/IMRemoteImageSize.svg?style=flat)](http://cocoapods.org/pods/IMRemoteImageSize)
[![License](https://img.shields.io/cocoapods/l/IMRemoteImageSize.svg?style=flat)](http://cocoapods.org/pods/IMRemoteImageSize)
[![Platform](https://img.shields.io/cocoapods/p/IMRemoteImageSize.svg?style=flat)](http://cocoapods.org/pods/IMRemoteImageSize)

IMRemoteImageSize is a simple library for iOS that allows you to retrieve the dimensions of a remote image (JPG, GIF, PNG or BMP), without having to download the image. It retrieves the first few bytes of the file and then stops downloading.

## Usage

IMRemoteImageSize runs as an extension of UIImage. To retrieve the size of a remote image, all you have to do is the following:

At the top of your Swift file, add `import IMRemoteImageSize`, then add this code to get the size of an image:

    let url = NSURL(...) // image url
    UIImage.getImageSize(url, completion: { (size) -> Void in
        print("Got size of image: \(url): \(size)")
    })

If the size was unable to be determined by the library, it will return CGSizeZero.

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Written in Swift 2.0, so it requires at least Xcode 7. Compatible with iOS 8.3 and above.

## Installation

IMRemoteImageSize is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IMRemoteImageSize"
```

## Author

Ian McDowell, mcdow.ian@gmail.com

## License

IMRemoteImageSize is available under the MIT license. See the LICENSE file for more info.

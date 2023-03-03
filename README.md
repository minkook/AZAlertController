# AZAlertController

[![CI Status](https://img.shields.io/travis/minkook/AZAlertController.svg?style=flat)](https://travis-ci.org/minkook/AZAlertController)
[![Version](https://img.shields.io/cocoapods/v/AZAlertController.svg?style=flat)](https://cocoapods.org/pods/AZAlertController)
[![License](https://img.shields.io/cocoapods/l/AZAlertController.svg?style=flat)](https://cocoapods.org/pods/AZAlertController)
[![Platform](https://img.shields.io/cocoapods/p/AZAlertController.svg?style=flat)](https://cocoapods.org/pods/AZAlertController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AZAlertController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AZAlertController'
```

## Usage

1. Default Show Alert

```swift
UIAlertController.az(message: "Test Alert")
    .show(self)
```

or

```swift    
UIAlertController.az(message: "Test Alert")
    .show()
```

- If there is no value for the show function parameter, it is automatically shown in the topmost view controller.


2. Default Show Cancel Alert

```swift
UIAlertController.az(message: "Test Alert")
    .addCancelAction()
    .show(self)
```


3. Custom Alert -- (Apply, Cancel) + Action Closure

```swift
UIAlertController.az(title: "Alert", message: "Test Alert")
    .addCancelAction()
    .addCustomAction("Apply") { _ in
        print("touch apply~~")
    }
    .show(self)
```


4. Custom ActionSheet Style 

```swift
UIAlertController.az(message: "Test Alert", preferredStyle: .actionSheet)
    .addCancelAction()
    .addCustomActions([
        .init(title: "aa") { _ in print("aa")},
        .init(title: "bb") { _ in print("bb")},
        .init(title: "cc") { _ in print("cc")}
    ])
    .show(self)
```

## Author

minkook, manguks@gmail.com

## License

AZAlertController is available under the MIT license. See the LICENSE file for more info.

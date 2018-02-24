# TTOpenInAppActivity

`TTOpenInAppActivity` is a `UIActivity` subclass that provides an "Open In ..." action to a `UIActivityViewController`. `TTOpenInAppActivity` uses an UIDocumentInteractionController to present all Apps that can handle the document specified with by the activity items.

<img src=https://github.com/honkmaster/TTOpenInAppActivity/blob/master/Screenshot.png width="414px" />

## Used In

- [Stud.IP Mobile by Tobias Tiemerding](http://www.studip-mobile.de)
- [PenUltimate by Evernote](https://itunes.apple.com/app/penultimate/id354098826?mt=8)
- [Pinpoint by Lickability (previously Bugshot by Marco Arment)](https://itunes.apple.com/de/app/bugshot/id669858907?mt=8)
- [WriteDown - a Markdown text editor with syncing support by Nguyen Vinh](https://itunes.apple.com/app/id670733152)
- [Trail Maker](https://itunes.apple.com/de/app/trail-maker/id651198801?l=en&mt=8)
- [Syncspace by The Infinite Kind](http://infinitekind.com/syncspace)
- [SketchTo by The Infinite Kind](http://infinitekind.com/sketchto)
- [Calex by Martin Stemmle](http://calexapp.com)
- [deGeo by MobileInfoCenter](http://mobileinfocenter.com/degeo/)
- [Lyynifier by Lyyn](http://www.lyyn.com/lyynifier)
- [KyBook by Kolyvan](http://kolyvan.com/kybook/index.html)
- [Photo OCR](https://itunes.apple.com/app/photo-ocr/id640974771?mt=8)
- [My Wonderful Days](http://itunes.apple.com/app/id434356065?mt=8)
- [Name2Brain](https://itunes.apple.com/app/name2brain/id850789077?mt=8)
- Please tell me if you use TTOpenInAppActivity in your App (just submit it as an [issue](https://github.com/honkmaster/TTOpenInAppActivity/issues))! 

## Requirements

- As `UIActivity` is iOS 6 only, so is the subclass.
- This project uses ARC. If you want to use it in a non ARC project, you must add the `-fobjc-arc` compiler flag to TTOpenInAppActivity.m in Target Settings > Build Phases > Compile Sources.

## Installation

### From CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like `TTOpenInAppActivity` in your projects. First, add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
pod 'TTOpenInAppActivity'
```

If you want to use the latest features of `TTOpenInAppActivity` use normal external source dependencies.

```ruby
pod 'TTOpenInAppActivity', :git => 'https://github.com/honkmaster/TTOpenInAppActivity.git'
```

### Manually

* Add the `TTOpenInAppActivity` subfolder to your project. 
* Add the required frameworks `UIKit`, `ImageIO` and `MobileCoreServices` to your project.

## Usage.

```objectivec
NSURL *URL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"empty" ofType:@"pdf"]];
TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:((UIButton *)sender).frame];
UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
    
activityViewController.popoverPresentationController.sourceView = self.view;
activityViewController.popoverPresentationController.sourceRect = ((UIButton *)sender).frame;
    
[self presentViewController:activityViewController animated:YES completion:NULL];
```

## Contributers (Thank You!)

- [Vincent Tourraine](https://github.com/vtourraine) 
- [Jesse Ditson](https://github.com/jesseditson)

## License


`TTOpenInAppActivity` is distributed under the terms and conditions of the [MIT license](https://github.com/honkmaster/TTOpenInAppActivity/blob/master/LICENSE).



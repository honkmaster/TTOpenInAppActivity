# TTOpenInAppActivity

`TTOpenInAppActivity` is a `UIActivity` subclass that provides an "Open In ..." action to a `UIActivityViewController`. `TTOpenInAppActivity` uses an UIDocumentInteractionController to present all Apps than can handle the document specified with a file URL.

![TTOpenInActivity screenshot](http://i49.tinypic.com/1pf29t.png "TTOpenInActivity screenshot")

## Requirements

- As `UIActivity` is iOS 6 only, so is the subclass.
- This project uses ARC. If you want to use it in a non ARC project, you must add the `-fobjc-arc` compiler flag to TTOpenInAppActivity.m in Target Settings > Build Phases > Compile Sources.

## Installation

Add the `TTOpenInAppActivity` subfolder to your project. There are no required libraries other than `UIKit`.

## Usage.

- We need do keep an referemce to the superview (UIActionSheet). In this way we dismiss the UIActionSheet ans instead display the UIDocumentInterActionController.
- `TTOpenInAppActivity` needs to be initalized with the current view (iPhone & iPad) and a) a CGRect or b) a UIBarButtonItem (both only for iPad) from where it can present the UIDocumentInterActionController.

```objectivec
NSURL *URL = [NSURL fileURLWithPath:filePath];
TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:[self.tableView rectForRowAtIndexPath:selectedIndexPath]];
UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
// Store reference to superview (UIActionSheet) to allow dismissal
openInAppActivity.superViewController = activityViewController;
```
## License

Copyright (c) 2012-2013 Tobias Tiemerding

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



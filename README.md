# TTOpenInActivity

`TTOpenInActivity` is a `UIActivity` subclass that provides an "Open In ..." action to a `UIActivityViewController`. `TTOpenInActivity` uses an UIDocumentInteractionController to present all Apps than can handle the document specified with a file URL.

![TTOpenInActivity screenshot](http://i49.tinypic.com/1pf29t.png "TTOpenInActivity screenshot")

## Requirements

- As `UIActivity` is iOS 6 only, so is the subclass.
- This project uses ARC. If you want to use it in a non ARC project, you must add the `-fobjc-arc` compiler flag to TTOpenInActivity.m in Target Settings > Build Phases > Compile Sources.

## Installation

Add the `TTOpenInActivity` subfolder to your project. There are no required libraries other than `UIKit`.

## Usage.

- We need do keep an referemce to the superview (UIActionSheet). In this way we dismiss the UIActionSheet ans instead display the UIDocumentInterActionController.
- `TTOpenInActivity` needs to be initalized with the current view and a) a CGRect (iPhone) or b) a UIBarButtonItem (iPad) from where it can present the UIDocumentInterActionController.

```objectivec
NSURL *url = [NSURL fileURLWithPath:filePath];
TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:[self.tableView rectForRowAtIndexPath:selectedIndexPath]];
UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
// Store reference to superview (UIActionSheet) to allow dismissal
openInAppActivity.superViewController = activityViewController;
```




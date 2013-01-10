//
//  ViewController.m
//  ExampleTTOpenInAppActivity
//
//  Created by Tobias Tiemerding on 1/10/13.
//  Copyright (c) 2013 Tobias Tiemerding. All rights reserved.
//

#import "ViewController.h"
#import "TTOpenInAppActivity.h"

@interface ViewController ()

@property (nonatomic, strong) UIPopoverController *activityPopoverController;

- (IBAction)openIn:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openIn:(id)sender
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"empty" ofType:@"pdf"];  
    NSURL *URL = [NSURL fileURLWithPath:filePath];
    TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:((UIButton *)sender).frame];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        // Store reference to superview (UIActionSheet) to allow dismissal
        openInAppActivity.superViewController = activityViewController;
        // Show UIActivityViewController 
        [self presentViewController:activityViewController animated:YES completion:NULL];
    } else {
        // Create pop up
        self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        // Store reference to superview (UIPopoverController) to allow dismissal
        openInAppActivity.superViewController = self.activityPopoverController;
        // Show UIActivityViewController in popup
        [self.activityPopoverController presentPopoverFromRect:((UIButton *)sender).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end

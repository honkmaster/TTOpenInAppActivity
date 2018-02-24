//
//  ViewController.m
//
//  Copyright (c) 2012-2018 Tobias Tiemerding
//

#import "ViewController.h"
#import "TTOpenInAppActivity.h"

@interface ViewController ()

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
    
    TTOpenInAppActivity *openInAppActivity;
    
    if ([sender isKindOfClass:[UIButton class]]){
        openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:((UIButton *)sender).frame];
    } else {
        openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andBarButtonItem:sender];
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:@[openInAppActivity]];
    activityViewController.popoverPresentationController.sourceView = self.view;
    if ([sender isKindOfClass:[UIButton class]]){
        activityViewController.popoverPresentationController.sourceRect = ((UIButton *)sender).frame;
    } else {
        activityViewController.popoverPresentationController.barButtonItem = sender;
    }
    
    // Show UIActivityViewController
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

@end

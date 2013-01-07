//
//  TTOpenInAppActivity.m
//
//  Created by Tobias Tiemerding on 12/25/12.
//  Copyright (c) 2012 TwoT App Development. All rights reserved.
//

#import "TTOpenInAppActivity.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI

@interface OpenInAppActivity ()
    // Private attributes
    @property (nonatomic, strong) NSURL *fileURL;
    @property (atomic) CGRect rect;
    @property (nonatomic, strong) UIBarButtonItem *barButtonItem;
    @property (nonatomic, strong) UIView *superView;

    // Private methods
    - (NSString *)UTIForURL:(NSURL *)url;

@end

@implementation TTOpenInAppActivity
@synthesize rect = _rect;
@synthesize superView = _superView;
@synthesize superViewController = _superViewController;

- (id)initWithView:(UIView *)view andRect:(CGRect)rect
{
    if(self =[super init]){
        self.superView = view;
        self.rect = rect;
    }
    return self;
}

- (id)initWithView:(UIView *)view andBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if(self =[super init]){
        self.superView = view;
        self.barButtonItem = barButtonItem;
    }
    return self;
}

- (NSString *)activityType
{
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle
{
	return NSLocalizedString(@"Open in ...", @"Open in ...");
}

- (UIImage *)activityImage
{
	return [UIImage imageNamed:@"TTOpenInAppActivity"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			return YES;
		}
	}
	
	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			self.fileURL = activityItem;
		}
	}
}

- (void)performActivity
{
    if(!self.superViewController){
        [self activityDidFinish:YES];
        return;
    }
    
    // Dismiss activity view
    [self.superViewController dismissViewControllerAnimated:YES completion:^(void){
        [self activityDidFinish:YES];
        // Open "Open in"-menu
        UIDocumentInteractionController *docController = [UIDocumentInteractionController interactionControllerWithURL:self.fileURL];
        docController.UTI = [self UTIForURL:self.fileURL];
        BOOL sucess;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            sucess = [docController presentOpenInMenuFromRect:CGRectZero inView:self.superView animated:YES];
        } else {
            if(self.barButtonItem)
                sucess = [docController presentOpenInMenuFromBarButtonItem:self.barButtonItem animated:YES];
            else
                sucess = [docController presentOpenInMenuFromRect:self.rect inView:self.superView animated:YES];
        }
        
        if(!sucess){
            // There is no app to handle this file
            NSString *deviceType = [UIDevice currentDevice].localizedModel;
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Your %@ doesn't seem to have any other Apps installed that can open this document.",
                                                                             @"Your %@ doesn't seem to have any other Apps installed that can open this document."), deviceType];
            
            // Display alert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No suitable Apps installed", @"No suitable App installed")
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - Helper
- (NSString *)UTIForURL:(NSURL *)url
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
    return (__bridge NSString *)UTI;
}

@end


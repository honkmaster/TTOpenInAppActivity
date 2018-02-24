//
//  TTOpenInAppActivity.m
//
//  Copyright (c) 2012-2018 Tobias Tiemerding
//

#import "TTOpenInAppActivity.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI
#import <ImageIO/ImageIO.h>

@interface TTOpenInAppActivity ()

// Private attributes
@property (nonatomic, strong) NSArray *fileURLs;
@property (atomic) CGRect rect;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

// Private methods
- (NSString *)UTIForURL:(NSURL *)url;
- (void)openDocumentInteractionControllerWithFileURL:(NSURL *)fileURL;
- (void)openSelectFileAlertController;

@end

@implementation TTOpenInAppActivity
@synthesize rect = _rect;
@synthesize superView = _superView;

+ (NSBundle *)bundle
{
    NSBundle *bundle = [NSBundle bundleForClass:[TTOpenInAppActivity class]];
    NSURL *url = [bundle URLForResource:@"TTOpenInAppActivity" withExtension:@"bundle"];
    
    if (url) {
        // TTOpenInAppActivity.bundle will likely only exist when used via CocoaPods
        bundle = [NSBundle bundleWithURL:url];
    } else {
        bundle = [NSBundle mainBundle];
    }
    
    return bundle;
}

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
    return NSLocalizedStringFromTableInBundle(@"Open in …", @"TTOpenInAppActivityLocalizable", [TTOpenInAppActivity bundle], nil);
}

- (UIImage *)activityImage
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        return [UIImage imageWithContentsOfFile:[[TTOpenInAppActivity bundle] pathForResource:@"TTOpenInAppActivity" ofType:@"png"]];
    } else {
        return [UIImage imageWithContentsOfFile:[[TTOpenInAppActivity bundle] pathForResource:@"TTOpenInAppActivity_iPad" ofType:@"png"]];
    }
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSUInteger count = 0;
    
    for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [(NSURL *)activityItem isFileURL]) {
			count++;
		}
        if ([activityItem isKindOfClass:[UIImage class]]) {
            count++;
        }
	}
	
	return (count >= 1);
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSMutableArray *fileURLs = [NSMutableArray array];
    
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [(NSURL *)activityItem isFileURL]) {
            [fileURLs addObject:activityItem];
		}
        if ([activityItem isKindOfClass:[UIImage class]]) {
            NSURL *imageURL = [self localFileURLForImage:activityItem];
            [fileURLs addObject:imageURL];
        }
	}
    
    self.fileURLs = [fileURLs copy];
}

- (void)performActivity
{
    if (self.fileURLs.count > 1) {
        [self openSelectFileAlertController];
    }
    else {
        // Open UIDocumentInteractionController
        [self openDocumentInteractionControllerWithFileURL:self.fileURLs.lastObject];
    }
}

#pragma mark - Helper
- (NSString *)UTIForURL:(NSURL *)url
{
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
    return (NSString *)CFBridgingRelease(UTI) ;
}

- (void)openDocumentInteractionControllerWithFileURL:(NSURL *)fileURL
{
    if (!fileURL) {
        // Return NO because there was no valid fileURL.
        [self activityDidFinish:NO];
        return;
    }
    
    // Open "Open in"-menu
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentInteractionController.delegate = self;
    self.documentInteractionController.UTI = [self UTIForURL:fileURL];
    BOOL sucess; // Sucess is true if it was possible to open the controller and there are apps available
    
    if(self.barButtonItem){
        sucess = [self.documentInteractionController presentOpenInMenuFromBarButtonItem:self.barButtonItem animated:YES];
    } else if (CGRectIsEmpty(self.rect) == false){
        sucess = [self.documentInteractionController presentOpenInMenuFromRect:self.rect inView:self.superView animated:YES];
    } else {
        sucess = [self.documentInteractionController presentOpenInMenuFromRect:self.rect inView:self.superView animated:YES];
    }
    
    if(!sucess){
        // There is no app to handle this file
        NSString *deviceType = [UIDevice currentDevice].localizedModel;
        NSString *message = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Your %@ doesn't seem to have any other Apps installed that can open this document.", @"TTOpenInAppActivityLocalizable", [TTOpenInAppActivity bundle], nil), deviceType];
        NSString *title = NSLocalizedStringFromTableInBundle(@"No suitable Apps installed", @"TTOpenInAppActivityLocalizable", [TTOpenInAppActivity bundle], nil);
        
        // Display alert
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        title = NSLocalizedStringFromTableInBundle(@"OK", @"TTOpenInAppActivityLocalizable", [TTOpenInAppActivity bundle], nil);
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        
        UIViewController *topController = UIApplication.sharedApplication.delegate.window.rootViewController;
        while (topController.presentedViewController){
            topController = topController.presentedViewController;
        }
        [topController presentViewController:alertController animated:YES completion:nil];
        
        // Inform app that the activity has finished
        // Return NO because the service was canceled and did not finish because of an error.
        // http://developer.apple.com/library/ios/#documentation/uikit/reference/UIActivity_Class/Reference/Reference.html
        [self activityDidFinish:NO];
    }
}

- (void)dismissDocumentInteractionControllerAnimated:(BOOL)animated
{
    // Hide menu
    [self.documentInteractionController dismissMenuAnimated:animated];
    
    // Inform app that the activity has finished
    // Return NO because the service was canceled.
    [self activityDidFinish:NO];
}

- (void)openSelectFileAlertController
{
    NSString *title = NSLocalizedStringFromTableInBundle(@"Select a file", @"TTOpenInAppActivityLocalizable", [TTOpenInAppActivity bundle], nil);
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSURL *fileURL in self.fileURLs) {
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:fileURL.lastPathComponent style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self openDocumentInteractionControllerWithFileURL:fileURL];
        }];
        [alertController addAction:alertAction];
    }
    
    title = NSLocalizedStringFromTableInBundle(@"Cancel", @"TTOpenInAppActivityLocalizable", [TTOpenInAppActivity bundle], nil);
    UIAlertAction* alertAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        // Inform app that the activity has finished
        // Return NO because the service was canceled.
        [self activityDidFinish:NO];
    }];
    [alertController addAction:alertAction];
    
    alertController.popoverPresentationController.sourceView = self.superView;
    if(self.barButtonItem){
        alertController.popoverPresentationController.barButtonItem = self.barButtonItem;
    } else if (!CGRectIsNull(self.rect)) {
        alertController.popoverPresentationController.sourceRect = self.rect;
    }
    
    UIViewController *topController = UIApplication.sharedApplication.delegate.window.rootViewController;
    while (topController.presentedViewController){
        topController = topController.presentedViewController;
    }
    [topController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (void) documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller
{
    // Inform delegate
    if([self.delegate respondsToSelector:@selector(openInAppActivityWillPresentDocumentInteractionController:)]) {
        [self.delegate openInAppActivityWillPresentDocumentInteractionController:self];
    }
}

- (void) documentInteractionControllerDidDismissOpenInMenu: (UIDocumentInteractionController *) controller
{
    // Inform delegate
    if([self.delegate respondsToSelector:@selector(openInAppActivityDidDismissDocumentInteractionController:)]) {
        [self.delegate openInAppActivityDidDismissDocumentInteractionController:self];
    }
    
    // Inform app that the activity has finished
    [self activityDidFinish:YES];
}

- (void) documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application
{
    // Inform delegate
    if([self.delegate respondsToSelector:@selector(openInAppActivityDidEndSendingToApplication:)]) {
        [self.delegate openInAppActivityDidEndSendingToApplication:self];
    }
    if ([self.delegate respondsToSelector:@selector(openInAppActivityDidSendToApplication:)]) {
        [self.delegate openInAppActivityDidSendToApplication:application];
    }
    
    // Inform app that the activity has finished
    [self activityDidFinish:YES];
}

#pragma mark - Image conversion

- (NSURL *)localFileURLForImage:(UIImage *)image
{
    // save this image to a temp folder
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString *filename = [[NSUUID UUID] UUIDString];
    NSURL *fileURL;
    // if there is an images array, this is an animated image.
    if (image.images) {
        fileURL = [[tmpDirURL URLByAppendingPathComponent:filename] URLByAppendingPathExtension:@"gif"];
        NSUInteger frameCount = image.images.count;
        CGFloat frameDuration = (CGFloat)image.duration / frameCount;
        NSDictionary *fileProperties = @{
                                         (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                 (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                                 }
                                         };
        NSDictionary *frameProperties = @{
                                          (__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: [NSNumber numberWithDouble:frameDuration],
                                                  }
                                          };
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, (size_t)frameCount, NULL);
        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
        for (NSUInteger i = 0; i < frameCount; i++) {
            @autoreleasepool {
                UIImage *frameImage = [image.images objectAtIndex:i];
                CGImageDestinationAddImage(destination, frameImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
            }
        }
        NSAssert(CGImageDestinationFinalize(destination),@"Failed to create animated image.");
        CFRelease(destination);
    } else {
        fileURL = [[tmpDirURL URLByAppendingPathComponent:filename] URLByAppendingPathExtension:@"jpg"];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, (CGFloat)0.8)];
        [[NSFileManager defaultManager] createFileAtPath:[fileURL path] contents:data attributes:nil];
    }
    return fileURL;
}

- (void)dealloc
{
    self.documentInteractionController.delegate = nil;
}

@end


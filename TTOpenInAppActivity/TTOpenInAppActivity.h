//
//  TTOpenInAppActivity.h
//
//  Copyright (c) 2012-2018 Tobias Tiemerding
// 

#import <UIKit/UIKit.h>

@class TTOpenInAppActivity;

@protocol TTOpenInAppActivityDelegate <NSObject>
@optional
- (void)openInAppActivityWillPresentDocumentInteractionController:(TTOpenInAppActivity*)activity;
- (void)openInAppActivityDidDismissDocumentInteractionController:(TTOpenInAppActivity*)activity;
- (void)openInAppActivityDidEndSendingToApplication:(TTOpenInAppActivity*)activity;
- (void)openInAppActivityDidSendToApplication:(NSString*)application;
@end

@interface TTOpenInAppActivity : UIActivity <UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) id<TTOpenInAppActivityDelegate> delegate;

- (id)initWithView:(UIView *)view andRect:(CGRect)rect;
- (id)initWithView:(UIView *)view andBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (void)dismissDocumentInteractionControllerAnimated:(BOOL)animated;

@end

//
//  TTOpenInAppActivity.h
//
//  Created by Tobias Tiemerding on 12/25/12.
//  Copyright (c) 2012 TwoT App Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTOpenInAppActivity : UIActivity

@property (nonatomic, strong) UIActivityViewController *superViewController;

- (id)initWithView:(UIView *)view andRect:(CGRect)rect;
- (id)initWithView:(UIView *)view andBarButtonItem:(UIBarButtonItem *)barButtonItem;

@ends

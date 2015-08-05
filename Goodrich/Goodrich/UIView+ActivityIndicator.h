//
//  UIView+ActivityIndicator.h
//  Goodrich
//
//  Created by Zhixing Yang on 18/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define IMAGE_NAME @"loading_icon.png"
#define IMAGE_WIDTH 27
#define IMAGE_HEIGHT 27

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "ActivityIndicatorView.h"
#import "ImageSearchScanView.h"

@interface UIView (ActivityIndicator)

- (void)makeSpinnerActivity;
- (void)makeSpinnerActivityAtPoint: (CGPoint) center;
- (void)hideSpinnerActivity;

- (void)addScannerViewAtFrame: (CGRect)frame;
- (void)removeScannerView;

@end

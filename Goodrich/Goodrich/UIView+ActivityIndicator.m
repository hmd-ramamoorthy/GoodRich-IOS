//
//  UIView+ActivityIndicator.m
//  Goodrich
//
//  Created by Zhixing Yang on 18/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "UIView+ActivityIndicator.h"
static const NSString * IMAGE_VIEW_KEY = @"randomkeykeykey";
static const NSString * SCANNER_VIEW_KEY = @"randomkeasdfykeykey";

@implementation UIView (ActivityIndicator)

- (void)makeSpinnerActivity{
    [self makeSpinnerActivityAtPoint:[self getCenter]];
}

- (CGPoint)getCenter{
    return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)makeSpinnerActivityAtPoint: (CGPoint) center{
    [self hideSpinnerActivity];
    
    ActivityIndicatorView* imageView = [[ActivityIndicatorView alloc] initWithImage:[UIImage imageNamed:IMAGE_NAME]];
    
    // Associate the imageView with its key
    objc_setAssociatedObject (self, &IMAGE_VIEW_KEY, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:imageView];
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, IMAGE_WIDTH, IMAGE_HEIGHT);
    imageView.center = center;
    [self bringSubviewToFront:imageView];
}

- (void)hideSpinnerActivity{
    ActivityIndicatorView* activityIndicatorView = (ActivityIndicatorView *)objc_getAssociatedObject(self, &IMAGE_VIEW_KEY);
    objc_removeAssociatedObjects(self);
    [activityIndicatorView removeFromSuperview];
    activityIndicatorView = nil;
}

#pragma mark - Make Scanner View

- (void)addScannerViewAtFrame: (CGRect)frame{
    ImageSearchScanView* imageView = [ImageSearchScanView imageSearchScanView];
    
    // Associate the imageView with its key
    objc_setAssociatedObject (self, &SCANNER_VIEW_KEY, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:imageView];
    imageView.frame = frame;
    [self bringSubviewToFront:imageView];
    [imageView beginAnimate];
}

- (void)removeScannerView{
    UIView* view = (UIView *)objc_getAssociatedObject(self, &SCANNER_VIEW_KEY);
    objc_removeAssociatedObjects(self);
    [view removeFromSuperview];
    view = nil;
}


@end

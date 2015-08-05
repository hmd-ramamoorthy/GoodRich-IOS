//
//  ImageSearchScanView.m
//  Goodrich
//
//  Created by Zhixing on 26/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "ImageSearchScanView.h"

@implementation ImageSearchScanView

+ (instancetype)imageSearchScanView{
    ImageSearchScanView *imageSearchScanView = [[[NSBundle mainBundle] loadNibNamed:@"ImageSearchScanView" owner:nil options:nil] objectAtIndex:0];
    
    // make sure customView is not nil or the wrong class!
    if ([imageSearchScanView isKindOfClass:[ImageSearchScanView class]])
        return imageSearchScanView;
    else
        return nil;
}


- (void)beginAnimate{
    
    CGRect initialFrame = CGRectMake(0,
                                     -self.scanIcon.frame.size.height,
                                     self.scanIcon.frame.size.width,
                                     self.scanIcon.frame.size.height);
    
    CGRect finalFrame = CGRectMake(0,
                                   self.frame.size.height,
                                   self.scanIcon.frame.size.width,
                                   self.scanIcon.frame.size.height);
    
    self.scanIcon.frame = initialFrame;
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        self.scanIcon.frame = finalFrame;
        
    } completion:^(BOOL finished) {
        
        self.scanIcon.frame = initialFrame;
    
    }];
    
}

@end

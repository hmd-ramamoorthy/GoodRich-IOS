//
//  UIView+RotateAnimation.m
//  Goodrich
//
//  Created by Zhixing Yang on 8/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "UIView+RotateAnimation.h"

@implementation UIView (RotateAnimation)

- (void) rotateWithDuration:(CFTimeInterval)duration
                    byAngle:(CGFloat)angle
{
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = duration;

    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    [CATransaction setCompletionBlock:^{
        self.transform = CGAffineTransformRotate(self.transform, angle);
        [self.layer removeAllAnimations]; // this is important
    }];
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
}

@end

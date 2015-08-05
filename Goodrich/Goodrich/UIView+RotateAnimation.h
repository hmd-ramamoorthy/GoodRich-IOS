//
//  UIView+RotateAnimation.h
//  Goodrich
//
//  Created by Zhixing Yang on 8/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RotateAnimation)

- (void) rotateWithDuration:(CFTimeInterval)duration
                    byAngle:(CGFloat)angle;

@end

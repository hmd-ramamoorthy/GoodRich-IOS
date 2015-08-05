//
//  UIViewController+ScreenSize.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ScreenSize)

- (CGFloat) getScreenWidth;
- (CGFloat) getScreenHeight;
- (CGSize) getScreenSize;

- (BOOL)isIPhone4;
- (BOOL)isIPhone5;
- (BOOL)isIPhone6;
- (BOOL)isIphone6Plus;

@end

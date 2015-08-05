//
//  UIViewController+BlockViews.h
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ColorFromRGB.h"
#import <objc/runtime.h>

@interface UIViewController (BlockViews)

- (void)addBlackViewAtFrame: (CGRect)frame andSelectorWhenTouched: (SEL)action;
- (void)removeBlackView;

@end

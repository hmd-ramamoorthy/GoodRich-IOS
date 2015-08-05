//
//  TextSearchDelegate.h
//  Goodrich
//
//  Created by Zhixing Yang on 5/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol TextSearchDelegate <NSObject>

- (void) itemButtonPressedWithViewController: (UIViewController*)vc;
- (void) allButtonPressedWithViewController: (UIViewController*)vc;

@end

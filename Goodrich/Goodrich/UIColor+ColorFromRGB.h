//
//  UIColor+ColorFromRGB.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorFromRGB)

+ (UIColor*) colorFromRGB: (int)RGBValue;

- (NSString *)hexStringFromColor;

- (NSString*) getDisplayStringFromColor;

@end

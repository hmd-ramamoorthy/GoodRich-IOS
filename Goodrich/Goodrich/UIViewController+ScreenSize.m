//
//  UIViewController+ScreenSize.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

/*
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
 */

#import "UIViewController+ScreenSize.h"

@implementation UIViewController (ScreenSize)

- (CGFloat) getScreenWidth{
    return [self getScreenSize].width;
}

- (CGFloat) getScreenHeight{
    return [self getScreenSize].height;
}

- (CGSize) getScreenSize{
    // NSLog(@"Screen height: %f, width: %f", [[UIScreen mainScreen] bounds].size.height,[[UIScreen mainScreen] bounds].size.width);

    // NSLog(@"Scale: %f", [[UIScreen mainScreen] scale]);
    return [[UIScreen mainScreen] bounds].size;
}

// Iphone 4: 640 * 960. XCode: 320 * 480
- (BOOL)isIPhone4{
    return [self getScreenHeight] == 480;
}

// Iphone 5: 640 * 1136.  XCode: 320 * 568
- (BOOL)isIPhone5{
    return [self getScreenHeight] == 568;
}

// Iphone 6: 750 x 1334. XCode: 320 * 568
- (BOOL)isIPhone6{
    return [self getScreenHeight] == 667;
}

// Iphone 6 plus: 1242 * 2208. XCode: 320 * 568
- (BOOL)isIphone6Plus{
    return [self getScreenHeight] == 667;
}

/*
-(void) hello {
    if(IS_IPAD)
    {
        NSLog(@"IS_IPAD");
    }
    if(IS_IPHONE)
    {
        NSLog(@"IS_IPHONE");
    }
    if(IS_RETINA)
    {
        NSLog(@"IS_RETINA");
    }
    if(IS_IPHONE_4_OR_LESS)
    {
        NSLog(@"IS_IPHONE_4_OR_LESS");
    }
    if(IS_IPHONE_5)
    {
        NSLog(@"IS_IPHONE_5");
    }
    if(IS_IPHONE_6)
    {
        NSLog(@"IS_IPHONE_6");
    }
    if(IS_IPHONE_6P)
    {
        NSLog(@"IS_IPHONE_6P");
    }
    
    NSLog(@"SCREEN_WIDTH: %f", SCREEN_WIDTH);
    NSLog(@"SCREEN_HEIGHT: %f", SCREEN_HEIGHT);
    NSLog(@"SCREEN_MAX_LENGTH: %f", SCREEN_MAX_LENGTH);
    NSLog(@"SCREEN_MIN_LENGTH: %f", SCREEN_MIN_LENGTH);
}
 */

@end

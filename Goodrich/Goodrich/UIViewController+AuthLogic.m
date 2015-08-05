//
//  UIViewController+AuthLogic.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "UIViewController+AuthLogic.h"

@implementation UIViewController (AuthLogic)

- (void)childPageDismissed{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerCurrentViewControllerNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentViewController" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self, @"lastViewController", nil]];
}

@end
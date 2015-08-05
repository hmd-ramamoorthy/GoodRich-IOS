//
//  UIViewController+LogoutLogic.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "UIViewController+LogoutLogic.h"

@implementation UIViewController (LogoutLogic)

- (void) userLoggedOutWithReason:(LOG_OUT_REASON)logOutReason{
    // Remove current views to release memory:
    for (UIView* view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    
    for (UIViewController* vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    
    // Remove user info. Cancel auto-login next time.
    [DataClient eraseAllLocalPrefs];

    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.authenticationViewControllerDelegate userLoggedOutWithReason: logOutReason];
}

@end

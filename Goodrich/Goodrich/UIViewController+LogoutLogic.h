//
//  UIViewController+LogoutLogic.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DataClient.h"
#import "AppDelegate.h"

@interface UIViewController (LogoutLogic)

- (void) userLoggedOutWithReason: (LOG_OUT_REASON) logOutReason;

@end

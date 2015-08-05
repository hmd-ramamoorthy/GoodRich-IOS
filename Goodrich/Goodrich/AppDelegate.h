//
//  AppDelegate.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NewRelicAgent/NewRelic.h>
#import "UIColor+ColorFromRGB.h"
#import "LoginSuccessfulDelegate.h"
#import "ToggleSideBarButtonClickedDelegate.h"
#import "CameraPageAnchorDelegate.h"
#import "Flurry.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController* lastViewController;

// A variable to store the delegate. The logout process will assign this variable to a new LoginViewController.

@property (weak, nonatomic) id<LoginSuccessfulDelegate> authenticationViewControllerDelegate;
@property (weak, nonatomic) id<ToggleSideBarButtonClickedDelegate> sidebarViewControllerDelegate;
@property (weak, nonatomic) id<CameraPageAnchorDelegate> searchResultViewControllerDelegate;

@end


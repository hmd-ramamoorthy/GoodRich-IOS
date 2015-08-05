//
//  AuthenticationViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "HomeViewController.h"
#import "UISidebarViewController.h"
#import "MenuViewController.h"
#import "LoginSuccessfulDelegate.h"
#import "LoginViewController.h"
#import "UIView+ActivityIndicator.h"
#import "UIViewController+HandleFailedRequest.h"
#import "DataClient.h"

@interface AuthenticationViewController : TemplateViewController <LoginSuccessfulDelegate>

@end

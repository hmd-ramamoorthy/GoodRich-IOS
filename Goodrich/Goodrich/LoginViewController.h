//
//  LoginViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "Constants.h"
#import "HTTPClient.h"
#import "HomeViewController.h"
#import "LoginSuccessfulDelegate.h"
#import "NSString+GeneralMethods.h"
#import "UIView+ActivityIndicator.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface LoginViewController : TemplateViewController <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic) LOG_OUT_REASON logOutReason;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) id<LoginSuccessfulDelegate> delegate;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)forgotPasswordButtonPressed:(id)sender;

@end   

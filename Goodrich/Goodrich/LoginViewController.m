//
//  LoginViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add by yulu: get version number programmatically
    NSString* appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version: %@", appVersionString]; 
    
    switch (self.logOutReason) {
        case LOG_OUT_REASON_NOT_AUTH:
            [self.view makeToast:@"Sorry, you are not authorized yet. Please login again."
                        duration:TOAST_MESSAGE_DURATION
                        position:TOAST_MESSAGE_POSITION];
            break;
        case LOG_OUT_REASON_USER_TRIGGERED:
            break;
        default:
            break;
    }
    UIView *imgCont = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-self.view.frame.size.height/6, self.view.frame.size.width, self.view.frame.size.height/6)];
    imgCont.backgroundColor = [UIColor clearColor];
    //    [imgCont setImage:[UIImage imageNamed:@"ph.png"]];
    //    imgCont.userInteractionEnabled = YES;
    [self.view addSubview:imgCont];
    
    
    UIButton *webBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgCont.frame.size.width, imgCont.frame.size.height/2)];
    webBtn.backgroundColor = [UIColor yellowColor];
    [webBtn setImage:[UIImage imageNamed:@"WWW.png"] forState:UIControlStateNormal];
    [webBtn addTarget:self action:@selector(webButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imgCont addSubview:webBtn];
    
    UIButton *emailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, webBtn.frame.origin.y+webBtn.frame.size.height, webBtn.frame.size.width, webBtn.frame.size.height)];
    emailBtn.backgroundColor = [UIColor blueColor];
    [emailBtn setImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateNormal];
    [emailBtn addTarget:self action:@selector(emailButonClick:) forControlEvents:UIControlEventTouchUpInside];
    [imgCont addSubview:emailBtn];
}


-(void)webButtonClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.goodrichglobal.com/web"]];
}

-(void)emailButonClick:(id)sender
{
    NSArray *toRecipients=[[NSArray alloc] initWithObjects:@"info@goodrichglobal.com", nil];
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)
    {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail])
        {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            // Set up recipients
            //  NSArray *toRecipients = [NSArray arrayWithObject:@""];
            NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
            NSArray *bccRecipients = [NSArray arrayWithObject:@""];
            
            [picker setToRecipients:toRecipients];
            [picker setCcRecipients:ccRecipients];
            [picker setBccRecipients:bccRecipients];
            
            NSString *emailBody=@""; // = @"It is raining in sunny California!";
            [picker setMessageBody:emailBody isHTML:NO];
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *mailmsg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            mailmsg=@"Mail cancelled";
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved Drafts folder");
            mailmsg=@"Mail saved Drafts folder";
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send");
            mailmsg=@"Mail send successfully.";
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed due to an error");
            mailmsg=@"Mail failed due to an error";
            break;
        default:
            NSLog(@"Mail not sent");
            mailmsg=@"Mail not sent";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertView *Newalert = [[UIAlertView alloc] initWithTitle:@"Goodrich"
                                                       message:mailmsg
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil,nil];
    
    [Newalert show];
    
}

#pragma mark -
#pragma mark Workaround

-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:info@goodrichglobal.com?cc=second@example.com,third@example.com&subject=";
    NSString *body = @"&body";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonPressed:(id)sender {
    [self hideKeyboards];
    
    if ([self isValidInput]) {
        [self.view makeSpinnerActivity];
        [[HTTPClient sharedInstance] userLogin:self.userNameTextField.text
                                      Password:self.passwordTextField.text
                                       success:^(NSInteger statusCode, id responseObject) {
            
            [[DataClient sharedInstance] userLogginInWithInfo:responseObject];
            
            [self.delegate loginSuccessful];
            [self.view hideSpinnerActivity];
            
        } failure:^(NSInteger statusCode, NSArray* errors) {
            [self.view hideSpinnerActivity];
            [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
        }];
    } else{
        [self.view makeToast:@"Please input name and password correctly." duration:TOAST_MESSAGE_DURATION position:TOAST_MESSAGE_POSITION];
    }
}

-(void)hideKeyboards{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (BOOL)isValidInput{
    return (self.userNameTextField.text.length > 0 &&
            self.passwordTextField.text.length > 0);
}

- (IBAction)forgotPasswordButtonPressed:(id)sender {
    [self hideKeyboards];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter your email" delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:@"Cancel", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = self.userNameTextField.text;
    [alert show];
}

#pragma mark - Actionsheet Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            if ([[alertView textFieldAtIndex:0].text isValidEmail]) {
                [self.view makeSpinnerActivity];
                //changed by Yu Lu: display the actual message from the api json response
                [[HTTPClient sharedInstance] resetPassword:[alertView textFieldAtIndex:0].text success:^(NSInteger statusCode, NSDictionary* responseObject) {
                    [self.view hideSpinnerActivity];
                    NSString* message = responseObject[@"message"];
                    [self.view makeToast:message duration:TOAST_MESSAGE_DURATION position:TOAST_MESSAGE_POSITION];
                } failure:^(NSInteger statusCode, NSArray *errors) {
                    [self.view hideSpinnerActivity];
                    [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
                }];
            } else{
                [self handleFailedRequestWithErrors:[NSArray arrayWithObjects:@"Please fill in email address correctly.", nil] withType:REQUEST_TYPE_SINGLE_REQUEST];
            }
            break;
        }
        case 1:
            
            break;
        default:
            
            break;
    }
}

@end

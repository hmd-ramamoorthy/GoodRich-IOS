//
//  HomeViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if(!self.isIPhone4)
    {
        UIView *imgCont = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-self.view.frame.size.height/6-60, self.view.frame.size.width, self.view.frame.size.height/6)];
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.sidebarViewControllerDelegate setSideBarEnabled: NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.sidebarViewControllerDelegate setSideBarEnabled: YES];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueFromHomeToBrowsing"]) {
        BrowsingItemsViewController* vc = (BrowsingItemsViewController*)segue.destinationViewController;
        vc.browingType = BROWSING_ITEMS_TYPE_ALL;
    } else if ([segue.identifier isEqualToString:@"SegueFromHomeToFav"]){
        BrowsingItemsViewController* vc = (BrowsingItemsViewController*)segue.destinationViewController;
        vc.browingType = BROWSING_ITEMS_TYPE_FAVOURITE;
    }
}

#pragma mark - Button click events

- (IBAction)menuButtonClicked:(UIButton *)sender {
    // One of the buttons on the main page is clicked. Do nothing here.
    // The action is handled by segue.
}

// Override
- (IBAction)backButtonClicked:(id)sender{
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.sidebarViewControllerDelegate toggleSideBarButtonClicked];
}

@end

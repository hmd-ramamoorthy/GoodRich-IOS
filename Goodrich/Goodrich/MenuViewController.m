//
//  MenuViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameLabel.text = [[[DataClient sharedInstance] user] name];
    
    //add by YU LU: get the version number programmatically
    NSString* appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version: %@", appVersionString];
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

- (IBAction)menuButtonClicked:(UIButton*)sender {
    
    for (UIButton* button in self.menuButtons) {
        UIColor* backgroundColor = button == sender ? [UIColor colorFromRGB:0x8a12bc] : [UIColor blackColor];
        CGFloat cornerRadius = button == sender ? 3.0 : 0.0;
 
        button.layer.cornerRadius = cornerRadius;
        button.clipsToBounds = YES;
        
        [UIView animateWithDuration:0.1 animations:^{
            button.backgroundColor = backgroundColor;
        }];
    }

    UIViewController* vcToPresent = nil;
    switch (sender.tag) {
        case 0:{
            // Home
            HomeViewController* vc = (HomeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            vcToPresent = vc;
            break;
        }
        case 1:{
            // Browsing
            BrowsingItemsViewController* vc = (BrowsingItemsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrowsingItemsViewController"];
            vc.browingType = BROWSING_ITEMS_TYPE_ALL;
            vcToPresent = vc;
            break;
        }
        case 2:{
            // My Favourites
            BrowsingItemsViewController* vc = (BrowsingItemsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrowsingItemsViewController"];
            vc.browingType = BROWSING_ITEMS_TYPE_FAVOURITE;
            vcToPresent = vc;
            break;
        }
        case 3:{
            //Image Search
            ImageSearchViewController* vc = (ImageSearchViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ImageSearchViewController"];
            vcToPresent = vc;
            break;
        }
        case 4:{
            //Keyword Search
            KeywordsSearchViewController* vc = (KeywordsSearchViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"KeywordsSearchViewController"];
            vcToPresent = vc;
            break;
        }
        case 5:{
            // Color Search
            ColorSearchViewController* vc = (ColorSearchViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ColorSearchViewController"];
            vcToPresent = vc;
            break;
        }
        case 6:{
            // Pattern Search
            PatternSearchViewController* vc = (PatternSearchViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"PatternSearchViewController"];
            vcToPresent = vc;
            break;
        }
        case 7:{
            // Logout
            [self userLoggedOutWithReason:LOG_OUT_REASON_USER_TRIGGERED];
            return;
        }
        default:
            NSLog(@"Unknown button pressed at menu.");
            break;
    }
    
    if (vcToPresent != nil) {
        [self.delegate sidebarItemClickedWithNewViewController:vcToPresent];
    }
}

@end

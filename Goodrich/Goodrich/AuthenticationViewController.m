//
//  AuthenticationViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "AuthenticationViewController.h"

@interface AuthenticationViewController ()

@property (nonatomic) BOOL isFirstTimeAppear;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.authenticationViewControllerDelegate = self;
    self.isFirstTimeAppear = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.isFirstTimeAppear){
        [self checkLoginStatus];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Logic

- (void)checkLoginStatus{
    if ([DataClient isUserAndKeyValid]) {
        [self loginSuccessful];
    }
    else{
        LoginViewController* loginVC = (LoginViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            loginVC.delegate = self;
        [self presentViewController:loginVC animated:YES completion:nil];
        self.isFirstTimeAppear = NO;
    }
}

// Delegate
- (void) userLoggedOutWithReason: (LOG_OUT_REASON) reason{
    [self dismissViewControllerAnimated:NO completion:^{
        [self checkLoginStatus];
    }];
}

// Delegate
- (void)loginSuccessful{
    // Load the refinFieldList only once from server:
    if ([DataClient sharedInstance].refineFieldList == nil) {
        [self.view makeSpinnerActivityAtPoint:CGPointMake(self.view.center.x, self.view.center.y - 25)];
        [[HTTPClient sharedInstance]getRefineFieldListSuccess:^(NSInteger statusCode, id responseObject) {
            
            [[SearchClient sharedInstance] registerViSearchSDK];
            
            NSMutableDictionary* refineFieldList = [[NSMutableDictionary alloc] init];
            
            // Load the list items and counts only once from server:
            for (NSString* key in ((NSDictionary*)responseObject[@"result"]).allKeys) {
                [[HTTPClient sharedInstance] getFacetItemsWithCategory:key FacetTitles:[((NSDictionary*)responseObject[@"result"]) objectForKey:key] success:^(NSInteger statusCode, id responseObject) {
                    
                    NSMutableArray *facets = [[NSMutableArray alloc] init];
                    for (NSDictionary* facetDict in responseObject[@"facet"]) {
                        Facet* newFacet = [Facet FacetFromDictionary:facetDict];
                        [facets addObject:newFacet];
                    }
                    [refineFieldList setObject:[NSArray arrayWithArray: facets] forKey:key];
                    
                    // When facet items of 4 categories are retrieved:
                    if (refineFieldList.count == 4) {
                        [DataClient sharedInstance].refineFieldList = [NSDictionary dictionaryWithDictionary: refineFieldList];
                        [self proceedToHomePageViewController];
                        [self.view hideSpinnerActivity];
                    }
                } failure:^(NSInteger statusCode, NSArray *errors) {
                    [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
                    [self.view hideSpinnerActivity];
                }];
            }
        } failure:^(NSInteger statusCode, NSArray *errors) {
            [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
        }];
    } else{
        [self proceedToHomePageViewController];
    }
}

- (void) proceedToHomePageViewController{
    // Create base view controller
    UINavigationController* homeVC = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"NavBeforeHomeVC"];
    
    // Create menu sidebar controller
    MenuViewController* menuVC = (MenuViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    UISidebarViewController* sidebarVC = [[UISidebarViewController alloc]
                                          initWithCenterViewController:homeVC
                                          andSidebarViewController:menuVC];
    
    // Dismiss whatever current VC and present a new:
    if (self.isFirstTimeAppear) {
        self.isFirstTimeAppear = NO;
        [self presentViewController:sidebarVC animated:YES completion:nil];
    } else{
        [self dismissViewControllerAnimated:NO completion:^{
            [self presentViewController:sidebarVC animated:YES completion:nil];
        }];
    }
}

@end








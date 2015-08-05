//
//  MenuViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//
#import "SidebarItemClickedDelegate.h"

#import "UIColor+ColorFromRGB.h"

#import "HomeViewController.h"
#import "BrowsingItemsViewController.h"

#import "ImageSearchViewController.h"
#import "KeywordsSearchViewController.h"
#import "ColorSearchViewController.h"
#import "PatternSearchViewController.h"

#import "UIViewController+LogoutLogic.h"
#import "DataClient.h"

@interface MenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuButtons;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) id<SidebarItemClickedDelegate> delegate;

- (IBAction)menuButtonClicked:(UIButton*)sender;

@end

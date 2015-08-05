//
//  HomeViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "BrowsingItemsViewController.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface HomeViewController : TemplateViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuButtonCollection;

- (IBAction)menuButtonClicked:(UIButton *)sender;

@end

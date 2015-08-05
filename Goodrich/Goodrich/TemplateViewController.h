//
//  TemplateViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+AuthLogic.h"
#import "UIViewController+HandleFailedRequest.h"
#import "Constants.h"
#import "HTTPClient.h"

@interface TemplateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutletCollection(UIBarButtonItem) NSArray* rightBarButtonItemsCollection;
@property (nonatomic, strong) UIActionSheet *actionSheet;

- (BOOL) isShareButtonDisplayed;
- (BOOL) isHomeButtonDisplayed;
- (BOOL) isSearchButtonDisplayed;
- (void) prepareSendingProducts:(NSArray *)products;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)share:(id)sender;
@end

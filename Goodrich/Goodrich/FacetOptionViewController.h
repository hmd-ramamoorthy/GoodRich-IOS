//
//  FacetOptionViewController.h
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+ColorFromRGB.h"
#import "FacetOptionDidApplyDelegate.h"

@interface FacetOptionViewController : UIViewController

@property (strong, nonatomic) NSString* facetKey;
@property (strong, nonatomic) NSArray* facetItems;
@property (strong, nonatomic) NSArray* facetItemsSelected;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (weak, nonatomic) IBOutlet UIImageView *closeIcon;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) id<FacetOptionDidApplyDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *facetKeyLabel;

- (IBAction)applyButtonClicked:(UIButton *)sender;

- (IBAction)closeButtonClicked:(UIButton *)sender;

- (void) setMultipleSelection: (bool) multi;

@end

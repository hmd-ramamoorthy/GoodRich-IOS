//
//  FacetViewController.h
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facet.h"
#import "UIColor+ColorFromRGB.h"
#import "FacetDidApplyDelegate.h"
#import "FacetOptionDidApplyDelegate.h"
#import "FacetOptionViewController.h"
#import "UIViewController+ScreenSize.h"
#import "RoundedUIButton.h"
#import "DataClient.h"
#import "Filter.h"

@interface FacetViewController : UIViewController <FacetOptionDidApplyDelegate>

@property (strong, nonatomic) Filter* filter;
@property (strong, nonatomic) NSString* priority;
@property (strong, nonatomic) NSArray* facets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *applyFiltersButton;
@property (weak, nonatomic) IBOutlet UIImageView *closeIcon;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet RoundedUIButton *clearFiltersButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortControl;
@property (weak, nonatomic) IBOutlet UIView *sortBackground;
@property (weak, nonatomic) IBOutlet UILabel *sortByLabel;

@property (strong, nonatomic) id<FacetDidApplyDelegate> delegate;

- (void)initDataModel;
- (void)showSortByTab;
- (CGFloat)getMovingDistance;

- (IBAction)applyFiltersButtonClicked:(UIButton *)sender;
- (IBAction)closeButtonClicked:(UIButton *)sender;
- (IBAction)clearFiltersButtonClicked:(UIButton *)sender;

@end

//
//  BrowsingItemsViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "UIColor+ColorFromRGB.h"
#import "UIView+ActivityIndicator.h"
#import "Product.h"
#import "UIViewController+ScreenSize.h"
#import "FacetViewController.h"
#import "ItemDetailsViewController.h"
#import "ProductDetailDelegate.h"
#import "Facet.h"
#import "FacetDidApplyDelegate.h"
#import "UIViewController+BlockViews.h"
#import "RoundedUIImageView.h"
#import "SearchClient.h"
#import "DropDownMenuDelegate.h"
#import "CategoryDropdownMenuView.h"
#import "DataLoadingExceptionDelegate.h"
#import "DataLoadingExceptionView.h"
#import "SearchKeyDisplayView.h"
#import "UIView+RotateAnimation.h"

@interface BrowsingItemsViewController : TemplateViewController<UICollectionViewDataSource, UICollectionViewDelegate, ProductDetailDelegate, FacetDidApplyDelegate, DropDownMenuDelegate, DataLoadingExceptionDelegate>

@property (nonatomic) BROWSING_ITEMS_TYPE browingType;

// Only useful in search result:
@property (strong, nonatomic) UIColor* colorToSearch;
@property (strong, nonatomic) UIImage* imageToSearch;
@property (nonatomic) CGRect imageFrameToCrop;
@property (strong, nonatomic) NSString* keywordToSearch;
@property (strong, nonatomic) NSString* patternTypeToSearch;
@property (strong, nonatomic) NSString* categoryToSearch; // Will be set into: self.facetViewController.filter
@property (strong, nonatomic) Product* productToSearch;

// Collection View:
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// Navigation View:
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dropDownIcon;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

// Filters
@property (strong, nonatomic) FacetViewController* facetViewController;
@property (weak, nonatomic) IBOutlet UIButton *refineButton;

// Dropdown:
@property (strong, nonatomic) CategoryDropdownMenuView* dropDownMenuView;

// Data loading exception:
@property (strong, nonatomic) DataLoadingExceptionView* dataLoadingExceptionView;

- (IBAction)dropDownButtonClicked:(UIButton *)sender;
- (IBAction)likeButtonPressed:(UIButton *)sender;
- (IBAction)findSimilarButtonPressed:(UIButton *)sender;
- (IBAction)refineButtonClicked:(UIButton *)sender;

@end

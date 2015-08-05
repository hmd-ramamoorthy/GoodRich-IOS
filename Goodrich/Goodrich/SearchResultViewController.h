//
//  SearchResultViewController.h
//  Goodrich
//
//  Created by Zhixing on 29/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "TemplateViewController.h"
#import "ItemDetailsViewController.h"
#import "ImageSearchRefineViewController.h"
#import "UIColor+ColorFromRGB.h"
#import "DataLoadingExceptionView.h"
#import "BrowsingItemsViewController.h"
#import "TextSearchDelegate.h"
#import "RoundedUIImageView.h"
#import "RowScrollingCollectionView.h"
#import "CameraPageAnchorDelegate.h"

@interface SearchResultViewController : TemplateViewController <UICollectionViewDelegate, UICollectionViewDataSource, CameraPageAnchorDelegate>

@property (nonatomic) SEARCH_TYPE searchType;

// Model:
@property (strong, nonatomic) NSArray* products;
@property (strong, nonatomic) NSString* labelText;

// Might be nil, depending on the searchType
@property (strong, nonatomic) UIImage* imageToSearch;
@property (nonatomic) CGRect imageFrameToCrop;
@property (strong, nonatomic) UIColor* colorToSearch;
@property (strong, nonatomic) NSString* keywordToSearch;

// UI Elements:
@property (strong, nonatomic) DataLoadingExceptionView* dataLodingExceptionView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *searchSourceGroup;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *editIcon;
@property (weak, nonatomic) IBOutlet UILabel *colorValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *editSearchButton;
@property (weak, nonatomic) IBOutlet UIView *colorDisplayView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) id<TextSearchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *noResultDisplayLabel;
@property (weak, nonatomic) IBOutlet UIView *noResultButton;
@property (weak, nonatomic) IBOutlet UIView *noResultDisplayView;


- (IBAction)editSearchButtonClicked:(UIButton *)sender;

- (void)reInitDataAndReloadView;

@end

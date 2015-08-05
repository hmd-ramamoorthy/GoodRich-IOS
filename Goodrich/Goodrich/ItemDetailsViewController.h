//
//  ItemDetailsViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "Product.h"
#import "UIView+ActivityIndicator.h"
#import "UIColor+ColorFromRGB.h"
#import "ProductDetailDelegate.h"
#import "UIView+ActivityIndicator.h"
#import "BrowsingItemsViewController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "RoundedUIImageView.h"

@interface ItemDetailsViewController : TemplateViewController

// For Initially to load details data from server.
// Subsequent displays will make use of the data retrieved.
@property (strong, nonatomic) NSString* productName;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet RoundedUIImageView* productIconImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UICollectionView *sameCollectionCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *similarItemsCollectionView;

@property (weak, nonatomic) id<ProductDetailDelegate> delegate;

@property (strong, nonatomic) NSString* url;

- (IBAction)findSimilarButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(UIButton *)sender;

@end

//
//  SearchResultViewController.m
//  Goodrich
//
//  Created by Zhixing on 29/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define ROW_SCROLLVIEW_TAG 17912
#define ICON_TAG 4758
#define CATEGORY_LABEL_TAG 5947
#define COLLECTION_VIEW_SECTION_HEIGHT 115
#define NAV_BAR_HEIGHT 64
#define EXTRA_SPACE_BOTTOM 800

#define VIEW_ALL_BUTTON_WIDTH 40
#define VIEW_ALL_BUTTON_HEIGHT 78

#define BASE_TAG 10234

#define IMAGE_VIEW_HEIGHT 160
#define COLOR_DISPLAY_HEIGHT 50

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

// Data storage:
@property (strong, nonatomic) NSMutableArray* wallcoveringProducts;
@property (strong, nonatomic) NSMutableArray* fabricProducts;
@property (strong, nonatomic) NSMutableArray* carpetProducts;
@property (strong, nonatomic) NSMutableArray* flooringProducts;

@property (strong, nonatomic) NSMutableArray* collectionsOfProducts;
@property (strong, nonatomic) NSMutableArray* categoryTitles;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reInitDataAndReloadView];
    
    // Prevent the scrollView from autoscroll when poped an vc.
    // http://stackoverflow.com/questions/17404682/uiscrollviews-origin-changes-after-popping-back-to-the-uiviewcontroller
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarheight = self.navigationController.navigationBar.frame.size.height;
    CGRect bounds = [self.view bounds];
    bounds.size.height = screenHeight - statusBarHeight - navBarheight;
    
    [self.scrollView setFrame:bounds];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reInitDataAndReloadView{
    [self initializeData];
    [self renderViews];
}

#pragma mark - Render views

- (void) initializeData{
    self.wallcoveringProducts = [[NSMutableArray alloc] init];
    self.fabricProducts = [[NSMutableArray alloc] init];
    self.carpetProducts = [[NSMutableArray alloc] init];
    self.flooringProducts = [[NSMutableArray alloc] init];
    
    self.collectionsOfProducts = [[NSMutableArray alloc] init];
    self.categoryTitles = [[NSMutableArray alloc] init];
}

- (void)renderViews{
    [self renderSearchSource];
    [self renderSearchResult];
    [self renderViewAllButtons];
    [self renderNoResultDisplayLabel];
    
    [self adjustViewPositions];
}

- (void)renderSearchSource{
    switch (self.searchType) {
        case SEARCH_TYPE_COLOR:{
            self.colorValueLabel.text = [self.colorToSearch getDisplayStringFromColor];
            self.imageView.hidden = YES;
            self.editSearchButton.frame = self.colorDisplayView.frame;
            self.colorDisplayView.backgroundColor = self.colorToSearch;
            self.editIcon.frame = CGRectMake(205, 18, 18, 18);
            [self.scrollView bringSubviewToFront:self.editIcon];
            [self.scrollView bringSubviewToFront:self.editSearchButton];
            break;
        }
        case SEARCH_TYPE_TEXT:{
            for (UIView* view in self.searchSourceGroup) {
                view.hidden = YES;
            }
            break;
        }
        case SEARCH_TYPE_IMAGE:{
            self.colorValueLabel.hidden = YES;
            // Display the cropped image. But don't actually crop the original copy.
            self.imageView.image = [self.imageToSearch crop: self.imageFrameToCrop];
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.colorDisplayView.hidden = YES;
            break;
        }default:
            // For pattern and ID search, they won't use this page to show results.
            NSLog(@"Error: wrong searchType in search result page");
            break;
    }
}

- (void)renderSearchResult{
    
    // If there're no results to be displayed:
    if (self.products == nil || self.products.count == 0) {
        
        self.collectionView.hidden = YES;
        if (self.dataLodingExceptionView != nil) {
            [self.dataLodingExceptionView removeFromSuperview];
            self.dataLodingExceptionView = nil;
        }
        self.dataLodingExceptionView = [DataLoadingExceptionView dataLoadingExceptionView];
        [self.dataLodingExceptionView switchToMode:DATA_LOADING_EXCEPTION_TYPE_NO_MATCH];
        self.dataLodingExceptionView.frame = CGRectMake(0, 0, [self getScreenWidth], [self getScreenHeight]);
        [self.view addSubview: self.dataLodingExceptionView];
        [self.view bringSubviewToFront: self.dataLodingExceptionView];
        
    } else{
        self.collectionView.hidden = NO;
        self.dataLodingExceptionView.hidden = YES;
        for (Product* product in self.products) {
            if ([[product.specifications objectForKey:@"Category"] isEqualToString:CATEGORY_KEY_WALLCOVERING]){
                [self.wallcoveringProducts addObject:product];
            } else if ([[product.specifications objectForKey:@"Category"] isEqualToString:CATEGORY_KEY_CARPET]){
                [self.carpetProducts addObject:product];
            }  else if ([[product.specifications objectForKey:@"Category"] isEqualToString:CATEGORY_KEY_FABRIC]){
                [self.fabricProducts addObject:product];
            } else if ([[product.specifications objectForKey:@"Category"] isEqualToString:CATEGORY_KEY_FLOORING]){
                [self.flooringProducts addObject:product];
            } else{
                NSLog(@"Error: unknown collection detected when sorting collections %@", product.specifications);
            }
        }
        
        if (self.wallcoveringProducts.count > 0) {
            [self.collectionsOfProducts addObject:self.wallcoveringProducts];
            [self.categoryTitles addObject: @"Wallcovering"];
        }
        
        if (self.fabricProducts.count > 0) {
            [self.collectionsOfProducts addObject:self.fabricProducts];
            [self.categoryTitles addObject: @"Fabric"];
        }
        
        if (self.carpetProducts.count > 0) {
            [self.collectionsOfProducts addObject:self.carpetProducts];
            [self.categoryTitles addObject: @"Carpet"];
        }
        
        if (self.flooringProducts.count > 0) {
            [self.collectionsOfProducts addObject:self.flooringProducts];
            [self.categoryTitles addObject: @"Flooring"];
        }
        
        [self.collectionView reloadData];
    }
}

- (void)renderViewAllButtons{
    CGFloat currentHeight = 36;
    
    for (int i = 0; i < self.categoryTitles.count; i++) {
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake([self getScreenWidth] - VIEW_ALL_BUTTON_WIDTH,
                                                                      currentHeight,
                                                                      VIEW_ALL_BUTTON_WIDTH,
                                                                      VIEW_ALL_BUTTON_HEIGHT)];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:@"See\nMore" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.alpha = 0.7;
        button.backgroundColor = [UIColor blackColor];
        if([[self.categoryTitles objectAtIndex:i] isEqualToString:@"Wallcovering"]){
            button.tag = BASE_TAG + 0;
        }else if([[self.categoryTitles objectAtIndex:i] isEqualToString:@"Carpet"]){
            button.tag = BASE_TAG + 1;
        }else if([[self.categoryTitles objectAtIndex:i] isEqualToString:@"Fabric"]){
            button.tag = BASE_TAG + 2;
        }else{
            button.tag = BASE_TAG + 3;
        }
        [self.collectionView addSubview: button];
        
        [button addTarget:self action:@selector(viewAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        currentHeight += COLLECTION_VIEW_SECTION_HEIGHT;
    }
}

- (void)renderNoResultDisplayLabel{
    if ([self numberOfSectionsInCollectionView:self.collectionView] == MAX_ITEM_PER_SCREEN) {
        self.noResultDisplayView.hidden = YES;
    } else{
        self.noResultDisplayView.hidden = NO;
        NSMutableArray *noResultCategory = [[NSMutableArray alloc] init];
        if (self.wallcoveringProducts.count == 0){
            [noResultCategory addObject: CATEGORY_TITLE_WALLCOVERING];
        }
        if (self.fabricProducts.count == 0){
            [noResultCategory addObject: CATEGORY_TITLE_FABRIC];
        }
        if (self.carpetProducts.count == 0){
            [noResultCategory addObject: CATEGORY_TITLE_CARPET];
        }
        if (self.flooringProducts.count == 0){
            [noResultCategory addObject: CATEGORY_TITLE_FLOORING];
        }
        NSArray *viewsToRemove = [self.noResultButton subviews];
        for (UIButton*v in viewsToRemove) {
            [v removeFromSuperview];
        }
        if (noResultCategory.count > 0){
            if(self.searchType != SEARCH_TYPE_TEXT){
                NSMutableString* title = [[NSMutableString alloc] initWithString:@"Find More Products in "];
                for (int i = 0; i < noResultCategory.count; i++) {
                    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(100*i,
                                                                                  0,
                                                                                  80,
                                                                                  20)];
                    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    button.titleLabel.textAlignment = NSTextAlignmentCenter;
                    [button setTitle:noResultCategory[i] forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.alpha = 0.7;
                    button.layer.cornerRadius = 10;
                    button.clipsToBounds = YES;
                    if([noResultCategory[i] isEqualToString:@"Wallcovering"]){
                        button.tag = BASE_TAG + 0;
                    }else if([noResultCategory[i] isEqualToString:@"Carpet"]){
                        button.tag = BASE_TAG + 1;
                    }else if([noResultCategory[i] isEqualToString:@"Fabric"]){
                        button.tag = BASE_TAG + 2;
                    }else if([noResultCategory[i] isEqualToString:@"Flooring"]){
                        button.tag = BASE_TAG + 3;
                    }
                    button.backgroundColor = [UIColor colorFromRGB:0x963EBB];
                    [self.noResultButton addSubview: button];
                    [button addTarget:self action:@selector(viewAllButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
                self.noResultDisplayLabel.text = title;
            }else{
                 NSMutableString* title = [[NSMutableString alloc] initWithString:@"No results found in "];
                if ( noResultCategory.count >1 ){
                    for (int i = 0; i < noResultCategory.count - 1; i++) {
                        [title appendFormat:@"%@", noResultCategory[i]];
                        if(i!= noResultCategory.count-2){
                            [title appendString:@", "];
                        }
                    }
                    [title appendFormat: @" and %@.", noResultCategory[noResultCategory.count - 1]];
                }
                self.noResultDisplayLabel.text = title;
            }
        }
    }
}

- (void)adjustViewPositions{
    
    // 1. Start.
    CGFloat startY;
    switch (self.searchType) {
        case SEARCH_TYPE_IMAGE:
            startY = IMAGE_VIEW_HEIGHT;
            break;
        case SEARCH_TYPE_TEXT:
            startY = 0;
            break;
        case SEARCH_TYPE_COLOR:
            startY = COLOR_DISPLAY_HEIGHT;
            break;
        default:
            break;
    }
    
    // 2. CollectionView
    self.collectionView.frame = CGRectMake(0,
                                           startY,
                                           self.collectionView.frame.size.width,
                                           COLLECTION_VIEW_SECTION_HEIGHT * [self numberOfSectionsInCollectionView:self.collectionView] + 10);
    startY += self.collectionView.frame.size.height;
    
    // 3. noResult Label
    if (!self.noResultDisplayView.hidden) {
        if(self.searchType != SEARCH_TYPE_TEXT){
            self.noResultDisplayView.frame = CGRectMake(0,
                                                         startY,
                                                         self.noResultDisplayView.frame.size.width,
                                                         self.noResultDisplayView.frame.size.height);
            startY += self.noResultDisplayView.frame.size.height;
        }else{
            self.noResultDisplayView.frame = CGRectMake(0,
                                                         startY,
                                                         self.noResultDisplayView.frame.size.width,
                                                         self.noResultDisplayView.frame.size.height);
        }
        self.noResultButton.frame = CGRectMake(10,
                                               startY,
                                               self.noResultDisplayView.frame.size.width,
                                               self.noResultDisplayView.frame.size.height);
        startY += self.noResultButton.frame.size.height;
    }
    
    // 4. bottom
    self.bottomView.frame = CGRectMake(0,
                                       startY,
                                       self.bottomView.frame.size.width,
                                       self.bottomView.frame.size.height);
    startY += self.bottomView.frame.size.height;
    
    self.scrollView.contentSize = CGSizeMake(0, startY - EXTRA_SPACE_BOTTOM);
}

#pragma mark - CollectionView data source and delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (collectionView.tag == ROW_SCROLLVIEW_TAG) {
        return 1;
    } else{
        int count = 0;
        for (NSArray* productArray in self.collectionsOfProducts) {
            if (productArray.count > 0) {
                count++;
            }
        }
        return count;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == ROW_SCROLLVIEW_TAG) {
        int index = ((RowScrollingCollectionView*)collectionView).categoryIndex;
        NSInteger count = ((NSArray*)[self.collectionsOfProducts objectAtIndex:index]).count;
        return count > MAX_ITEM_PER_ROW ? MAX_ITEM_PER_ROW : count;
    } else{
        return 1;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"searchResultHeaderReusableView" forIndexPath:indexPath];
        UILabel* label = (UILabel*)[headerView viewWithTag:CATEGORY_LABEL_TAG];
        label.text = [self.categoryTitles objectAtIndex:indexPath.section];
        
        reusableview = headerView;
    }
    return reusableview;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == ROW_SCROLLVIEW_TAG) {
        
        static NSString *cellIdentifier = @"searchResultCell";
        UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Get the product:
        int indexOfCategory = ((RowScrollingCollectionView*)collectionView).categoryIndex;
        Product* product = [((NSArray*)[self.collectionsOfProducts objectAtIndex:indexOfCategory]) objectAtIndex:indexPath.row];
        
        RoundedUIImageView* imageView = (RoundedUIImageView*)[cell viewWithTag:ICON_TAG];
        [imageView goodRichSetImageWithURL: product.s3URL toSize:IMAGE_SIZE_SMALL];
        
        return cell;
        
    } else{
        
        static NSString *cellIdentifier = @"searchResultContainerCell";
        UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        RowScrollingCollectionView* collectionView = (RowScrollingCollectionView*)[cell viewWithTag:ROW_SCROLLVIEW_TAG];
        
        collectionView.categoryIndex = (int)indexPath.section;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView reloadData];
        
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == ROW_SCROLLVIEW_TAG) {
        int index = ((RowScrollingCollectionView*)collectionView).categoryIndex;
        Product* product = [((NSArray*)[self.collectionsOfProducts objectAtIndex:index]) objectAtIndex:indexPath.row];
        
        ItemDetailsViewController* vc = (ItemDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailsViewController"];
        vc.productName = product.productName;
        vc.delegate = nil;
        
        if (self.searchType == SEARCH_TYPE_TEXT) {
            [self.delegate itemButtonPressedWithViewController: vc];
        } else{
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else{
        NSLog(@"Dude, you've clicked the wrong collectionview");
    }
}

#pragma mark - Buttons clicked

- (IBAction)editSearchButtonClicked:(UIButton *)sender {
    switch (self.searchType) {
        case SEARCH_TYPE_COLOR:{
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }case SEARCH_TYPE_IMAGE:{
            ImageSearchRefineViewController* vc = (ImageSearchRefineViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ImageSearchRefineViewController"];
            vc.imageToCrop = self.imageToSearch;
            vc.imageFrameToCrop = self.imageFrameToCrop;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }default:
            NSLog(@"Error: wrong searchType in search result page");
            break;
    }
}

- (IBAction)viewAllButtonClicked:(UIButton*)sender{
    
    int titleIndex = (int)sender.tag - BASE_TAG;
    NSString * categoryTitle = @"Wallcovering";
    switch (titleIndex) {
        case 0:
            categoryTitle = @"Wallcovering";
            break;
        case 1:
            categoryTitle = @"Carpet";
            break;
        case 2:
            categoryTitle = @"Fabric";
            break;
        default:
            categoryTitle = @"Flooring";
            break;
    }
    
    NSString* categoryKey = [[DataClient sharedInstance] getCategoryKeyWithRepresentationString:categoryTitle];
    
    BrowsingItemsViewController* vc = (BrowsingItemsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrowsingItemsViewController"];
    vc.categoryToSearch = categoryKey;
    switch (self.searchType) {
        case SEARCH_TYPE_COLOR:{
            vc.browingType = BROWSING_ITEMS_TYPE_SEARCH_RESULT_COLOR;
            vc.colorToSearch = self.colorToSearch;
            [DataClient sharedInstance].currentCategory = categoryKey;
            [DataClient sharedInstance].isMultiSelection = false;
            break;
        }
        case SEARCH_TYPE_TEXT:{
            vc.browingType = BROWSING_ITEMS_TYPE_SEARCH_RESULT_TEXT;
            vc.keywordToSearch = self.keywordToSearch;
            [self.delegate allButtonPressedWithViewController: vc];
            [DataClient sharedInstance].currentCategory = categoryKey;
            [DataClient sharedInstance].isMultiSelection = true;
            return;
            break;
        }
        case SEARCH_TYPE_IMAGE:{
            vc.browingType = BROWSING_ITEMS_TYPE_SEARCH_RESULT_IMAGE;
            vc.imageToSearch = self.imageToSearch;
            vc.imageFrameToCrop = self.imageFrameToCrop;
            [DataClient sharedInstance].currentCategory = categoryKey;
            [DataClient sharedInstance].isMultiSelection = false;
            break;
        }default:
            // For pattern and ID search, they won't use this page to show results.
            NSLog(@"Error: wrong searchType in search result page");
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
    [Flurry logEvent:@"all button clicked"];
}

#pragma mark - Delegates

- (void)searchResultReturnedWithSearchType: (SEARCH_TYPE)searchType
                           andSearchResult: (NSArray*)products
                          andImageToSearch: (UIImage*)image
                       andImageFrameToCrop: (CGRect)imageFrameToCrop{
    
    self.searchType = searchType;
    self.products = products;
    self.imageToSearch = image;
    self.imageFrameToCrop = imageFrameToCrop;
    
    // Pop to self:
    [self.navigationController popToViewController:self animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [self reInitDataAndReloadView];
}

#pragma mark - Others

- (BOOL)isHomeButtonDisplayed {
    return YES;
}

@end

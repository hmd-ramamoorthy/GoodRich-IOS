//
//  BrowsingItemsViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define COLLECTION_VIEW_CELL_WIDTH 135
#define COLLECTION_VIEW_CELL_HEIGHT 175

#define NAVIGATION_BAR_HEIGHT 64

#define COLLECTION_VIEW_HEADER_WIDTH 50
#define COLLECTION_VIEW_HEADER_HEIGHT 196

#define LIKE_BUTTON_TAG 5341
#define IMAGE_VIEW_TAG 5343
#define FIND_SIMILAR_BUTOTN_TAG 5345
#define NAME_LABEL_TAG 5347

#import "BrowsingItemsViewController.h"
#import "EmailModel.h"
#import "EmailShareController.h"

static CGFloat const ExtraSpaceForRefineButton = 45;

@interface BrowsingItemsViewController ()

// Auto-increment when load data from server
@property (nonatomic) int currentPage;

// self.collectionView will retrieve data from this:
@property (strong, nonatomic) NSMutableArray* productsToBeDisplayed;

// Data storage:
@property (strong, nonatomic) NSMutableArray* allProducts;
@property (strong, nonatomic) NSMutableArray* currentFacets;
@property (strong, nonatomic) NSMutableArray* userLikedProducts;
@property (strong, nonatomic) NSMutableArray* productsSelectedToShare;

// Set to YES when load begins
// Set to NO in stopActivity... function
@property (nonatomic) BOOL isLoadingNextPage;

@property (strong, nonatomic) NSMutableArray* facets;

// SearchKeyDisplayPanel
@property (strong, nonatomic) SearchKeyDisplayView* searchKeyDisplayView;

@property (nonatomic) BOOL isMultipleSelecting;

@end

@implementation BrowsingItemsViewController {
    UIBarButtonItem *backBtnReference;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.productsToBeDisplayed = [[NSMutableArray alloc] init];
    self.allProducts = [[NSMutableArray alloc] init];
    self.userLikedProducts = [[NSMutableArray alloc] init];
    self.facets = [[NSMutableArray alloc] init];
    self.productsSelectedToShare = [[NSMutableArray alloc] init];
    self.currentPage = 0;
    self.isMultipleSelecting = NO;
    
    [self renderFacetViewController];
    [self updateEmptyContentFeedback];
    [self renderDropDownList];
    [self renderDataLoadingExceptionView];
    [self renderSearchKeyDisplayView];
    
    // Trigger the loading of data:
    [self retryButtonClicked:nil];
    
    [self.refineButton setHidden:YES];
    self.currentFacets = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarheight = self.navigationController.navigationBar.frame.size.height;
    CGRect bounds = [self.view bounds];
    bounds.size.height = screenHeight - statusBarHeight - navBarheight;
    
    [self.collectionView setFrame:bounds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"item will disappear");
    for (UIView* view in self.view.subviews) {
        if (view.tag == -1) {
            [view removeFromSuperview];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.currentPage = 0;
    [self.allProducts removeAllObjects];
    [self.productsToBeDisplayed removeAllObjects];
    if (self.productsToBeDisplayed.count > 0) {
        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
    [self stopActivityAndShouldShowError:YES];
    
    [self handleFailedRequestWithErrors:@[@"Oops. Memory is not enough. Please close some other apps."] withType:REQUEST_TYPE_SINGLE_REQUEST];
    
    // Show the error message:
    self.dataLoadingExceptionView.hidden = NO;
    [self.dataLoadingExceptionView switchToMode:DATA_LOADING_EXCEPTION_TYPE_ERROR];
    [self.view bringSubviewToFront:self.dataLoadingExceptionView];
}

#pragma mark - Render Views

- (void)renderFacetViewController{
    // Initialize facetViewController:
    if (self.facetViewController == nil) {
        self.facetViewController = (FacetViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FacetViewController"];
        [self.facetViewController initDataModel];
        if (self.patternTypeToSearch != nil) {
            [self.facetViewController.filter setFilterWithFilterName:@"PatternStyle" andFilterValues:[NSArray arrayWithObject: self.patternTypeToSearch]];
        }
        if (self.categoryToSearch != nil) {
            [self.facetViewController.filter setFilterWithFilterName:@"Category" andFilterValues:[NSArray arrayWithObject: self.categoryToSearch]];
        }
        self.facetViewController.delegate = self;
    }
}

- (void)renderDropDownList{
    switch (self.browingType) {
        case BROWSING_ITEMS_TYPE_ALL:{
            // Render and hide the dropdown list:
            self.dropDownMenuView = [CategoryDropdownMenuView categoryDropdownMenuView];
            self.dropDownMenuView.frame = CGRectMake(0,0,
                                                     [self getScreenWidth],
                                                     [self getScreenHeight]);
            [self.view addSubview: self.dropDownMenuView];
            self.dropDownMenuView.delegate = self;
            // Initially, it's in "out" position, we hide it and toggle it, just to make it into "in" position:
            self.dropDownMenuView.hidden = YES;
            [self toggleDropDownListView];
            [self setTitleToTitleLabel: CATEGORY_TITLE_VIEW_ALL];
            break;
        }
        case BROWSING_ITEMS_TYPE_FAVOURITE:{
            [self ableToOpenDropDownMenu: NO];
            [self setTitleToTitleLabel: @"My Favorites"];
            UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(multiMode:)];
            [selectButton setTintColor:[UIColor whiteColor]];
            self.navigationItem.rightBarButtonItem = selectButton;
            break;
        }
        case BROWSING_ITEMS_TYPE_SIMILAR_ITEM:{
            [self ableToOpenDropDownMenu: NO];
            [self setTitleToTitleLabel: @"Similar Result"];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_PATTERN:{
            [self ableToOpenDropDownMenu: NO];
            [self setTitleToTitleLabel: [NSString stringWithFormat: @"Search Result: %@", [[DataClient sharedInstance] getRepresentationStringWithCategoryKey: self.categoryToSearch]]];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_COLOR:{
            [self ableToOpenDropDownMenu: NO];
            [self setTitleToTitleLabel: [NSString stringWithFormat: @"Search Result: %@", [[DataClient sharedInstance] getRepresentationStringWithCategoryKey: self.categoryToSearch]]];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_TEXT:{
            [self ableToOpenDropDownMenu: NO];
            [self setTitleToTitleLabel: [NSString stringWithFormat: @"Search Result: %@", [[DataClient sharedInstance] getRepresentationStringWithCategoryKey: self.categoryToSearch]]];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_IMAGE:{
            [self ableToOpenDropDownMenu: NO];
            [self setTitleToTitleLabel: @"Search Result"];
            break;
        }
        default:
            break;
    }
}

- (void) renderSearchKeyDisplayView{
    switch (self.browingType) {
        case BROWSING_ITEMS_TYPE_ALL:
        case BROWSING_ITEMS_TYPE_FAVOURITE:{
            // Do nothing here.
            break;
        }
        case BROWSING_ITEMS_TYPE_SIMILAR_ITEM:{
            // Do nothing here.
            // Header is added when the collectionViewController renders its view.
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_PATTERN:{
            [self renderSearchKeyDisplayPanelWithText:self.patternTypeToSearch];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_COLOR:{
            [self renderSearchKeyDisplayPanelWithText:[self.colorToSearch getDisplayStringFromColor]];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_TEXT:{
            [self renderSearchKeyDisplayPanelWithText:[NSString stringWithFormat:@"Keywords: %@",  self.keywordToSearch]];
            break;
        }
        default:
            break;
    }
}

- (void)renderSearchKeyDisplayPanelWithText: (NSString*)title{
    
    self.searchKeyDisplayView = [SearchKeyDisplayView searchKeyDisplayView];
    self.searchKeyDisplayView.frame = CGRectMake(0,
                                                 NAVIGATION_BAR_HEIGHT,
                                                 [self getScreenWidth],
                                                 self.searchKeyDisplayView.frame.size.height);
    
    [self.view addSubview: self.searchKeyDisplayView];
    [self.searchKeyDisplayView switchToType:self.browingType
                               withKeyTitle:title
                           andColorToSearch:self.colorToSearch
                         andProductToSearch:self.productToSearch];
}

- (void) ableToOpenDropDownMenu: (BOOL) ableTo{
    self.dropDownIcon.hidden = !ableTo;
    self.dropDownButton.userInteractionEnabled = ableTo;
}

- (void) renderDataLoadingExceptionView{
    self.dataLoadingExceptionView = [DataLoadingExceptionView dataLoadingExceptionView];
    self.dataLoadingExceptionView.frame = CGRectMake(0,
                                                     0,
                                                     [self getScreenWidth],
                                                     [self getScreenHeight]);
    [self.view addSubview: self.dataLoadingExceptionView];
    self.dataLoadingExceptionView.delegate = self;
    self.dataLoadingExceptionView.hidden = YES;
}

#pragma mark - Load and display Data

- (void)loadProductsDataFromServer{
    
    self.dataLoadingExceptionView.hidden = YES;
    self.currentPage += 1;
    self.isLoadingNextPage = YES;
    NSMutableArray * facets = [[NSMutableArray alloc] init];
    NSString* key =  [DataClient sharedInstance].currentCategory;
    
    if (key!=nil){
        NSDictionary* refineFieldList = [DataClient sharedInstance].refineFieldList;
        NSArray * list = [refineFieldList objectForKey:key];
        for (Facet *facet in list) {
            [facets addObject:facet.facetKey];
        }
    }else {
        facets = nil;
    }
    
    if (self.browingType == BROWSING_ITEMS_TYPE_SIMILAR_ITEM) {
        [self.facetViewController.filter setFilterWithFilterName:@"Category" andFilterValues:[NSArray arrayWithObject: self.categoryToSearch]];
    }
    
    [[SearchClient sharedInstance] searchForBrowingWithType:self.browingType
                                              andIdToSearch:self.productToSearch.productName
                                           andcolorToSearch:self.colorToSearch
                                           andimageToSearch:self.imageToSearch
                                         andkeywordToSearch:self.keywordToSearch
                                              andFieldQuery:self.facetViewController.filter
                                               andFieldList:[NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil]
                                                andPriority:self.facetViewController.priority
                                                   andFacet:facets
                                                   andLimit:20
                                                    andPage:self.currentPage
                                            andCroppedFrame:self.imageFrameToCrop
                                                    success:^(NSDictionary *responseObject) {
                                                        
                                                        for (NSDictionary* dict in responseObject[@"result"]) {
                                                            [self.allProducts addObject:[Product productFromDictionary:dict andKeyForSpecs:@"user_fields"]];
                                                        }
                                                        // At first page, remove all facets and reload:
                                                        if (self.currentPage == 1) {
                                                            [self.facets removeAllObjects];
                                                            NSString* categoryKey = [self.facetViewController.filter getFilterValueByKey:@"Category"];
                                                            if (categoryKey != nil) {
                                                                NSMutableArray *newFacets = [[NSMutableArray alloc] init];
                                                                NSDictionary* facetDicts = nil;
                                                                if(responseObject[@"facets"]!=nil){
                                                                    facetDicts = responseObject[@"facets"];
                                                                    for (NSDictionary* facetDict in facetDicts) {
                                                                        Facet* newFacet = [Facet FacetFromNotSearch:facetDict];
                                                                        [newFacets addObject:newFacet];
                                                                    }
                                                                }else if(responseObject[@"facet"]!=nil){
                                                                    facetDicts = responseObject[@"facet"];
                                                                    for (NSDictionary* facetDict in facetDicts) {
                                                                        Facet* newFacet = [Facet FacetFromBrowsing:facetDict];
                                                                        [newFacets addObject:newFacet];
                                                                    }
                                                                }
                                                                NSMutableDictionary * refineFieldList = [NSMutableDictionary dictionaryWithDictionary: [DataClient sharedInstance].refineFieldList];
                                                                [refineFieldList setObject:[NSArray arrayWithArray: newFacets] forKey: categoryKey];
                                                                [self.facets addObjectsFromArray: [[NSDictionary dictionaryWithDictionary: refineFieldList] objectForKey:categoryKey]];
                                                                // This will cause facetViewController to reload its tableView.
                                                                if (self.facetViewController.view.superview != self.view) {
                                                                    [self.view addSubview:self.facetViewController.view];
                                                                }
                                                                [self.facetViewController setFacets: self.facets];
                                                                [self resetRefineViewPosition];
                                                            }
                                                        }
                                                        [self updateRefineButton];
                                                        [self loadLikesDataFromServer];
                                                        
                                                    } failure:^(NSArray *errors) {
                                                        [self stopActivityAndShouldShowError:YES];
                                                        [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
                                                    }];
}

- (void)loadLikesDataFromServer{
    [[HTTPClient sharedInstance] getOrSetFavourites:FAVORITE_REQUEST_TYPE_GET andProductID:nil andSuccess:^(NSInteger statusCode, id responseObject) {
        [self.userLikedProducts removeAllObjects];
        for (NSDictionary* dict in responseObject[@"result"]) {
            [self.userLikedProducts addObject:[Product productFromDictionary:dict andKeyForSpecs:@"value_map"]];
        }
        [self stopActivityAndShouldShowError:NO];
        [self applyFiltersAndDisplayProducts];
        
    } failure:^(NSInteger statusCode, NSArray *errors) {
        [self stopActivityAndShouldShowError:YES];
        [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
    }];
}

- (void)applyFiltersAndDisplayProducts{
    [self.productsToBeDisplayed removeAllObjects];
    switch (self.browingType) {
        case BROWSING_ITEMS_TYPE_FAVOURITE:{
            [self.productsToBeDisplayed addObjectsFromArray:self.userLikedProducts];
        }
            break;
        default:{
            [self.productsToBeDisplayed addObjectsFromArray:self.allProducts];
            break;
        }
    }
    [self updateEmptyContentFeedback];
    [self.collectionView reloadData];
    
    if (self.currentPage == 1) {
        if (!self.searchKeyDisplayView.hidden) {
            [self.collectionView setContentInset: UIEdgeInsetsMake(self.searchKeyDisplayView.frame.size.height, 0, 0, 0)];
            [self.collectionView setContentOffset:CGPointMake(0, - (self.searchKeyDisplayView.frame.size.height))];
        } else{
            [self.collectionView setContentOffset: CGPointMake(0, -NAVIGATION_BAR_HEIGHT)];
        }
    }
}

#pragma mark - CollectionView data source and delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.productsToBeDisplayed.count > 0 ? 1 : 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.productsToBeDisplayed count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Product *product;
    
    // Comparing NSInteger will fail. Need to convert to int.
    if ((int)indexPath.row > (int)self.productsToBeDisplayed.count - 1) {
        product = nil;
    } else{
        product = [self.productsToBeDisplayed objectAtIndex:indexPath.row];
    }
    
    static NSString *cellIdentifier = @"ProductCollectionViewCell";
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:NAME_LABEL_TAG];
    NSString * patternNumber = [product.specifications objectForKey:@"PatternNumber"];
    if (patternNumber == nil)
        patternNumber = [product.specifications objectForKey:@"pattern_number"];
    [nameLabel setText:patternNumber];
    
    UIButton* likeButton = (UIButton*)[cell viewWithTag:LIKE_BUTTON_TAG];
    if (self.isMultipleSelecting) {
        [self renderLikeButtonImageWithUserSelected: [self.productsSelectedToShare containsObject:product] toButton:likeButton];
    } else{
        [self renderLikeButtonImageWithUserLiked:[self hasUserLikedProduct:product] toButton: likeButton];
    }
    
    UIButton* findSimilarButton = (UIButton*)[cell viewWithTag:FIND_SIMILAR_BUTOTN_TAG];
    if (self.isMultipleSelecting) {
        findSimilarButton.hidden = YES;
    }else{
        findSimilarButton.hidden = NO;
    }
    RoundedUIImageView* imageView = (RoundedUIImageView*)[cell viewWithTag:IMAGE_VIEW_TAG];
    [imageView goodRichSetImageWithURL: product.s3URL toSize:IMAGE_SIZE_THUMBNAIL];
    
    UILongPressGestureRecognizer* gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedAtCell:)];
    gestureRecognizer.minimumPressDuration = 1.0;
    [cell addGestureRecognizer: gestureRecognizer];
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"productDisplayReusableView" forIndexPath:indexPath];
    
    // Display the product to search in the header:
    if (kind == UICollectionElementKindSectionHeader && self.browingType == BROWSING_ITEMS_TYPE_SIMILAR_ITEM) {
        UILabel* label = (UILabel*)[reusableview viewWithTag:90];
        label.text = self.productToSearch.productName;
        
        RoundedUIImageView* imageView = (RoundedUIImageView*)[reusableview viewWithTag:IMAGE_VIEW_TAG];
        [imageView goodRichSetImageWithURL: self.productToSearch.s3URL toSize:IMAGE_SIZE_THUMBNAIL];
    } else{
        reusableview.frame = CGRectZero;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.browingType == BROWSING_ITEMS_TYPE_SIMILAR_ITEM) {
        return CGSizeMake(COLLECTION_VIEW_CELL_WIDTH, COLLECTION_VIEW_CELL_HEIGHT);
    } else{
        return CGSizeMake(0, 0);
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Product* product = [self getProductFromDisplayByIndexPath:indexPath];
    
    if (self.browingType == BROWSING_ITEMS_TYPE_FAVOURITE &&  self.isMultipleSelecting) {
        
        UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        UIButton* likeButton = (UIButton*)[cell viewWithTag: LIKE_BUTTON_TAG];
        if ([self.productsSelectedToShare containsObject: product]){
            [self.productsSelectedToShare removeObject: product];
            [self renderLikeButtonImageWithUserSelected:NO toButton:likeButton];
        } else{
            [self.productsSelectedToShare addObject: product];
            [self renderLikeButtonImageWithUserSelected:YES toButton:likeButton];
        }
        if([self.productsSelectedToShare count] > 0){
            UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
            [shareButton setTintColor:[UIColor whiteColor]];
            self.navigationItem.rightBarButtonItem = shareButton;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    } else{
        
        ItemDetailsViewController* vc = (ItemDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailsViewController"];
        vc.productName = product.productName;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// Delegate to inform the app to load the next page.
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // Hide the top view for display:
    if (scrollView.contentOffset.y > 0) {
        [self.searchKeyDisplayView hide];
    } else{
        [self.searchKeyDisplayView show];
    }
    
    // If loading next page, or the current page has nothing to show, don't load the next page.
    if (self.isLoadingNextPage == YES || self.productsToBeDisplayed.count == 0) {
        return;
    }
    
    switch (self.browingType) {
        case BROWSING_ITEMS_TYPE_FAVOURITE:
            return;
            break;
        default:{
            CGFloat offsetY = scrollView.contentOffset.y;
            CGFloat contentHeight = scrollView.contentSize.height;
            if (offsetY > contentHeight - scrollView.frame.size.height){
                //[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + 20) animated:YES];
                if (self.refineButton.hidden) {
                    [self.view makeSpinnerActivityAtPoint:CGPointMake([self getScreenWidth]/2, [self getScreenHeight] - 20)];
                } else{
                    [self.view makeSpinnerActivityAtPoint:CGPointMake([self getScreenWidth]/2, [self getScreenHeight] - 25 - self.refineButton.frame.size.height)];
                }
                
                [self loadProductsDataFromServer];
            }
            break;
        }
    }
}

- (void)renderLikeButtonImageWithUserSelected: (BOOL)hasUserSlected toButton: (UIButton*)likeButton{
    if (hasUserSlected) {
        UIImage *btnImage = [UIImage imageNamed: @"filter_options_selected.png"];
        [likeButton setImage:btnImage forState:UIControlStateNormal];
    } else{
        UIImage *btnImage = [UIImage imageNamed:@"filter_options.png"];
        [likeButton setImage: btnImage forState:UIControlStateNormal];
    }
    likeButton.frame = CGRectMake(likeButton.frame.origin.x,
                                  likeButton.frame.origin.y,
                                  23,
                                  23);
}

- (void)renderLikeButtonImageWithUserLiked: (BOOL)hasUserLiked toButton: (UIButton*)likeButton{
    if (hasUserLiked) {
        UIImage *btnImage = [UIImage imageNamed:@"Brosing_fav_icon_selected.png"];
        [likeButton setImage:btnImage forState:UIControlStateNormal];
    } else{
        UIImage *btnImage = [UIImage imageNamed:@"Brosing_fav_icon.png"];
        [likeButton setImage:btnImage forState:UIControlStateNormal];
    }
    likeButton.frame = CGRectMake(likeButton.frame.origin.x,
                                  likeButton.frame.origin.y,
                                  26,
                                  23);
}

- (void)updateEmptyContentFeedback{
    if (self.productsToBeDisplayed.count > 0) {
        
        self.dataLoadingExceptionView.hidden = YES;
        
    } else{
        
        self.dataLoadingExceptionView.hidden = NO;
        self.refineButton.hidden = YES; //added by YU LU: refine button not work when there is no data returned (facet has no data), hide the button.
        [self.view bringSubviewToFront:self.dataLoadingExceptionView];
        
        switch (self.browingType) {
            case BROWSING_ITEMS_TYPE_FAVOURITE:{
                [self.dataLoadingExceptionView switchToMode:DATA_LOADING_EXCEPTION_TYPE_NO_FAV];
                break;
            }
            case BROWSING_ITEMS_TYPE_SIMILAR_ITEM:{
                [self.dataLoadingExceptionView switchToMode:DATA_LOADING_EXCEPTION_TYPE_NO_SIMILAR];
                break;
            }
            default:
            case BROWSING_ITEMS_TYPE_ALL:{
                [self.dataLoadingExceptionView switchToMode:DATA_LOADING_EXCEPTION_TYPE_NO_MATCH];
                //changed by YU LU: cannot bring this button to front, it will then be on top of the refine menu..
                //                [self.view bringSubviewToFront: self.refineButton];
                break;
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Button clicked

- (IBAction)dropDownButtonClicked:(UIButton *)sender {
    [self toggleDropDownListView];
}

- (void) toggleDropDownListView{
    if ([self isRefineListShown]) {
        [self toggleRefindList];
    }
    
    [self.view bringSubviewToFront: self.dropDownMenuView];
    CGFloat rotateAngle = [self.dropDownMenuView isDropDownMenuShowing] ? -M_PI : M_PI;
    
    [self.dropDownIcon rotateWithDuration:0.3 byAngle:rotateAngle];
    [self.dropDownMenuView toggleDropDownListView];
}

- (IBAction)likeButtonPressed:(UIButton *)sender {
    Product *product = [self getProductFromDisplayByButton:sender];
    
    
    if(self.isMultipleSelecting == YES){
        // TODO: may need to check iOS version
        UICollectionViewCell *cell = (UICollectionViewCell *)[[sender superview]superview];
        NSIndexPath *path = [self.collectionView indexPathForCell:cell];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:path];
        //        NSURL *url = [NSURL URLWithString:product.s3URL];
        //        if ([self.productsSelectedToShare containsObject: url]){
        //            [self.productsSelectedToShare removeObject: url];
        //            [self renderLikeButtonImageWithUserSelected:NO toButton: sender];
        //        } else{
        //            [self.productsSelectedToShare addObject: url];
        //            [self renderLikeButtonImageWithUserSelected:YES toButton: sender];
        //        }
        //        if([self.productsSelectedToShare count] > 0){
        //            UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
        //            self.navigationItem.rightBarButtonItem = shareButton;
        //        }else{
        //            self.navigationItem.rightBarButtonItem = nil;
        //        }
        //        
    }else{
        
        BOOL hasUserLiked = [self hasUserLikedProduct:product];
        
        // Change the UI first:
        [self renderLikeButtonImageWithUserLiked:!hasUserLiked toButton:sender];
        
        FAVORITE_REQUEST_TYPE requestType = hasUserLiked ? FAVORITE_REQUEST_TYPE_REMOVE : FAVORITE_REQUEST_TYPE_SET;
        [[HTTPClient sharedInstance] getOrSetFavourites:requestType andProductID:product.productName andSuccess:^(NSInteger statusCode, id responseObject) {
            if (hasUserLiked) {
                [self removeProductFromFavoritesWithName:product.productName];
            } else{
                [self.userLikedProducts addObject:product];
            }
        } failure:^(NSInteger statusCode, NSArray *errors) {
            [self renderLikeButtonImageWithUserLiked:hasUserLiked toButton:sender];
            [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
        }];
    }
}

- (IBAction)findSimilarButtonPressed:(UIButton *)sender {
    
    Product *product = [self getProductFromDisplayByButton:sender];
    BrowsingItemsViewController* vc = (BrowsingItemsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrowsingItemsViewController"];
    vc.browingType = BROWSING_ITEMS_TYPE_SIMILAR_ITEM;
    vc.productToSearch = product;
    vc.categoryToSearch = [product.specifications objectForKey:@"Category"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)refineButtonClicked:(UIButton *)sender {
    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    
    if (self.facetViewController.view.superview != self.view) {
        [currentWindow addSubview: self.facetViewController.view];
        //        [self.view addSubview:self.facetViewController.view];
    }
    
    [currentWindow bringSubviewToFront:self.facetViewController.view];
    
    [self.view setNeedsLayout];
    [self resetRefineViewPosition];
    [self toggleRefindList];
    if(self.browingType == BROWSING_ITEMS_TYPE_SEARCH_RESULT_IMAGE){
        [self.facetViewController showSortByTab];
    }
}

- (void)resetRefineViewPosition{
    self.facetViewController.view.frame = CGRectMake(0,[self getScreenHeight],[self getScreenWidth],[self getScreenHeight]);
    
    
}

- (void)toggleRefindList{
    CGFloat yDistance = 0.0;
    if ([self isRefineListShown]) {
        yDistance = [self.facetViewController getMovingDistance];
        [self removeBlackView];
    } else{
        yDistance = -[self.facetViewController getMovingDistance];
        [self addBlackViewAtFrame:CGRectMake(0,
                                             0,
                                             self.facetViewController.view.frame.size.width,
                                             [self getScreenHeight] + yDistance)
           andSelectorWhenTouched:@selector(toggleRefindList)];
        //[self.view bringSubviewToFront:self.facetViewController.view];
    }
    
    CGRect newFrame = CGRectMake(0,
                                 self.facetViewController.view.frame.origin.y + yDistance,
                                 self.facetViewController.view.frame.size.width,
                                 self.facetViewController.view.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.facetViewController.view.frame = newFrame;
    } completion:nil];
}

- (BOOL)isRefineListShown{
    return self.facetViewController.view.frame.origin.y < [self getScreenHeight];
}

#pragma mark - Helpers

- (void)updateRefineButton{
    if (self.facets == nil || self.facets.count == 0) {
        self.refineButton.hidden = YES;
    } else {
        self.refineButton.hidden = NO;
    }
}

- (void)removeProductFromFavoritesWithName: (NSString*)productName{
    [self.userLikedProducts removeObject:[self getProductFromFavoritesWithName:productName]];
}

- (Product*)getProductFromFavoritesWithName: (NSString*)productName{
    for (Product* product in self.userLikedProducts) {
        if ([product.productName isEqualToString:productName]) {
            return product;
        }
    }
    return nil;
}

- (Product*)getProductFromDisplayWithName: (NSString*)productName{
    for (Product* product in self.productsToBeDisplayed) {
        if ([product.productName isEqualToString:productName]) {
            return product;
        }
    }
    return nil;
}

- (Product*)getProductFromDisplayByIndexPath: (NSIndexPath*)indexPath{
    return [self.productsToBeDisplayed objectAtIndex:indexPath.row];
}

- (Product*)getProductFromDisplayByButton: (UIButton*)button{
    NSArray* cells = [self.collectionView visibleCells];
    for (UICollectionViewCell* cell in cells) {
        if ([cell viewWithTag:button.tag] == button) {
            return [self.productsToBeDisplayed objectAtIndex: [self.collectionView indexPathForCell:cell].row];
        }
    }
    return nil;
}

- (UIButton*)getLikeButtonByProductName: (NSString*)productName{
    NSArray* cells = [self.collectionView visibleCells];
    for (int i = 0; i < cells.count; i++) {
        UICollectionViewCell* cell = [cells objectAtIndex: i];
        UIButton* likeButton = (UIButton*)[cell viewWithTag:LIKE_BUTTON_TAG];
        Product* product = [self getProductFromDisplayByButton:likeButton];
        if ([productName isEqualToString:product.productName]) {
            return likeButton;
        }
    }
    return nil;
}


- (BOOL)hasUserLikedProduct: (Product*)product{
    for (Product*userLikedProduct in self.userLikedProducts) {
        if ([product.productName isEqualToString:userLikedProduct.productName]){
            return YES;
        }
    }
    return NO;
}

- (void)stopActivityAndShouldShowError: (BOOL)shouldShowError{
    [self.view hideSpinnerActivity];
    
    self.dataLoadingExceptionView.hidden = !shouldShowError;
    [self.dataLoadingExceptionView switchToMode:DATA_LOADING_EXCEPTION_TYPE_ERROR];
    [self.view bringSubviewToFront:self.dataLoadingExceptionView];
    
    self.isLoadingNextPage = NO;
}

- (void)reloadAllData{
    self.currentPage = 0;
    [self.allProducts removeAllObjects];
    [self.productsToBeDisplayed removeAllObjects];
    [self.collectionView reloadData];
    
    //if (self.productsToBeDisplayed.count > 0) {
    //    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
    //}
    
    self.collectionView.contentOffset = CGPointMake(0, 0);
    
    [self.view makeSpinnerActivity];
    [self loadProductsDataFromServer];
}

- (void) userLikedOrCanceledProductWithName: (NSString*) productName hasLiked: (BOOL) hasLiked{
    
    Product *product = [self getProductFromDisplayWithName:productName];
    // Change the UI:
    [self renderLikeButtonImageWithUserLiked:hasLiked toButton:[self getLikeButtonByProductName:productName]];
    
    // Chagnge the model:
    if (hasLiked) {
        [self.userLikedProducts addObject:product];
    } else{
        [self removeProductFromFavoritesWithName:product.productName];
        
    }
}

#pragma mark - Delegae

- (void)facetDidApply{
    [self toggleRefindList];
    [self reloadAllData];
}
- (void)facetDidCanceled{
    [self toggleRefindList];
}

- (void)setTitleToTitleLabel: (NSString*)title {
    
    self.titleLabel.text = title;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(self.navigationView.frame.size.width/2,
                                         self.titleLabel.frame.size.height/2 + 7);
    
    CGRect frame = self.titleLabel.frame;
    self.dropDownIcon.frame = CGRectMake(frame.origin.x + frame.size.width + 5,
                                         self.dropDownIcon.frame.origin.y,
                                         self.dropDownIcon.frame.size.width,
                                         self.dropDownIcon.frame.size.height);
}

- (void)dropDownItemButtonClicked:(UIButton *)sender {
    
    [self setTitleToTitleLabel:sender.titleLabel.text];
    
    // Add "Category" condition:
    if ([sender.titleLabel.text isEqualToString:CATEGORY_TITLE_VIEW_ALL]) {
        [self.facetViewController.filter removeFilterWithFilterName:@"Category"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"all", @"category",
                                nil];
        [Flurry logEvent:@"category changed" withParameters:params];
    } else{
        NSString* filterValue = [[DataClient sharedInstance] getCategoryKeyWithRepresentationString:sender.titleLabel.text];
        [DataClient sharedInstance].currentCategory = filterValue;
        [self.facetViewController.filter setFilterWithFilterName:@"Category" andFilterValues:[NSArray arrayWithObject:filterValue]];
        [DataClient sharedInstance].currentCategory = filterValue;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSArray arrayWithObject:filterValue], @"category",
                                nil];
        [DataClient sharedInstance].isMultiSelection = true;
        [Flurry logEvent:@"category changed" withParameters:params];
    }
    
    // Remove the existing other facet filtering conditions:
    for (Facet* facet in self.facets) {
        [self.facetViewController.filter removeFilterWithFilterName:facet.facetKey];
    }
    
    [self toggleDropDownListView];
    
    [self reloadAllData];
}

- (void)retryButtonClicked:(id)sender {
    [self reloadAllData];
}

- (void)longPressedAtCell:(UILongPressGestureRecognizer*)gestureRecognizer{
    // Long press is only valid when the user is browing fav items:
    if (self.browingType != BROWSING_ITEMS_TYPE_FAVOURITE ||
        self.isMultipleSelecting) {
        return;
    }
    else {
        self.isMultipleSelecting = YES;
        self.productsSelectedToShare = [[NSMutableArray alloc] init];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
        [cancelButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = cancelButton;
        [self.collectionView reloadData];
    }
}

- (void)share:(id)sender {
    [self prepareSendingProducts:self.productsSelectedToShare];
    [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)cancel:(id)sender {
    self.isMultipleSelecting = NO;
    self.navigationItem.leftBarButtonItem = backBtnReference;
    self.navigationItem.rightBarButtonItem = nil;
    [self.collectionView reloadData];
    if (self.browingType == BROWSING_ITEMS_TYPE_FAVOURITE){
        UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(multiMode:)];
        [selectButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = selectButton;
    }
}

- (void)multiMode:(id)sender {
    self.isMultipleSelecting = YES;
    self.productsSelectedToShare = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = nil;
    [cancelButton setTintColor:[UIColor whiteColor]];
    backBtnReference = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = cancelButton;
    [self.collectionView reloadData];
}

#pragma mark - override Template View Controller

- (BOOL)isHomeButtonDisplayed {
    return (self.browingType != BROWSING_ITEMS_TYPE_ALL) ? YES : NO;
}

@end

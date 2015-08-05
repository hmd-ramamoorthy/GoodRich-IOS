//
//  ItemDetailsViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define IMAGE_VIEW_TAG 1234

#define INITIAL_PADDING_TOP 10
#define KEY_LABEL_LEFT_MARGIN 30
#define VALIE_LABEL_LEFT_MARGIN 0
#define LABEL_HIGHT 20
#define KEY_WIDTH 95
#define VALUE_WIDTH 185
#define VISENZE_URL @"\nPowered by ViSenze\n http://www.visenze.com"

#import "ItemDetailsViewController.h"
#import "EmailShareController.h"
#import "EmailModel.h"

@interface ItemDetailsViewController ()

@property (strong, nonatomic) NSMutableArray* sameCollectionProducts;
@property (strong, nonatomic) NSMutableArray* similarProducts;
@property (strong, nonatomic) NSMutableArray* productDetails;
@property (strong, nonatomic) NSMutableArray* productKeys;
@property (strong, nonatomic) Product* productToBeDisplayed;
@property (nonatomic) BOOL hasUserLiked;

@end

@implementation ItemDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAndRenderViews];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarheight = self.navigationController.navigationBar.frame.size.height;
    CGRect bounds = [self.view bounds];
    bounds.size.height = screenHeight - statusBarHeight - navBarheight;
    
    [self.scrollView setFrame:bounds];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"item will disappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Render Views

- (void)loadAndRenderViews{
    [self.view makeSpinnerActivity];
    [Flurry logEvent:@"detail viewed"];
    // Get Product details:
    [[HTTPClient sharedInstance] getProductDetailsWithName:self.productName andSuccess:^(NSInteger statusCode, id responseObject) {
        
        self.productToBeDisplayed = [Product productFromDictionary:responseObject andKeyForSpecs:@"result"];
        self.productToBeDisplayed.productName = [self.productToBeDisplayed.specifications objectForKey: @"im_name"];
        
        // Get Like data:
        [[HTTPClient sharedInstance] getOrSetFavourites:FAVORITE_REQUEST_TYPE_GET andProductID:nil andSuccess:^(NSInteger statusCode, id responseObject) {
            for (NSDictionary* dict in responseObject[@"result"]) {
                if ([dict[@"im_name"] isEqualToString: self.productName]){
                    self.hasUserLiked = YES;
                    break;
                } else{
                    self.hasUserLiked = NO;
                }
            }
            [self renderProductView];
            [self loadSimilarProducts];
            [self loadSameCollectionProducts];
            
            [self renderLikeButtonImageWithUserLiked:self.hasUserLiked toButton:self.likeButton];
            
        } failure:^(NSInteger statusCode, NSArray *errors) {
            [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
        }];
        
    } failure:^(NSInteger statusCode, NSArray *errors) {
        [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
        [self.view hideSpinnerActivity];
    }];
}

- (void)loadSimilarProducts{
    [self.view hideSpinnerActivity];
    self.similarProducts = [[NSMutableArray alloc] init];
    NSString* cate = [self.productToBeDisplayed.specifications objectForKey:@"Category"];
    
    [[SearchClient sharedInstance] idSearch:self.productToBeDisplayed.productName
                              andFieldQuery:[[NSDictionary alloc] initWithObjectsAndKeys:
                                             cate ?: [NSNull null], @"Category",
                                             nil]
                               andFieldList:[NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil]
                                   andFacet:nil
                                   andLimit:IMAGE_COUNT_LIMIT
                                    andPage:1
                                andScoreMin: 0
                                andScoreMax: 1
                                    success:^(NSDictionary *responseObject) {
                                        for (NSDictionary* dict in responseObject[@"result"]) {
                                            [self.similarProducts addObject:[Product productFromDictionary:dict andKeyForSpecs:@"value_map"]];
                                            if (self.similarProducts.count >= MAX_ITEM_PER_ROW) {
                                                break;
                                            }
                                        }
                                        [self.similarItemsCollectionView reloadData];
                                    } failure:^(NSArray *errors) {
                                        [self.view hideSpinnerActivity];
                                        [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
                                    }];
}

- (void)loadSameCollectionProducts{
    [self.view hideSpinnerActivity];
    self.sameCollectionProducts = [[NSMutableArray alloc] init];
    [[HTTPClient sharedInstance] getProductInfoWithLimit:20
                                                 andPage:1
                                           andFieldQuery:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"Collection:%@", [self.productToBeDisplayed.specifications objectForKey: @"Collection"]],nil]
                                            andFieldList: [NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil]
                                                andFacet:nil
                                                 Success:^(NSInteger statusCode, id responseObject) {
                                                     
                                                     for (NSDictionary* dict in responseObject[@"result"]) {
                                                         [self.sameCollectionProducts addObject:[Product productFromDictionary:dict andKeyForSpecs:@"user_fields"]];
                                                         if (self.sameCollectionProducts.count >= MAX_ITEM_PER_ROW) {
                                                             break;
                                                         }
                                                     }
                                                     [self.sameCollectionCollectionView reloadData];
                                                     
                                                 } failure:^(NSInteger statusCode, NSArray *errors) {
                                                     [self.view hideSpinnerActivity];
                                                     [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
                                                 }];
}

- (void)renderProductView{
    [self.productIconImageView goodRichSetImageWithURL: [self.productToBeDisplayed.specifications objectForKey:@"im_url"] toSize:IMAGE_SIZE_MEDIUM];
    // Add gesture recognizer for double tapping the image:
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(productViewDoubleTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.productIconImageView addGestureRecognizer: tapGestureRecognizer];
    
    CGFloat startY = self.productIconImageView.frame.origin.y + self.productIconImageView.frame.size.height + INITIAL_PADDING_TOP;
    self.productKeys = [[NSMutableArray alloc] init];
    if([[self.productToBeDisplayed.specifications objectForKey:@"Category"] isEqualToString:@"wallcovering"]){
        [self.productKeys addObject:@"PatternNumber"];
        [self.productKeys addObject:@"Collection"];
        [self.productKeys addObject:@"ProductType"];
        [self.productKeys addObject:@"RollWidth"];
        [self.productKeys addObject:@"RollLength"];
        [self.productKeys addObject:@"Weight"];
        [self.productKeys addObject:@"Backing"];
        [self.productKeys addObject:@"PatternRepeat"];
        [self.productKeys addObject:@"FireRating"];
        [self.productKeys addObject:@"Supplier"];
        [self.productKeys addObject:@"Origin"];
        [self.productKeys addObject:@"PatternStyle"];
        [self.productKeys addObject:@"Category"];
    }else if([[self.productToBeDisplayed.specifications objectForKey:@"Category"] isEqualToString:@"fabric"]){
        [self.productKeys addObject:@"Color"];
        [self.productKeys addObject:@"PatternNumber"];
        [self.productKeys addObject:@"Collection"];
        [self.productKeys addObject:@"Width"];
        [self.productKeys addObject:@"Composition"];
        [self.productKeys addObject:@"Abrasion"];
        [self.productKeys addObject:@"PatternRepeat"];
        [self.productKeys addObject:@"Remarks"];
        [self.productKeys addObject:@"Supplier"];
        [self.productKeys addObject:@"Usage"];
        [self.productKeys addObject:@"PatternStyle"];
        [self.productKeys addObject:@"ProductType"];
        [self.productKeys addObject:@"Category"];
    }else if([[self.productToBeDisplayed.specifications objectForKey:@"Category"] isEqualToString:@"carpet"]){
        [self.productKeys addObject:@"PatternNumber"];
        [self.productKeys addObject:@"Collection"];
        [self.productKeys addObject:@"ProductType"];
        [self.productKeys addObject:@"Size/Width"];
        [self.productKeys addObject:@"PileWeight"];
        [self.productKeys addObject:@"DyeingMethod"];
        [self.productKeys addObject:@"Yarn"];
        [self.productKeys addObject:@"Backing"];
        [self.productKeys addObject:@"Construction"];
        [self.productKeys addObject:@"Supplier"];
        [self.productKeys addObject:@"PatternStyle"];
        [self.productKeys addObject:@"Category"];
    }else{
        [self.productKeys addObject:@"PatternNumber"];
        [self.productKeys addObject:@"Collection"];
        [self.productKeys addObject:@"ProductType"];
        [self.productKeys addObject:@"WoodSpecies"];
        [self.productKeys addObject:@"Size(Length-mm)"];
        [self.productKeys addObject:@"Size(Width-mm)"];
        [self.productKeys addObject:@"Size(sqm/UOM)"];
        [self.productKeys addObject:@"Size(Thickness-mm)"];
        [self.productKeys addObject:@"UOM"];
        [self.productKeys addObject:@"Supplier"];
        [self.productKeys addObject:@"CountryofOrigin"];
        [self.productKeys addObject:@"PatternStyle"];
        [self.productKeys addObject:@"Category"];
    }
    for (int i = 0; i < [self.productKeys count]; i++) {
        NSString* key = [self.productKeys objectAtIndex:i];
        NSString* value = [self.productToBeDisplayed.specifications objectForKey:key];
        
        if(value!=nil){
            UILabel* keyLabel = [self createAndFormatLabelWithText:key
                                                          andFrame:CGRectMake(KEY_LABEL_LEFT_MARGIN,
                                                                              startY,
                                                                              KEY_WIDTH,
                                                                              LABEL_HIGHT)
                                                          andColor:[UIColor whiteColor]];
            [self.scrollView addSubview:keyLabel];
            UILabel* valueLabel = [self createAndFormatLabelWithText:value
                                                            andFrame:CGRectMake(KEY_LABEL_LEFT_MARGIN + KEY_WIDTH + VALIE_LABEL_LEFT_MARGIN,
                                                                                startY,
                                                                                VALUE_WIDTH,
                                                                                LABEL_HIGHT)
                                                            andColor:[UIColor whiteColor]];
            [self.scrollView addSubview:valueLabel];
            
            startY += LABEL_HIGHT;
        }
    }
    
    CGRect frame = self.bottomView.frame;
    self.bottomView.frame = CGRectMake(frame.origin.x,
                                       startY+INITIAL_PADDING_TOP,
                                       frame.size.width,
                                       frame.size.height);
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                             startY + self.bottomView.frame.size.height);
}

- (UILabel*)createAndFormatLabelWithText: (NSString*)text
                                andFrame: (CGRect)frame
                                andColor: (UIColor*)color{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:11.0];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (BOOL) isKeyValidForDisplay: (NSString*)key{
    return !([key isEqualToString:@"im_url"] ||
             [key isEqualToString:@"im_name"] ||
             [key isEqualToString:@"time_update"] ||
             [[key substringToIndex:1] isEqualToString:@"_"]);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - CollectionView data source and delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.similarItemsCollectionView) {
        return self.similarProducts.count > 0 ? 1 : 0;
    } else{
        return self.sameCollectionProducts.count > 0 ? 1 : 0;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.similarItemsCollectionView) {
        return self.similarProducts.count;
    } else{
        return self.sameCollectionProducts.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    UICollectionViewCell *cell;
    Product* product;
    
    if (collectionView == self.sameCollectionCollectionView) {
        cellIdentifier = @"sameCollectionCell";
        cell = [self.sameCollectionCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        product = [self.sameCollectionProducts objectAtIndex:indexPath.row];
    } else{
        cellIdentifier = @"similarItemsCell";
        cell = [self.similarItemsCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        product = [self.similarProducts objectAtIndex:indexPath.row];
    }
    
    
    RoundedUIImageView* imageView = (RoundedUIImageView*)[cell viewWithTag:IMAGE_VIEW_TAG];
    [imageView goodRichSetImageWithURL: product.s3URL toSize:IMAGE_SIZE_THUMBNAIL];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Product* product;
    
    if (collectionView == self.similarItemsCollectionView) {
        product = [self.similarProducts objectAtIndex:indexPath.row];
        [Flurry logEvent: @"same collection item clicked"];
    } else{
        product = [self.sameCollectionProducts objectAtIndex:indexPath.row];
        [Flurry logEvent: @"similar item clicked"];
    }
    
    ItemDetailsViewController* vc = (ItemDetailsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailsViewController"];
    vc.productName = product.productName;
    vc.delegate = nil;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Helpers

- (IBAction)findSimilarButtonPressed:(id)sender {
    BrowsingItemsViewController* vc = (BrowsingItemsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrowsingItemsViewController"];
    vc.browingType = BROWSING_ITEMS_TYPE_SIMILAR_ITEM;
    vc.productToSearch = self.productToBeDisplayed;
    vc.categoryToSearch = [self.productToBeDisplayed.specifications objectForKey:@"Category"];
    
    [self.navigationController pushViewController:vc animated:YES];
    [Flurry logEvent:@"find similar button clicked"];
}

- (IBAction)likeButtonPressed:(UIButton *)sender {
    Product* product = self.productToBeDisplayed;
    BOOL hasUserLiked = self.hasUserLiked;
    
    // Change the UI first:
    [self renderLikeButtonImageWithUserLiked:!hasUserLiked toButton:sender];
    
    FAVORITE_REQUEST_TYPE requestType = hasUserLiked ? FAVORITE_REQUEST_TYPE_REMOVE : FAVORITE_REQUEST_TYPE_SET;
    if(hasUserLiked){
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"remove", @"action",
                                nil];
        [Flurry logEvent:@"favorite edited" withParameters:params];
    }
    else{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"add", @"action",
                                nil];
        [Flurry logEvent:@"favorite edited" withParameters:params];
    }
    [[HTTPClient sharedInstance] getOrSetFavourites:requestType andProductID:product.productName andSuccess:^(NSInteger statusCode, id responseObject) {
        self.hasUserLiked = !self.hasUserLiked;
        [self.delegate userLikedOrCanceledProductWithName:product.productName hasLiked:!hasUserLiked];
    } failure:^(NSInteger statusCode, NSArray *errors) {
        [self renderLikeButtonImageWithUserLiked:hasUserLiked toButton:sender];
        [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
    }];
}

- (void)renderLikeButtonImageWithUserLiked: (BOOL)hasUserLiked toButton: (UIButton*)likeButton{
    if (hasUserLiked) {
        UIImage *btnImage = [UIImage imageNamed:@"Brosing_fav_icon_selected.png"];
        [likeButton setImage:btnImage forState:UIControlStateNormal];
    } else{
        UIImage *btnImage = [UIImage imageNamed:@"Brosing_fav_icon.png"];
        [likeButton setImage:btnImage forState:UIControlStateNormal];
    }
}

- (IBAction)share:(id)sender {
    if (!self.productToBeDisplayed) {
        return;
    }
    
    [self prepareSendingProducts:@[self.productToBeDisplayed]];
    [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        
   /**
     This is the old part that sharing content with default iOS share sheet
    */
    //check network before proceeding
    //if (![AFNetworkReachabilityManager sharedManager].reachable) {
    //    [self handleFailedRequestWithErrors:nil withType:REQUEST_TYPE_SINGLE_REQUEST];
    //    return;
    //}
    
    //[self.view makeSpinnerActivity];
    //NSMutableArray *objectsToShare = [[NSMutableArray alloc]init];
    //NSMutableArray *idsToShare = [[NSMutableArray alloc] init];
    //RoundedUIImageView* roundedUIImage = [[RoundedUIImageView alloc]init];
    //_url = [roundedUIImage convertImageURLString: [self.productToBeDisplayed.specifications objectForKey:@"im_url"] toSizeOf:IMAGE_SIZE_SMALL];
    //[objectsToShare addObject:[UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]]]];
    //for (int i = 0; i < [self.productKeys count]; i++) {
//        NSString* key = [self.productKeys objectAtIndex:i];
//        NSString* value = [self.productToBeDisplayed.specifications objectForKey:key];
//        
//        if (value != nil)
//            [objectsToShare addObject:[[key stringByAppendingString:@":"] stringByAppendingString:value]];
//    }
//    //add ViSenze url
//    [objectsToShare addObject:VISENZE_URL];
//    
//    [idsToShare addObject:self.productToBeDisplayed.productName];
//    
//    // init and present the controller
//    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
//    [self presentViewController:controller animated:YES completion:nil];
    
    //    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmptmpimg.jpg"];
    //    [UIImageJPEGRepresentation([UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]]], 1.0) writeToFile:path atomically:YES];
    //    UIDocumentInteractionController *_documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
    //    _documentInteractionController.delegate = self;
    //    [_documentInteractionController presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    //update share history and flurry log
    
}

//- (void) documentInteractionController: (UIDocumentInteractionController *)controller
//                            willBeginSendingToApplication:(NSString *)application {
//    if ([self isWhatsApplication:application]) {
//        NSString* whatsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tmptmpimg.wai"];
//        [UIImageJPEGRepresentation([UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]]], 0.9) writeToFile:whatsPath atomically:YES];
//        controller.URL = [NSURL fileURLWithPath: whatsPath];
//        controller.UTI = @"net.whatsapp.image";
//    }
//}
//
//- (BOOL)isWhatsApplication:(NSString *)application {
//    if ([application rangeOfString:@"whats"].location == NSNotFound) {
//        return NO;
//    } else {
//        return YES;
//    }
//}

#pragma mark - Button Clicked or Gesture recognizer

- (void) productViewDoubleTapped{
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.productIconImageView.image;
    imageInfo.referenceRect = self.productIconImageView.frame;
    imageInfo.referenceView = self.productIconImageView.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

#pragma mark Others

- (BOOL)isHomeButtonDisplayed {
    return YES;
}

- (BOOL)isShareButtonDisplayed {
    return YES;
}

@end
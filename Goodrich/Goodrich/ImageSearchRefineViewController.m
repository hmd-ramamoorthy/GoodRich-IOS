//
//  ImageSearchRefineViewController.m
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define BORDER_BUTTON_LENGTH 80
#import "ImageSearchRefineViewController.h"

@interface ImageSearchRefineViewController ()

@property (strong, nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property (nonatomic) CGPoint originalCenter;
@property (nonatomic) CALayer* maskLayer;
@property (nonatomic) BOOL isSearchCanceled;

@property (nonatomic) BOOL shouldhideControls;

@end

@implementation ImageSearchRefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpGestureRecognizers];
    [self setUpViews];
    self.shouldhideControls = NO;
    self.cancelButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.shouldhideControls = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Render views

- (void)setUpGestureRecognizers{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(corpViewPanned:)];
    [self.cropView addGestureRecognizer: self.panGestureRecognizer];
}

- (void)setUpViews{
    //NSLog(@"%ld", self.imageToCrop.imageOrientation);
    self.imageView.image = self.imageToCrop;
    self.imageViewWithMask.image = self.imageToCrop;
    
    [self updateCropViewFrameTo:[self.imageView innerImageFrameInSuperview]];
    
    self.imageViewWithMask.alpha = 0.7;
    self.imageView.alpha = 1 - self.imageViewWithMask.alpha;
    
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = [self.view convertRect:[self.imageView innerImageFrameInSuperview] toView:self.imageViewWithMask];
    self.maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.imageViewWithMask.layer.mask = self.maskLayer;
    
    [self drawMask];
    [self.view bringSubviewToFront:self.cropView];
}

#pragma mark - Gesture Recognizer Related

- (void)corpViewPanned:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.cropView.center;
    } else{
        
        CGPoint touchPoint = [panGestureRecognizer locationInView:self.cropView];
        if ([self isTouchAtCentralArea:touchPoint]) {
            CGPoint newCenter = CGPointMake(self.cropView.center.x + translation.x,
                                            self.cropView.center.y + translation.y);
            self.cropView.center = [self normalizeCenter:newCenter];
            [self updateCropViewFrameTo:self.cropView.frame];
        } else{
            CGRect oldFrame = self.cropView.frame;
            CGRect newFrame;
            
            if ([self isTouchAtTopLeftCorner:touchPoint]) {
                newFrame = CGRectMake(oldFrame.origin.x + translation.x,
                                      oldFrame.origin.y + translation.y,
                                      oldFrame.size.width - translation.x,
                                      oldFrame.size.height - translation.y);
            } else if ([ self isTouchAtTopRightCorner:touchPoint]){
                newFrame = CGRectMake(oldFrame.origin.x,
                                      oldFrame.origin.y + translation.y,
                                      oldFrame.size.width + translation.x,
                                      oldFrame.size.height - translation.y);
            } else if ([self isTouchAtBottomRightCorner: touchPoint]){
                newFrame = CGRectMake(oldFrame.origin.x,
                                      oldFrame.origin.y,
                                      oldFrame.size.width + translation.x,
                                      oldFrame.size.height + translation.y);
            } else if ([self isTouchAtBottomLeftCorner: touchPoint]){
                newFrame = CGRectMake(oldFrame.origin.x + translation.x,
                                      oldFrame.origin.y,
                                      oldFrame.size.width - translation.x,
                                      oldFrame.size.height + translation.y);
            }
            [self updateCropViewFrameTo:newFrame];
        }
    }
}

- (CGPoint)normalizeCenter: (CGPoint)center{
    CGFloat width = self.cropView.frame.size.width;
    CGFloat height = self.cropView.frame.size.height;
    
    CGRect imageFrame = [self.imageView innerImageFrameInSuperview];
    CGFloat x1_imageView = imageFrame.origin.x;
    CGFloat y1_imageView = imageFrame.origin.y;
    CGFloat x2_imageView = imageFrame.origin.x + imageFrame.size.width;
    CGFloat y2_imageView = imageFrame.origin.y + imageFrame.size.height;

    CGFloat newX = center.x - width / 2 < x1_imageView ? x1_imageView + width / 2 : center.x;
    newX = newX + width / 2 > x2_imageView ? x2_imageView - width / 2 : newX;
    CGFloat newY = center.y - height / 2 < y1_imageView ? y1_imageView + height / 2 : center.y;
    newY = newY + height / 2 > y2_imageView ? y2_imageView - height / 2 : newY;
    
    return CGPointMake(newX, newY);
}

- (CGRect)normalizeFrame: (CGRect)frame{
    CGFloat x1 = frame.origin.x;
    CGFloat y1 = frame.origin.y;
    CGFloat x2 = frame.origin.x + frame.size.width;
    CGFloat y2 = frame.origin.y + frame.size.height;
    
    CGRect imageFrame = [self.imageView innerImageFrameInSuperview];
    CGFloat x1_imageView = imageFrame.origin.x;
    CGFloat y1_imageView = imageFrame.origin.y;
    CGFloat x2_imageView = imageFrame.origin.x + imageFrame.size.width;
    CGFloat y2_imageView = imageFrame.origin.y + imageFrame.size.height;
    
    CGFloat newX1 = x1 < x1_imageView ? x1_imageView : x1;
    newX1 = newX1 > x2_imageView ? x2_imageView : newX1;
    CGFloat newY1 = y1 < y1_imageView ? y1_imageView : y1;
    newY1 = newY1 > y2_imageView ? y2_imageView : newY1;
    
    CGFloat newX2 = x2 < x1_imageView ? x1_imageView : x2;
    newX2 = newX2 > x2_imageView ? x2_imageView : newX2;
    CGFloat newY2 = y2 < y1_imageView ? y1_imageView : y2;
    newY2 = newY2 > y2_imageView ? y2_imageView : newY2;
    
    CGFloat newWidth = newX2 - newX1 > BORDER_BUTTON_LENGTH * 2 ? newX2 - newX1 : BORDER_BUTTON_LENGTH * 2;
    CGFloat newHeight = newY2 - newY1 > BORDER_BUTTON_LENGTH * 2 ? newY2 - newY1 : BORDER_BUTTON_LENGTH * 2;
    
    return CGRectMake(newX1, newY1, newWidth, newHeight);
}

- (BOOL)isTouchAtTopLeftCorner: (CGPoint) point{
    return ((point.x < BORDER_BUTTON_LENGTH) && (point.y < BORDER_BUTTON_LENGTH));
}

- (BOOL)isTouchAtTopRightCorner: (CGPoint) point{
    CGFloat cropFrameWidth = self.cropView.frame.size.width;
    return ((point.x > cropFrameWidth - BORDER_BUTTON_LENGTH) && (point.y < BORDER_BUTTON_LENGTH));
}

- (BOOL)isTouchAtBottomRightCorner: (CGPoint) point{
    CGFloat cropFrameWidth = self.cropView.frame.size.width;
    CGFloat cropFrameHeight = self.cropView.frame.size.height;
    return ((point.x > cropFrameWidth - BORDER_BUTTON_LENGTH) && (point.y > cropFrameHeight - BORDER_BUTTON_LENGTH));
}

- (BOOL)isTouchAtBottomLeftCorner: (CGPoint) point{
    CGFloat cropFrameHeight = self.cropView.frame.size.height;
    return ((point.x < BORDER_BUTTON_LENGTH) && (point.y > cropFrameHeight - BORDER_BUTTON_LENGTH));
}

- (BOOL)isTouchAtCentralArea: (CGPoint) point{
    return (![self isTouchAtTopLeftCorner: point] &&
            ![self isTouchAtTopRightCorner: point] &&
            ![self isTouchAtBottomRightCorner: point] &&
            ![self isTouchAtBottomLeftCorner: point]);
}

- (void)updateCropViewFrameTo: (CGRect) frame{
    self.cropView.frame = [self normalizeFrame: frame];
    [self.cropView setNeedsDisplay];
    [self drawMask];
}

- (void)drawMask{
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.0];
    self.maskLayer.frame = [self.cropView convertRect:self.cropView.bounds toView:self.imageViewWithMask];
    [CATransaction commit];
}

#pragma mark - Button Clicked


- (IBAction)infoButtonClicked:(id)sender {
    ImageSearchInfoView* imageSearchInfoView = [ImageSearchInfoView imageSearchInfoViewWithImageName:@"camera_info_pic_edit.png"];
    [self.view addSubview: imageSearchInfoView];
    imageSearchInfoView.frame = CGRectMake(0, 0, [self getScreenWidth], [self getScreenHeight]);
    [imageSearchInfoView appearGradually];
}

- (IBAction)takePhotoButtonClicked:(id)sender {
    if (self.shouldhideControls){
        return;
    } else{
        self.shouldhideControls = YES;
    }
    
    ImageSearchViewController* vc = (ImageSearchViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ImageSearchViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)searchButtonClicked:(id)sender {
    
    if (self.shouldhideControls){
        return;
    } else{
        self.shouldhideControls = YES;
    }
    
    self.cancelButton.hidden = NO;
    self.rotateButton.hidden = YES;
    self.infoButton.hidden = YES;
    self.takePhotoButton.hidden = YES;
    self.takePhotoIcon.hidden = YES;
    self.rotateIcon.hidden = YES;
    self.infoIcon.hidden = YES;
    self.closeButton.hidden = YES;
    self.isSearchCanceled = NO;
    
    [self.view addScannerViewAtFrame:[self.imageView innerImageFrameInSuperview]];

    NSArray* fieldList = [NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil];
    [[SearchClient sharedInstance] uploadSearch:self.imageView.image
                                  andFieldQuery:nil
                                   andFieldList:fieldList
                                       andFacet:nil
                                       andLimit: IMAGE_COUNT_LIMIT
                                    andPriority: nil
                                        andPage: 1
                                    andScoreMin: SCORE_MIN_DEFAULT_UPLOAD
                                    andScoreMax: 1
                                andCroppedFrame: [self getCroppedFrame]
                                        success:^(NSDictionary *responseObject) {
                                            
                                            if (self.isSearchCanceled) {
                                                NSLog(@"Search result returned. But user has canceled search in the process");
                                                // No need to do this:
                                                // [self.view removeScannerView]; // done in cancelButtonClicked:
                                                // [self cancelButtonClicked:nil]; // done when the user clicked "Cancel" button.
                                                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        @"cancel", @"method",
                                                                        nil];
                                                [Flurry logEvent:@"upload search" withParameters:params];
                                            }else{
                                                NSLog(@"Found: %@", responseObject);
                                                [self.view removeScannerView];
                                                
                                                NSMutableArray* products = [[NSMutableArray alloc] init];
                                                for (NSDictionary* dict in responseObject[@"result"]) {
                                                    [products addObject: [Product productFromDictionary:dict andKeyForSpecs:@"value_map"]];
                                                }
                                                
                                                [self proceedToDisplaySearchResultWithProducts:products];
                                                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        @"refine", @"method",
                                                                        nil];
                                                
                                                [Flurry logEvent:@"upload search" withParameters:params];
                                            }
                                        } failure:^(NSArray *errors) {
                                            [self.view removeScannerView];
                                            [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
                                        }];
    
}
- (IBAction)cancelSearchClicked:(id)sender {
    [self.view removeScannerView];
    self.isSearchCanceled = YES;
    self.shouldhideControls = NO;
    self.cancelButton.hidden = YES;
    self.rotateButton.hidden = NO;
    self.infoButton.hidden = NO;
    self.takePhotoButton.hidden = NO;
    self.takePhotoIcon.hidden = NO;
    self.rotateIcon.hidden = NO;
    self.closeButton.hidden = NO;
    self.infoIcon.hidden = NO;
    NSLog(@"Search result returned. But user has canceled search in the process");
    // No need to do this:
    // [self.view removeScannerView]; // done in cancelButtonClicked:
    // [self cancelButtonClicked:nil]; // done when the user clicked "Cancel" button.
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"cancel", @"method",
                            nil];
    [Flurry logEvent:@"upload search" withParameters:params];
}

- (IBAction)rotateButtonClicked:(id)sender {
    if (self.shouldhideControls){
        return;
    }
    
    self.imageToCrop = [self.imageToCrop imageRotatedByDegrees:-90.0];
    [self setUpViews];
    [Flurry logEvent:@"rotate button clicked"];
}

- (void)proceedToDisplaySearchResultWithProducts: (NSArray*) products{
    
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.searchResultViewControllerDelegate == nil){
        
        SearchResultViewController* vc = (SearchResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
        vc.searchType = SEARCH_TYPE_IMAGE;
        vc.products = [NSArray arrayWithArray: products];
        vc.imageToSearch = self.imageToCrop;
        vc.imageFrameToCrop = [self getCroppedFrame];
        
        [self.navigationController pushViewController:vc animated:YES];
        
        appDelegate.searchResultViewControllerDelegate = vc;
    } else{
        [appDelegate.searchResultViewControllerDelegate searchResultReturnedWithSearchType:SEARCH_TYPE_IMAGE andSearchResult:products andImageToSearch:self.imageToCrop andImageFrameToCrop:[self getCroppedFrame]];
    }
}

// The imageView is in Aspect Fit mode scaling the frame of the original image to display. Therefore, the frame need to be re-calculated.
- (CGRect)getCroppedFrame{
    self.imageView.frame = [self.imageView innerImageFrameInSuperview];
    CGRect croppedFrame = [self.cropView convertRect:self.cropView.bounds toView: self.imageView];
    NSLog(@"%@", [NSValue valueWithCGRect:croppedFrame]);
    // Adjust a little bit offset. I'm guessing it's because of the border width:
    CGSize originalImageSize = self.imageToCrop.size;
    CGSize imageViewSize = self.imageView.frame.size;
    CGFloat scale = (originalImageSize.height > originalImageSize.width) ? originalImageSize.height / imageViewSize.height : originalImageSize.width / imageViewSize.width;
    croppedFrame = CGRectMake(croppedFrame.origin.x * scale + BORDER_WIDTH,
                              croppedFrame.origin.y * scale + BORDER_WIDTH,
                              croppedFrame.size.width * scale,
                              croppedFrame.size.height * scale);
    
    NSLog(@"%@", [NSValue valueWithCGSize:originalImageSize]);
    NSLog(@"%@", [NSValue valueWithCGSize:imageViewSize]);
    NSLog(@"%@", [NSValue valueWithCGRect:croppedFrame]);
    return croppedFrame;
}

@end

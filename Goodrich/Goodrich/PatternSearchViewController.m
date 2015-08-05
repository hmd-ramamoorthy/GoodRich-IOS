//
//  PatternSearchViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define OPTION_BUTTON_HEIGHT 45

#define TITLE_FONT_SIZE 13
#define OPTION_FONT_SIZE 13

#import "PatternSearchViewController.h"

@interface PatternSearchViewController ()

@property (strong, nonatomic) NSMutableArray* keyButtonsCollection;
@property (nonatomic) int currentPageIndex;

@end

@implementation PatternSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDataFromServer];
    
    self.keyButtonsCollection = [[NSMutableArray alloc] init];
    
    // Prevent the scrollView from autoscroll when poped an vc.
    // http://stackoverflow.com/questions/17404682/uiscrollviews-origin-changes-after-popping-back-to-the-uiviewcontroller
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Data

- (void) loadDataFromServer{
    [self.view makeSpinnerActivity];
    [DataClient sharedInstance].isMultiSelection = true;
    [[HTTPClient sharedInstance] getPatternStyleListSuccess:^(NSInteger statusCode, id responseObject) {
        [self.view hideSpinnerActivity];
        NSDictionary* result = responseObject[@"result"];
        
        // Init scollview
        self.keysScrollView.delegate = nil;
        self.keysScrollView.pagingEnabled = NO;
        
        self.optionsScrollView.delegate = self;
        self.optionsScrollView.pagingEnabled = YES;

        CGFloat currentButtonX = 0.0;
        // Fill in the scrollviews:
        for (int i = 0; i < [result allKeys].count; i++) {
            NSString* categoryKey = CATEGORY_KEY_WALLCOVERING;
            if( i == 1 )
                categoryKey = CATEGORY_KEY_FABRIC;
            else if( i == 2)
                categoryKey = CATEGORY_KEY_CARPET;
            else if( i == 3)
                categoryKey = CATEGORY_KEY_FLOORING;
            // =============== Render scrollView for category keys ===============
            CGRect frame;
            frame.origin.x = currentButtonX;
            frame.origin.y = 0;
            frame.size = CGSizeMake(self.keysScrollView.frame.size.width,
                                    self.keysScrollView.frame.size.height);
            PatternStyleKeyButton* button = [[PatternStyleKeyButton alloc] initWithFrame: frame];
            
            // Add spaces before and after the title:
            NSString *buttonTitle = [([[DataClient sharedInstance] getRepresentationStringWithCategoryKey:categoryKey]) stringByAppendingString:@"  "];
            buttonTitle = [@"   " stringByAppendingString:buttonTitle];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:TITLE_FONT_SIZE]];
            button.titleLabel.frame = CGRectZero;
            [button.titleLabel sizeToFit];
            [button sizeToFit];
            [button addTarget:self action:@selector(keyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.categoryKey = categoryKey;
            
            // Re-set the height:
            frame.size = CGSizeMake(button.frame.size.width,
                                    self.keysScrollView.frame.size.height);
            button.frame = frame;
            
            [self.keysScrollView addSubview:button];
            [self.keyButtonsCollection addObject: button];
            currentButtonX += button.frame.size.width;
            self.keysScrollView.contentSize = CGSizeMake(currentButtonX + 10,
                                                         self.keysScrollView.frame.size.height);
            
            // ================== Render scrollView for options ================
            frame.origin.x = self.optionsScrollView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = self.optionsScrollView.frame.size;
            
            //New SubView
            NSArray* options = [result objectForKey: categoryKey];
            UIScrollView *optionsScrollView = [[UIScrollView alloc] initWithFrame:frame];
            
            [self renderOptionButtons:options withCategory:categoryKey toView:optionsScrollView];
            [self.optionsScrollView addSubview:optionsScrollView];
        }
        
        //Content Size Scrollview
        self.optionsScrollView.contentSize = CGSizeMake(self.optionsScrollView.frame.size.width*result.allKeys.count,
                                                        self.optionsScrollView.frame.size.height);
        // Switch to the first page:
        if (self.keyButtonsCollection.count > 0) {
            self.currentPageIndex = 0;
            [self keyButtonClicked:[self.keyButtonsCollection objectAtIndex: 0]];
        } else{
            [self handleFailedRequestWithErrors:@[@"There's no styles available"] withType:REQUEST_TYPE_SINGLE_REQUEST];
        }

    } failure:^(NSInteger statusCode, NSArray *errors) {
        [self.view hideSpinnerActivity];
        [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
    }];
}

- (void) renderOptionButtons: (NSArray*)titles withCategory: (NSString*)category toView: (UIScrollView*)scrollView{
    
    NSArray *sortedTitles = [titles sortedArrayUsingSelector: @selector(localizedCaseInsensitiveCompare:)];
    CGFloat currentHeight = 0.0;
    for (int i = 0; i < sortedTitles.count; i++) {
        if(![[sortedTitles objectAtIndex:i]isEqualToString:@""]){
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = currentHeight;
        frame.size = CGSizeMake(scrollView.frame.size.width, OPTION_BUTTON_HEIGHT);
        
        PatternStyleButton* button = [[PatternStyleButton alloc] initWithFrame: frame];
        [button setTitle:[sortedTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:OPTION_FONT_SIZE]];
        button.categoryKey = category;
        [button addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview: button];
        currentHeight += OPTION_BUTTON_HEIGHT;
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                        OPTION_BUTTON_HEIGHT * titles.count);
}

#pragma mark - ScrollView Delegate

//scrolling ends
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //find the page number you are on
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"Scrolling - You are now on page %i",page);
    
    [self highlightButton:[self.keyButtonsCollection objectAtIndex: page]];
    self.currentPageIndex = page;
}

//dragging ends, please switch off paging to listen for this event
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *) targetContentOffset
    NS_AVAILABLE_IOS(5_0){
    
    //find the page number you are on
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"Dragging - You are now on page %i",page);
}

- (void)contentViewControllerDidSwitchToPageOfIndex: (int) pageIndex{
    
    if (self.currentPageIndex == pageIndex) {
        return;
    }
    
    self.currentPageIndex = pageIndex;
    
    CGPoint scrollPoint = CGPointMake(self.optionsScrollView.frame.size.width * pageIndex, 0);
    [self.optionsScrollView setContentOffset:scrollPoint animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Button Click events

- (void)keyButtonClicked: (UIButton*) sender{
    [self highlightButton: sender];
    [self contentViewControllerDidSwitchToPageOfIndex:(int)[self.keyButtonsCollection indexOfObject: sender]];
    [Flurry logEvent:@"pattern search"];
}

- (void)highlightButton: (UIButton*) buttonToHighlight{
    for (UIButton* button in self.keyButtonsCollection) {
        if (button == buttonToHighlight) {
            [button setSelected: YES];
        } else{
            [button setSelected: NO];
        }
    }
}

- (void)optionButtonClicked: (PatternStyleButton*) sender{
    
    BrowsingItemsViewController* vc = (BrowsingItemsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrowsingItemsViewController"];
    vc.browingType = BROWSING_ITEMS_TYPE_SEARCH_RESULT_PATTERN;
    vc.categoryToSearch = sender.categoryKey;
    [DataClient sharedInstance].currentCategory = sender.categoryKey;
    vc.patternTypeToSearch = sender.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Others

@end

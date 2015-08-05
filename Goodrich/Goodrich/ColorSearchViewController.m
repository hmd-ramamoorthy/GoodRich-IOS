//
//  ColorSearchViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "ColorSearchViewController.h"

@interface ColorSearchViewController ()

@end

@implementation ColorSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colorPickerView.delegate = self;
    
    UIColor *c = self.colorPickerView.color;
    self.colorDisplayView.backgroundColor=c;
    self.colorValueLabel.text = [c getDisplayStringFromColor];
    self.selectedColor = c;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ILColorPickerViewDelegate

-(void)colorPicked:(UIColor *)color forPicker:(ILColorPickerView *)picker
{
    self.colorDisplayView.backgroundColor=color;
    self.colorValueLabel.text = [color getDisplayStringFromColor];
    self.selectedColor = color;
}

- (IBAction)searchButtonClicked:(UIBarButtonItem *)sender {
    NSArray* fieldList = [NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil];
    [self.view makeSpinnerActivity];
    self.searchButton.enabled = NO;
    [[SearchClient sharedInstance] colorSearch:[self.selectedColor hexStringFromColor]
                                 andFieldQuery:nil andFieldList:fieldList
                                      andFacet:nil
                                      andLimit:IMAGE_COUNT_LIMIT
                                       andPage:1
                                   andScoreMin: SCORE_MIN_DEFAULT_COLOR
                                   andScoreMax: 1
                                       success:^(NSDictionary *responseObject) {
                                           [self.view hideSpinnerActivity];
                                           NSMutableArray* products = [[NSMutableArray alloc] init];
                                           for (NSDictionary* dict in responseObject[@"result"]) {
                                               [ products addObject: [Product productFromDictionary:dict andKeyForSpecs:@"value_map"]];
                                           }
                                           
                                           SearchResultViewController* vc = (SearchResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
                                           vc.searchType = SEARCH_TYPE_COLOR;
                                           vc.products = [NSArray arrayWithArray: products];
                                           vc.colorToSearch = self.selectedColor;
                                           [self.navigationController pushViewController:vc animated:YES];
                                           self.searchButton.enabled = YES;
                                           [[HTTPClient sharedInstance] updateSearchHistoryWithMethod:@"color" andImage:nil andColor:[self.selectedColor hexStringFromColor] andText:nil andLimit:IMAGE_COUNT_LIMIT andPage:1 andFieldList:fieldList success:^(NSInteger statusCode, id responseObject) {
                                               NSLog(@"Successfully updated search history");
                                           } failure:^(NSInteger statusCode, NSArray *errors) {
                                               NSLog(@"Oops.. Updated search history failed");
                                           }];
    } failure:^(NSArray *errors) {
        [self.view hideSpinnerActivity];
        [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
    }];
    [Flurry logEvent:@"color search"];
}

#pragma mark - override Template View Controller

- (BOOL)isSearchButtonDisplayed {
    return YES;
}

@end

//
//  KeywordsSearchViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define SEARCH_RESULT_Y 0
#import "KeywordsSearchViewController.h"

@interface KeywordsSearchViewController ()

@property (strong, nonatomic) SearchResultViewController* searchResultViewController;

@end

@implementation KeywordsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.inputTextField becomeFirstResponder];
    self.inputTextField.delegate = self;
    [DataClient sharedInstance].isMultiSelection = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)searchButtonClicked:(id)sender {
    
    [self.inputTextField resignFirstResponder];
    if ([self isValideInput]) {
        [self.view makeSpinnerActivity];
        [[HTTPClient sharedInstance] textSearchWithText:self.inputTextField.text WithLimit:100 andPage:1 andFieldQuery:nil andFieldList:[NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil] andFacet:nil success:^(NSInteger statusCode, id responseObject) {
            [self.view hideSpinnerActivity];
            
            NSMutableArray* products = [[NSMutableArray alloc] init];
            for (NSDictionary* dict in responseObject[@"result"]) {
                Product* product = [Product productFromDictionary:dict andKeyForSpecs:@"user_fields"];
                [products addObject: product];
            }
            if (self.searchResultViewController == nil) {
                self.searchResultViewController = (SearchResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
                self.searchResultViewController.searchType = SEARCH_TYPE_TEXT;
                self.searchResultViewController.view.frame = CGRectMake(0,
                                                                        SEARCH_RESULT_Y,
                                                                        [self getScreenWidth],
                                                                        [self getScreenHeight] - SEARCH_RESULT_Y);
                [self.view addSubview: self.searchResultViewController.view];
                self.searchResultViewController.delegate = self;
            }
            self.searchResultViewController.keywordToSearch = self.inputTextField.text;
            self.searchResultViewController.products = products;
            [self.searchResultViewController reInitDataAndReloadView];
            [[HTTPClient sharedInstance] updateSearchHistoryWithMethod:@"text" andImage:nil andColor:nil andText:nil andLimit:IMAGE_COUNT_LIMIT andPage:1 andFieldList:[NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil] success:^(NSInteger statusCode, id responseObject) {
                NSLog(@"Successfully updated search history");
            } failure:^(NSInteger statusCode, NSArray *errors) {
                NSLog(@"Oops.. Updated search history failed");
            }];
        } failure:^(NSInteger statusCode, NSArray *errors) {
            [self.view hideSpinnerActivity];
            [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
        }];
        [Flurry logEvent:@"keyword search"];
    }
}

- (BOOL)isValideInput{
    if ([self.inputTextField.text isEqualToString:@""]) {
        [self.view makeToast:@"Please input valid keywords" duration:TOAST_MESSAGE_DURATION position:TOAST_MESSAGE_POSITION];
        return NO;
    } else{
        return YES;
    }
}

#pragma mark - Delegate

- (void)allButtonPressedWithViewController:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)itemButtonPressedWithViewController:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchButtonClicked:nil];
    return YES;
}

#pragma mark - override Template View Controller

- (BOOL)isSearchButtonDisplayed {
    return YES;
}
@end

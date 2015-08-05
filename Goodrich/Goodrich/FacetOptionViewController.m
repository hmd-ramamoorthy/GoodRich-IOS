//
//  FacetOptionViewController.m
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define TABLE_VIEW_CELL_HEIGHT 45
#define TABLE_VIEW_MAX_HEIGHT 230 //changed from 300 to 230 in order to display it correct on iphone 4 size, by yulu
#define FACET_OPTION_LABEL_TAG 4756

#import "FacetOptionViewController.h"

@interface FacetOptionViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FacetOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.layer.borderColor = [UIColor colorFromRGB:0xa9a9a9].CGColor;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.cornerRadius = 6.0;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFacetKey:(NSString *)facetKey{
    _facetKey = facetKey;
    self.facetKeyLabel.text = facetKey;
}

- (void)setFacetItems:(NSArray *)facetItems{
    _facetItems = facetItems;
    [self.tableView reloadData];
    [self adjustViewsPositions];
}

- (void)setFacetItemsSelected:(NSArray *)facetItemsSelected{
    _facetItemsSelected = facetItemsSelected;
    for (NSString* option in facetItemsSelected) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.facetItems indexOfObject:option] inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
    }
}

- (void) setMultipleSelection: (bool) multi{
    self.tableView.allowsMultipleSelection = multi;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.facetItems.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.facetItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facetOptionCell" forIndexPath:indexPath];
    
    NSString* option = [self.facetItems objectAtIndex:indexPath.row];
    
    UILabel* optionLabel = (UILabel*)[cell viewWithTag:FACET_OPTION_LABEL_TAG];
    optionLabel.text = option;
    
    cell.layer.cornerRadius = 3.0;
    
    UIView *selectionColor = [[UIView alloc] initWithFrame:cell.frame];
    selectionColor.backgroundColor = [UIColor colorFromRGB:0x8a12bc];
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)applyButtonClicked:(UIButton *)sender {
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    for (NSIndexPath* indexPath in [self.tableView indexPathsForSelectedRows]) {
        [selectedItems addObject:[self.facetItems objectAtIndex:indexPath.row]];
    }
    
    [self.delegate facetOptionDidApplyWithOptions: selectedItems];
}

- (IBAction)closeButtonClicked:(UIButton *)sender {
    [self.delegate facetOptionDidCanceled];
}

- (void)adjustViewsPositions{
    CGFloat fullHeight = self.facetItems.count * TABLE_VIEW_CELL_HEIGHT;
    CGFloat finalHeight = fullHeight > TABLE_VIEW_MAX_HEIGHT ? TABLE_VIEW_MAX_HEIGHT : fullHeight;
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                      self.tableView.frame.origin.y,
                                      self.tableView.frame.size.width,
                                      finalHeight);
    self.tableView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    self.facetKeyLabel.center = CGPointMake(self.facetKeyLabel.center.x,
                                            self.tableView.frame.origin.y - 20 - self.facetKeyLabel.frame.size.height);
//    
//    CGRect frame = self.applyButton.frame;
//    frame.origin = CGPointMake(15, self.tableView.frame.origin.y + self.tableView.frame.size.height + 5);
//    self.applyButton.frame = frame;
//    
//    frame.origin.y += 35;
//    self.closeButton.frame = frame;
//    self.closeIcon.center = self.closeButton.center;
}

@end

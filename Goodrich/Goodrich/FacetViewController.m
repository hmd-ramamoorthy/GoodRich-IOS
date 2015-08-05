//
//  FacetViewController.m
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define FACET_KEY_LABEL_TAG 3269
#define FACET_VALUE_LABEL_TAG 3230
#define TABLE_VIEW_CELL_HEIGHT 50

#import "FacetViewController.h"

@interface FacetViewController ()

@property (strong, nonatomic) FacetOptionViewController* facetOptionViewController;

@end

@implementation FacetViewController

- (void)initDataModel{
    self.filter = [[Filter alloc] init];
    self.priority = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.layer.borderColor = [UIColor colorFromRGB:0xa9a9a9].CGColor;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.cornerRadius = 6.0;
    //self.sortControl.hidden = YES;
    //self.sortByLabel.hidden = YES;
    self.sortBackground.alpha = 0;
    [self.sortControl addTarget:self action:@selector(changeSort:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"fact appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"fact will disappear");
}

- (void)showSortByTab {
    self.sortBackground.alpha = 0.95;
    //self.sortControl.hidden = NO;
    //self.sortByLabel.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.facets.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.facets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facetCell" forIndexPath:indexPath];
    Facet* facet = [self.facets objectAtIndex:indexPath.row];
 
    UILabel* facetKeyLabel = (UILabel*)[cell viewWithTag:FACET_KEY_LABEL_TAG];
    facetKeyLabel.text = facet.facetKey;
    
    UILabel* facetValueLabel = (UILabel*)[cell viewWithTag:FACET_VALUE_LABEL_TAG];
    if ([self.filter getFilterValuesWithFilterName:facet.facetKey] != nil) {
        facetValueLabel.text = [self generateDiaplayTextWithSelectedOptions: [self.filter getFilterValuesWithFilterName:facet.facetKey]];
    } else{
        facetValueLabel.text = @"";
    }
    
    cell.layer.cornerRadius = 3.0;
    
    UIView *selectionColor = [[UIView alloc] initWithFrame:cell.frame];
    selectionColor.backgroundColor = [UIColor colorFromRGB:0x8a12bc];
    cell.selectedBackgroundView = selectionColor;
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Facet* facet = (Facet*)[self.facets objectAtIndex:indexPath.row];
    NSArray* options = facet.facetItems;
    if (self.facetOptionViewController == nil) {
        self.facetOptionViewController = (FacetOptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FacetOptionViewController"];
    }
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;

    if (self.facetOptionViewController.view.superview != self.view) {
        [currentWindow addSubview: self.facetOptionViewController.view];
    }
    
    [currentWindow bringSubviewToFront:self.facetOptionViewController.view];
    
    self.facetOptionViewController.facetItems = options;
    self.facetOptionViewController.facetKey = facet.facetKey;
    self.facetOptionViewController.delegate = self;
    [self.facetOptionViewController setMultipleSelection: [[DataClient sharedInstance] isMultiSelection]];
    self.facetOptionViewController.facetItemsSelected = [self.filter getFilterValuesWithFilterName:facet.facetKey];
    
    self.facetOptionViewController.view.frame = CGRectMake(0,
                                                           [self getScreenHeight],
                                                           self.facetOptionViewController.view.frame.size.width,
                                                           self.facetOptionViewController.view.frame.size.height);
    [self toggleFacetOptionView];
}

#pragma mark - Option View

- (void)toggleFacetOptionView{    
    CGRect originalFrame = self.facetOptionViewController.view.frame;
    CGRect newFrame = CGRectMake(originalFrame.origin.x,
                                 [self isFacetOptionViewShown] ? [self getScreenHeight] : 0,
                                 originalFrame.size.width,
                                 originalFrame.size.height);
    if ([self isFacetOptionViewShown]){
        self.facetOptionViewController.view.hidden = YES;
    }else{
        self.facetOptionViewController.view.hidden = NO;
    }
   [UIView animateWithDuration:0.3 animations:^{
        self.facetOptionViewController.view.frame = newFrame;
    } completion:nil];
}

- (BOOL)isFacetOptionViewShown{
    return self.facetOptionViewController.view.frame.origin.y < [self getScreenHeight];
}

#pragma mark - Delegate

- (void)facetOptionDidApplyWithOptions: (NSArray*)selectedOptions{
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath: selectedIndexPath];
    Facet* facet = [self.facets objectAtIndex: selectedIndexPath.row];
    
    [self.filter setFilterWithFilterName:facet.facetKey andFilterValues:selectedOptions];
    
    UILabel* label = (UILabel*)[cell viewWithTag:FACET_VALUE_LABEL_TAG];
    label.text = [self generateDiaplayTextWithSelectedOptions:selectedOptions];
    
    [self toggleFacetOptionView];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

- (NSString*) generateDiaplayTextWithSelectedOptions: (NSArray*) selectedOptions{
    if (selectedOptions == nil || selectedOptions.count == 0) {
        return @"";
    }
    NSMutableString* result = [[NSMutableString alloc] init];
    for (NSString* str in selectedOptions) {
        [result appendString:[NSString stringWithFormat:@"%@, ", str]];
    }
    return [result substringToIndex:result.length - 2];
}

- (void)facetOptionDidCanceled{
    [self toggleFacetOptionView];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Button click events

- (IBAction)applyFiltersButtonClicked:(UIButton *)sender {
    [self.delegate facetDidApply];
}

- (IBAction)closeButtonClicked:(UIButton *)sender {
    [self.delegate facetDidCanceled];
}

- (IBAction)clearFiltersButtonClicked:(UIButton *)sender {
    for (Facet* facet in self.facets) {
        [self.filter removeFilterWithFilterName:facet.facetKey];
    }
    [self.tableView reloadData];
    //[self adjustSelfPosition];
}

- (IBAction)changeSort:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        self.priority = nil;
        [self.delegate facetDidApply];
    }
    else if (selectedSegment == 1) {
        self.priority = @"pattern";
        [self.delegate facetDidApply];
    }else{
        self.priority = @"color";
        [self.delegate facetDidApply];
    }
}

- (void)adjustSelfPosition{
    self.view.frame = CGRectMake(0, [self getScreenHeight] - [self getMovingDistance], self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - Others

-(void)setFacets:(NSArray *)facets{
    _facets = facets;
    [self.tableView reloadData];
    [self adjustSubViewPositions];
}

- (void)adjustSubViewPositions{
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                      self.tableView.frame.origin.y,
                                      self.tableView.frame.size.width,
                                      //self.facets.count * TABLE_VIEW_CELL_HEIGHT);
                                      self.facets.count * TABLE_VIEW_CELL_HEIGHT - 20); // remove extra weird padding at the bottom.
    
    CGFloat startY = self.tableView.frame.origin.y + self.tableView.frame.size.height + 10;
    CGFloat currentY = self.applyFiltersButton.frame.origin.y;
    CGFloat offsetY = startY - currentY;
    
    self.applyFiltersButton.frame = CGRectMake(self.applyFiltersButton.frame.origin.x,
                                               self.applyFiltersButton.frame.origin.y + offsetY,
                                               self.applyFiltersButton.frame.size.width,
                                               self.applyFiltersButton.frame.size.height);
    
    self.clearFiltersButton.frame = CGRectMake(self.clearFiltersButton.frame.origin.x,
                                               self.clearFiltersButton.frame.origin.y + offsetY,
                                               self.clearFiltersButton.frame.size.width,
                                               self.clearFiltersButton.frame.size.height);
    
    self.closeButton.frame = CGRectMake(self.closeButton.frame.origin.x,
                                               self.closeButton.frame.origin.y + offsetY,
                                               self.closeButton.frame.size.width,
                                               self.closeButton.frame.size.height);
    
    self.closeIcon.frame = CGRectMake(self.closeIcon.frame.origin.x,
                                               self.closeIcon.frame.origin.y + offsetY,
                                               self.closeIcon.frame.size.width,
                                               self.closeIcon.frame.size.height);
}

- (CGFloat)getMovingDistance{
    //[self.view setNeedsDisplay];
    NSLog(@"%lf",self.closeButton.frame.origin.y);
    NSLog(@"%lf",self.closeButton.frame.size.height);

    return self.closeButton.frame.origin.y + self.closeButton.frame.size.height + 15;
}

@end

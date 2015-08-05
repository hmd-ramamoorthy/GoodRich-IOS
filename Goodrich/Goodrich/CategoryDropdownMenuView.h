//
//  CategoryDropdownMenuView.h
//  Goodrich
//
//  Created by Zhixing on 2/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenuDelegate.h"
#import "UIColor+ColorFromRGB.h"
#import "Constants.h"

@interface CategoryDropdownMenuView : UIView

@property (weak) id<DropDownMenuDelegate> delegate;

// DropDown list:
@property (weak, nonatomic) IBOutlet UIButton *viewAllButton;
@property (weak, nonatomic) IBOutlet UIButton *wallCoveringButton;
@property (weak, nonatomic) IBOutlet UIButton *fabricsButton;
@property (weak, nonatomic) IBOutlet UIButton *carpetsButton;
@property (weak, nonatomic) IBOutlet UIButton *flooringButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIView *dropDownListView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dropDownButtons;

- (IBAction)dropDownItemButtonClicked:(UIButton *)sender;
- (IBAction)dismissButtonClicked:(id)sender;

+ (instancetype) categoryDropdownMenuView;
- (void) toggleDropDownListView;
- (BOOL) isDropDownMenuShowing;
- (void) initializeVariables;

@end

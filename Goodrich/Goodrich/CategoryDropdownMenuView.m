//
//  CategoryDropdownMenuView.m
//  Goodrich
//
//  Created by Zhixing on 2/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "CategoryDropdownMenuView.h"

@interface CategoryDropdownMenuView()

@property (strong, nonatomic) NSArray* dropdownOptions;

@end

@implementation CategoryDropdownMenuView

#pragma mark - Initialization

+ (instancetype)categoryDropdownMenuView{
    CategoryDropdownMenuView *categoryDropdownMenuView = [[[NSBundle mainBundle] loadNibNamed:@"CategoryDropdownMenuView" owner:nil options:nil] objectAtIndex:0];
    
    // make sure customView is not nil or the wrong class!
    if ([categoryDropdownMenuView isKindOfClass:[CategoryDropdownMenuView class]]){
        [categoryDropdownMenuView initializeVariables];
        return categoryDropdownMenuView;
    }
    else{
        return nil;
    }
}

- (void) initializeVariables{
    self.dropdownOptions = [[NSArray alloc] initWithObjects:
                            CATEGORY_TITLE_VIEW_ALL,
                            CATEGORY_TITLE_WALLCOVERING,
                            CATEGORY_TITLE_FABRIC,
                            CATEGORY_TITLE_CARPET,
                            CATEGORY_TITLE_FLOORING,
                            nil];
    
    [self.delegate setTitleToTitleLabel:[self.dropdownOptions objectAtIndex: 0]];
    [self setBackgroundColor:[UIColor colorFromRGB:0x8a12bc] toButton:[self getDropDownButtonWithTag:0]];
}

#pragma mark - Button Click Events

- (IBAction)dismissButtonClicked:(id)sender {
    [self toggleDropDownListView];
}


- (IBAction)dropDownItemButtonClicked:(UIButton *)sender{
    
    for (UIButton* button in self.dropDownButtons) {
        if (button.tag == sender.tag) {
            [self setBackgroundColor:[UIColor colorFromRGB:0x8a12bc] toButton:button];
        } else {
            [self setBackgroundColor:[UIColor blackColor] toButton:button];
        }
    }
    //[self toggleDropDownListView];
    
    [self.delegate dropDownItemButtonClicked: sender];
}

#pragma mark - Others

- (UIButton*) getDropDownButtonWithTag: (NSInteger)tag{
    for (UIButton* button in self.dropDownButtons) {
        if (button.tag == tag) {
            return button;
        }
    }
    return nil;
}

- (void)setBackgroundColor: (UIColor*)color toButton: (UIButton*) button{
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        button.backgroundColor = color;
    }];
}

- (void)toggleDropDownListView{
    
    CGFloat movingDistance = [self getMovingDistance];
    CGRect originalFrame = self.containerView.frame;
    CGRect newFrame = CGRectMake(originalFrame.origin.x,
                                 [self isDropDownMenuShowing] ? originalFrame.origin.y - movingDistance : originalFrame.origin.y
                                 + movingDistance,
                                 self.containerView.frame.size.width,
                                 self.containerView.frame.size.height);
    
    if ([self isDropDownMenuShowing]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.frame = newFrame;
        } completion:^(BOOL finished) {
            [self setHidden: YES];
        }];
    } else{
        [self setHidden: NO];
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.frame = newFrame;
        } completion:nil];
    }
}

- (BOOL) isDropDownMenuShowing{
    NSLog(@"%f", self.containerView.frame.origin.y);
    return self.containerView.frame.origin.y >= 0;
}

- (CGFloat)getMovingDistance{
    return self.dropDownListView.frame.size.height;
}

@end

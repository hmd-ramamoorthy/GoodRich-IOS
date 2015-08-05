//
//  ColorSearchViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "ILColorPickerView.h"
#import "UIColor+ColorFromRGB.h"
#import "SearchClient.h"
#import "SearchResultViewController.h"

@interface ColorSearchViewController : TemplateViewController<ILColorPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *colorDisplayView;
@property (weak, nonatomic) IBOutlet ILColorPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet UILabel *colorValueLabel;

@property (strong, nonatomic) UIColor* selectedColor;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)searchButtonClicked:(UIBarButtonItem *)sender;

@end

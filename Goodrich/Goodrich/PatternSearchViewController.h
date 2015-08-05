//
//  PatternSearchViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "PatternStyleButton.h"
#import "PatternStyleKeyButton.h"
#import "Filter.h"
#import "UIView+ActivityIndicator.h"
#import "BrowsingItemsViewController.h"

@interface PatternSearchViewController : TemplateViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *keysScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *optionsScrollView;

@end

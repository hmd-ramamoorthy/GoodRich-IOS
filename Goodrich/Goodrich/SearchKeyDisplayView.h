//
//  SearchKeyDisplayView.h
//  Goodrich
//
//  Created by Zhixing Yang on 7/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ColorFromRGB.h"
#import "RoundedUIImageView.h"
#import "Product.h"
#import "Constants.h"

@interface SearchKeyDisplayView : UIView

@property (weak, nonatomic) IBOutlet UILabel *displaySearchKeyLabel;

// Used in display original product:
@property (strong, nonatomic) Product* originalProduct;
@property (weak, nonatomic) IBOutlet RoundedUIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *patternNumberLabel;

+ (instancetype)searchKeyDisplayView;

- (void)switchToType: (BROWSING_ITEMS_TYPE) browseType
        withKeyTitle: (NSString*) title
    andColorToSearch: (UIColor*) colorToSearch
  andProductToSearch: (Product*) productToSearch;

- (void) show;

- (void) hide;

@end

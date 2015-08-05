//
//  SearchKeyDisplayView.m
//  Goodrich
//
//  Created by Zhixing Yang on 7/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "SearchKeyDisplayView.h"

#define HEIGHT_WITHOUT_IMAGE 41
#define HEIGHT_WITH_IMAGE 182

@implementation SearchKeyDisplayView

+ (instancetype)searchKeyDisplayView{
    SearchKeyDisplayView *searchKeyDisplayView = [[[NSBundle mainBundle] loadNibNamed:@"SearchKeyDisplayView" owner:nil options:nil] objectAtIndex:0];
    
    // make sure customView is not nil or the wrong class!
    if ([searchKeyDisplayView isKindOfClass:[SearchKeyDisplayView class]]){
        return searchKeyDisplayView;
    }
    else{
        return nil;
    }
}

- (void)switchToType: (BROWSING_ITEMS_TYPE) browseType
        withKeyTitle: (NSString*) title
    andColorToSearch: (UIColor*) colorToSearch
  andProductToSearch: (Product*) productToSearch{
    
    switch (browseType) {
        case BROWSING_ITEMS_TYPE_SIMILAR_ITEM:{
            // Deprecated. It'll be rended as the header of collectionView.
            /*
            self.displaySearchKeyLabel.hidden = YES;
            [self.imageIcon goodRichSetImageWithURL: productToSearch.s3URL toSize:IMAGE_SIZE_THUMBNAIL];
            self.patternNumberLabel.text = [productToSearch.specifications objectForKey:@"PatternNumber"];
            [self changeHeightTo: HEIGHT_WITH_IMAGE];
            self.backgroundColor = [UIColor colorFromRGB:<#(int)#>]
             */
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_COLOR:{
            self.imageIcon.hidden = YES;
            self.patternNumberLabel.hidden = YES;
            
            self.displaySearchKeyLabel.text = title;
            self.displaySearchKeyLabel.backgroundColor = colorToSearch;
            self.displaySearchKeyLabel.shadowColor = [UIColor blackColor];
            self.displaySearchKeyLabel.shadowOffset = CGSizeMake(1, 1);
            
            [self changeHeightTo: HEIGHT_WITHOUT_IMAGE];
            break;
        }
        default:{
            self.imageIcon.hidden = YES;
            self.patternNumberLabel.hidden = YES;
            
            self.displaySearchKeyLabel.text = title;
            [self changeHeightTo: HEIGHT_WITHOUT_IMAGE];
            break;
        }
    }
}

- (void)changeHeightTo: (CGFloat) height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void) show{
    if (![self isShowing]) {
        self.hidden = NO;
        [self.superview bringSubviewToFront: self];
        [UIView animateWithDuration:0.3 animations:^{
            self.displaySearchKeyLabel.frame = CGRectMake(0,
                                                 0,
                                                 self.displaySearchKeyLabel.frame.size.width,
                                                 self.displaySearchKeyLabel.frame.size.height);
        }];
    }
}

- (void) hide{
    if ([self isShowing]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.displaySearchKeyLabel.frame = CGRectMake(0,
                                                 -self.displaySearchKeyLabel.frame.size.height,
                                                 self.displaySearchKeyLabel.frame.size.width,
                                                 self.displaySearchKeyLabel.frame.size.height);
        } completion:^(BOOL finished) {
            [self setHidden: finished];
            
        }];
    }
}

- (BOOL) isShowing{
    return self.displaySearchKeyLabel.frame.origin.y == 0;
}

@end

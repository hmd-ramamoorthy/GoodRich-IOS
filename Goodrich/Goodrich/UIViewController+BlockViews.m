//
//  UIViewController+BlockViews.m
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "UIViewController+BlockViews.h"
#import "FacetViewController.h"
#import "BrowsingItemsViewController.h"
static const NSString * IMAGE_VIEW_KEY = @"kkkeees12randomkeykeykey";

@implementation UIViewController (BlockViews)

- (void)addBlackViewAtFrame: (CGRect)frame andSelectorWhenTouched: (SEL)action{
    BrowsingItemsViewController* selfCtl = (BrowsingItemsViewController *) self;
    
    //extend the black view if no sorttab in facetviewcontroller
    if (selfCtl.browingType != BROWSING_ITEMS_TYPE_SEARCH_RESULT_IMAGE) {
        CGFloat sortBackgroundHeight = selfCtl.facetViewController.sortBackground.frame.size.height;
        frame.size.height += sortBackgroundHeight;
    }
    
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];//[UIColor colorFromRGB: 0x17111a];

    // Associate the imageView with its key
    objc_setAssociatedObject (self, &IMAGE_VIEW_KEY, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    view.tag = -1;
    view.alpha = 1;
    //UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [self.view addSubview:view];

    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:tapGR];
    
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeBlackView{
    UIView* view = (UIView *)objc_getAssociatedObject(self, &IMAGE_VIEW_KEY);
    objc_removeAssociatedObjects(self);
    [view removeFromSuperview];
    view = nil;
}
@end

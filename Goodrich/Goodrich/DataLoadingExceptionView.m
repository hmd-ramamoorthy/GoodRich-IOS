//
//  DataLoadingExceptionView.m
//  Goodrich
//
//  Created by Zhixing on 2/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "DataLoadingExceptionView.h"

@implementation DataLoadingExceptionView

+ (instancetype)dataLoadingExceptionView{
    DataLoadingExceptionView *dataLoadingExceptionView = [[[NSBundle mainBundle] loadNibNamed:@"DataLoadingExceptionView" owner:nil options:nil] objectAtIndex:0];
    
    // make sure customView is not nil or the wrong class!
    if ([dataLoadingExceptionView isKindOfClass:[DataLoadingExceptionView class]]){
        return dataLoadingExceptionView;
    }
    else{
        return nil;
    }
}

- (IBAction)retryButtonClicked:(id)sender {
    [self.delegate retryButtonClicked:sender];
}

- (void)switchToMode: (DATA_LOADING_EXCEPTION_TYPE) type{
    UIColor* purpleColor = [UIColor colorFromRGB: 0x74129d];
    UIColor* greyColor = [UIColor colorFromRGB: 0xe5e5e5];
    
    switch (type) {
        case DATA_LOADING_EXCEPTION_TYPE_ERROR:{
            self.bigImageView.hidden = YES;
            self.smallImageView.hidden = NO;
            self.feedbackLabel.text = @"Data loading error";
            self.retryButton.hidden = NO;
            self.backgroundColor = purpleColor;
            break;
        }
        case DATA_LOADING_EXCEPTION_TYPE_NO_FAV:{
            self.bigImageView.hidden = NO;
            self.bigImageView.image = [UIImage imageNamed:@"fav_empty_bg_icon.png"];
            self.smallImageView.hidden = YES;
            self.feedbackLabel.text = @"You don't have any favourites right now";
            self.retryButton.hidden = YES;
            self.backgroundColor = greyColor;
            break;
        }
        case DATA_LOADING_EXCEPTION_TYPE_NO_MATCH:{
            self.bigImageView.hidden = NO;
            self.bigImageView.image = [UIImage imageNamed:@"search_result_non_icon.png"];
            self.smallImageView.hidden = YES;
            self.feedbackLabel.text = @"There is no result found";
            self.retryButton.hidden = YES;
            self.backgroundColor = greyColor;
            break;
        }
        case DATA_LOADING_EXCEPTION_TYPE_NO_SIMILAR:{
            self.bigImageView.hidden = NO;
            self.bigImageView.image = [UIImage imageNamed:@"search_result_non_icon.png"];
            self.smallImageView.hidden = YES;
            self.feedbackLabel.text = @"There is no similar item here";
            self.retryButton.hidden = YES;
            self.backgroundColor = greyColor;
            break;
        }
        default:
            break;
    }
}

@end

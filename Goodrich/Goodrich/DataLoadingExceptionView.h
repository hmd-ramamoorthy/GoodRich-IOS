//
//  DataLoadingExceptionView.h
//  Goodrich
//
//  Created by Zhixing on 2/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

typedef enum {
    DATA_LOADING_EXCEPTION_TYPE_NO_SIMILAR = 1,
    DATA_LOADING_EXCEPTION_TYPE_NO_FAV = 2,
    DATA_LOADING_EXCEPTION_TYPE_NO_MATCH = 3,
    DATA_LOADING_EXCEPTION_TYPE_ERROR = 4
} DATA_LOADING_EXCEPTION_TYPE;

#import <UIKit/UIKit.h>
#import "DataLoadingExceptionDelegate.h"
#import "RoundedUIButton.h"


@interface DataLoadingExceptionView : UIView

@property (weak, nonatomic) id<DataLoadingExceptionDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet RoundedUIButton *retryButton;

+ (instancetype)dataLoadingExceptionView;
- (IBAction)retryButtonClicked:(id)sender;
- (void)switchToMode: (DATA_LOADING_EXCEPTION_TYPE) type;

@end

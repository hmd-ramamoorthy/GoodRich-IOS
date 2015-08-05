//
//  UIViewController+HandleFailedRequest.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

typedef enum{
    REQUEST_TYPE_SINGLE_REQUEST = 1,
    REQUEST_TYPE_FULL_PAGE = 2
}REQUEST_TYPE;

#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "Constants.h"

@interface UIViewController (HandleFailedRequest)

- (void) handleFailedRequestWithErrors: (NSArray*) errors withType: (REQUEST_TYPE) requestType;

@end

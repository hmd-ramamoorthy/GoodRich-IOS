//
//  UIViewController+HandleFailedRequest.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "UIViewController+HandleFailedRequest.h"

@implementation UIViewController (HandleFailedRequest)

- (void) handleFailedRequestWithErrors: (NSArray*) errors withType: (REQUEST_TYPE) requestType{
    NSString* messageToDisplay = [self generateErrorString:errors];
    switch (requestType) {
        case REQUEST_TYPE_SINGLE_REQUEST:
        case REQUEST_TYPE_FULL_PAGE:
        default:
            [self.view makeToast:messageToDisplay duration:TOAST_MESSAGE_DURATION position:TOAST_MESSAGE_POSITION];
            break;
    }
}

- (NSString*)generateErrorString: (NSArray*) errorsArray{

    NSMutableString* errorMessage = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [errorsArray count]; i++) {
        [errorMessage appendString:errorsArray[i]];
    }
    
    if (errorMessage == nil || errorMessage.length == 0 ||[errorMessage isEqualToString:@""]) {
        [errorMessage appendString:@"Oops, network condition is not good. Please try again later"];
    }
    
    return [NSString stringWithString:errorMessage];
}

@end

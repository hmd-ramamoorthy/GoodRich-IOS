//
//  LoginSuccessfulDelegate.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol LoginSuccessfulDelegate <NSObject>

- (void) loginSuccessful;
- (void) userLoggedOutWithReason: (LOG_OUT_REASON) reason;

@end

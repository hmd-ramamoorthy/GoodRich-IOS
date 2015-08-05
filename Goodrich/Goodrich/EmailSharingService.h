//
//  EmailSharingService.h
//  Goodrich
//
//  Created by Sai on 6/17/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailSharingService : NSObject

+ (void)sendEmailWithProducts:(NSArray *)products
                    completed:(void (^)(UIViewController *vc)) complete;

@end

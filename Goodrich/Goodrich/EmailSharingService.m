//
//  EmailSharingService.m
//  Goodrich
//
//  Created by Sai on 6/17/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "EmailSharingService.h"
#import "EmailModel.h"
#import "EmailShareController.h"

@implementation EmailSharingService

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (void)sendEmailWithProducts:(NSArray *)products
                    completed:(void (^)(UIViewController *vc)) complete
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:NULL];
    EmailShareController *emailVC = [storyBoard instantiateViewControllerWithIdentifier:@"EMAIL_SHARE"];
    EmailModel *model = [[EmailModel alloc] initWithProducts:products];

    [emailVC setModel:model];
    complete(emailVC);
}

@end

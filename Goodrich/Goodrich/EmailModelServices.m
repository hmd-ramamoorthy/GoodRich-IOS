//
//  EmailModelServices.m
//  Goodrich
//
//  Created by Shaohuan on 3/9/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "EmailModelServices.h"
#import "HTTPClient.h"
#import "Product.h"

@implementation EmailModelServices

- (void)retrieveDetailWithIds:(NSArray *)ids
                      success:(void (^)(NSInteger, id))success
                      failure:(void (^)(NSInteger, id))failure {
    [[HTTPClient sharedInstance] getProductDetailsWithIds:ids success:^(NSInteger statusCode, id data) {
        //check this part with GoodRich API
        NSDictionary *response = (NSDictionary *)data;
        NSArray *result = [response objectForKey:@"result"];
        
        //update email model
        for (int i = 0; i < self.model.products.count; i++) {
            Product *p = [self.model.products objectAtIndex:i];
            p.details = [[result objectAtIndex:i] objectForKey:@"user_fields"];
            NSLog(@"%@",p.details);
        }
        
        if (!success) {
            return;
        }
        success(statusCode, data);
        
    } failure:^(NSInteger statusCode, id data) {
        // Do something here when error returns
    }];
}

- (void)sendEmailWithsuccess:(void (^)(NSInteger, id))success
                     failure:(void (^)(NSInteger, id))failure {
   [[HTTPClient sharedInstance] sendEmailWithData:[self.model toDict]
    success:^(NSInteger statusCode, id data) {
       success(statusCode, data);
   }
    failure:^(NSInteger statusCode, id data) {
        failure(statusCode, data);
   }];
}

@end

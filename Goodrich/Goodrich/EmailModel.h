//
//  EmailModel.h
//  Goodrich
//
//  Created by Shaohuan on 3/3/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmailModelDelegate <NSObject>

@required

/**
  Update email model's detail field. This is a async call
  
  @param ids An array of products ids whose detail field needs to update
  @param success A block to handle success response
  @param failure A block to handle failure response
 */
- (void)retrieveDetailWithIds:(NSArray *)ids
                      success:(void (^)(NSInteger statusCode, id response))success
                      failure:(void (^)(NSInteger statusCode, id response))failure;

/**
 Send the email content to server
 
 @param success A block to handle success response
 @param failure A block to handle failure response
 */
- (void)sendEmailWithsuccess:(void (^)(NSInteger statusCode, id response))success
                     failure:(void (^)(NSInteger statusCode, id response))failure;
@end

/**
  This class represent a common email model.
 */

@interface EmailModel : NSObject

// Share Data
@property NSArray *contacts;
@property NSString *subject;
@property NSString *emailContent;
@property(nonatomic) NSArray *productIds;

// View Data
@property NSArray *products;
@property NSString *contactsString;

// Email model services
@property id<EmailModelDelegate> services;

- (id)initWithProducts:(NSArray *)products;

- (NSDictionary *)toDict;
@end

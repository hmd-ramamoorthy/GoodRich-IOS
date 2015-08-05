//
//  HTTPClient.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "UIViewController+LogoutLogic.h"
#import "UIViewController+HandleFailedRequest.h"
#import <AFNetworking.h>
#import "HttpRequestConsts.h"
#import <AFHTTPRequestOperation.h>
#import <AFHTTPSessionManager.h>
#import <AFHTTPRequestOperationManager.h>
#import "User.h"
#import "HTTPRequestManager.h"
#import "AppDelegate.h"
#include <CommonCrypto/CommonDigest.h>

typedef enum {
    FAVORITE_REQUEST_TYPE_GET = 1,
    FAVORITE_REQUEST_TYPE_SET = 2,
    FAVORITE_REQUEST_TYPE_REMOVE = 3
}FAVORITE_REQUEST_TYPE;

@class HTTPClient;

@interface HTTPClient : NSObject
+ (HTTPClient *) sharedInstance;

// TODO: check network rechability, check authorization at the beginning

- (void)userLogin:(NSString*) account
         Password:(NSString*) password
          success:(void (^)(NSInteger statusCode, id responseObject))success
          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)resetPassword:(NSString*) account
              success:(void (^)(NSInteger statusCode, id responseObject))success
              failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)getProductInfoWithLimit: (int)limit
                        andPage: (int)page
                  andFieldQuery: (NSArray*)fieldQuery
                   andFieldList: (NSArray*)fieldList
                       andFacet: (NSArray*)facet
        Success:(void (^)(NSInteger statusCode, id responseObject))success
              failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)getOrSetFavourites: (FAVORITE_REQUEST_TYPE) requestType
              andProductID: (NSString*) productID
                andSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                   failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)getProductDetailsWithName: (NSString*) productName
                       andSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)getRefineFieldListSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)getFacetItemsWithCategory: (NSString*)category
                      FacetTitles: (NSArray*)titles
                          success:(void (^)(NSInteger statusCode, id responseObject))success
                          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)updateSearchHistoryWithMethod: (NSString*)method
                             andImage: (UIImage*)image
                             andColor: (NSString*) color
                              andText: (NSString*) text
                                   andLimit: (int)limit
                              andPage: (int) page
                         andFieldList: (NSArray*) fieldList
                              success:(void (^)(NSInteger statusCode, id responseObject))success
                              failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)getPatternStyleListSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                           failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)textSearchWithText: (NSString*) text
                 WithLimit: (int)limit
                   andPage: (int)page
             andFieldQuery: (NSString*)fieldQueryString
              andFieldList: (NSArray*)fieldList
                  andFacet: (NSArray*)facet
                   success:(void (^)(NSInteger statusCode, id responseObject))success
                   failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;
- (void)updateShareHistory: (NSArray*) productIds
                   success:(void (^)(NSInteger statusCode, id responseObject))success
                   failure:(void (^)(NSInteger statusCode, NSArray* errors))failure;

- (void)getProductDetailsWithIds:(NSArray *)ids
                      success:(void (^)(NSInteger, id))success
                      failure:(void (^)(NSInteger, id))failure;

- (void)sendEmailWithData:(NSDictionary *)data
                  success:(void (^)(NSInteger, id))success
                  failure:(void (^)(NSInteger, id))failure;

@end

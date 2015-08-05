//
//  HTTPClient.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient

static User *currentUsr;

+ (HTTPClient *)sharedInstance{
    currentUsr = [User sharedInstance];
    
    static dispatch_once_t once;
    static HTTPClient *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    return self;
}

#pragma mark - HTTP Request Methods

- (void)userLogin:(NSString*) account
         Password:(NSString*) password
          success:(void (^)(NSInteger statusCode, id responseObject))success
          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    NSDictionary *data = @{
                                @"user_name": account,
                                @"password": password,
                                   
                           };
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:LOGIN]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)resetPassword:(NSString*) account
              success:(void (^)(NSInteger statusCode, id responseObject))success
              failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    
    NSDictionary *data = @{
                           @"email": account,
                           };
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:RESET_PASSWORD]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)getProductInfoWithLimit: (int)limit
                        andPage: (int)page
                  andFieldQuery: (NSArray*)fieldQueryString
                   andFieldList: (NSArray*)fieldList
                       andFacet: (NSArray*)facet
                        Success:(void (^)(NSInteger statusCode, id responseObject))success
                        failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    [data setObject:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    if (fieldQueryString != nil) {
        [data setObject: [NSSet setWithArray:fieldQueryString] forKey:@"fq"];
    }
    if (fieldList != nil) {
        [data setObject:[self convertArrayToString:fieldList] forKey:@"fl"];
    }
    if (facet != nil) {
        [data setObject:[self convertArrayToString:facet] forKey:@"facet"];
    }
    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:PRODUCT_INFO]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)getOrSetFavourites: (FAVORITE_REQUEST_TYPE) requestType
              andProductID: (NSString*) productID
                andSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                   failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject:currentUsr.userID forKey:@"user_id"];

    switch (requestType) {
        case FAVORITE_REQUEST_TYPE_REMOVE:{
            [data setObject:productID forKey:@"product_id"];
            [data setObject:@"remove" forKey:@"action"];
            break;
        }
        case FAVORITE_REQUEST_TYPE_SET:{
            [data setObject:productID forKey:@"product_id"];
            break;
        }
        case FAVORITE_REQUEST_TYPE_GET:{
            
            break;
        }
        default:
            break;
    }

    HTTPRequestManager *manager = [HTTPRequestManager manager];
    
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:FAVORITE]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)getProductDetailsWithName: (NSString*) productName
                       andSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    NSDictionary* data = @{
                                  @"product_id": productName,
                                  };
    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:PRODUCT_DETAIL]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)getRefineFieldListSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{

    HTTPRequestManager *manager = [HTTPRequestManager manager];

    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:REFINE_FIELD_LIST]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)getFacetItemsWithCategory: (NSString*)category
                      FacetTitles: (NSArray*)titles
                          success:(void (^)(NSInteger statusCode, id responseObject))success
                          failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    [self getProductInfoWithLimit:10 andPage:1 andFieldQuery:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"Category:%@", [category lowercaseString]],nil] andFieldList:nil andFacet:titles Success:^(NSInteger statusCode, id responseObject) {
        success(statusCode, responseObject);
    } failure:^(NSInteger statusCode, NSArray *errors) {
        failure(statusCode, errors);
    }];
}

- (void)updateSearchHistoryWithMethod: (NSString*)method
                             andImage: (UIImage*)image
                             andColor: (NSString*) color
                              andText: (NSString*) text
                             andLimit: (int)limit
                              andPage: (int) page
                         andFieldList: (NSArray*) fieldList
                              success:(void (^)(NSInteger statusCode, id responseObject))success
                              failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject: currentUsr.userID forKey:@"user_id"];
    [data setObject: method forKey:@"search_method"];
    if(image!=nil){
        [data setObject: [self getUploadImageUrl: image] forKey:@"search_query"];
    }else if(color!=nil){
        [data setObject: color forKey:@"search_query"];
    }else if(text!=nil){
        [data setObject: text forKey:@"search_query"];
    }
    [data setObject: [NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    [data setObject: [NSString stringWithFormat:@"%d", page] forKey:@"page"];
    if (fieldList != nil) {
        [data setObject:[self convertArrayToString: fieldList] forKey:@"fl"];
    }

    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:SEARCH_HISTORY]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}


- (void)updateShareHistory: (NSArray*) productIds
                              success:(void (^)(NSInteger statusCode, id responseObject))success
                              failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject: currentUsr.userID forKey:@"user_id"];
    [data setObject: [self convertArrayToString:productIds] forKey:@"product_ids"];
    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:SHARE_HISTORY]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)getPatternStyleListSuccess:(void (^)(NSInteger statusCode, id responseObject))success
                           failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:PATTERN_STYLE_LIST]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)textSearchWithText: (NSString*) text
                 WithLimit: (int)limit
                   andPage: (int)page
             andFieldQuery: (NSString*)fieldQueryString
              andFieldList: (NSArray*)fieldList
                  andFacet: (NSArray*)facet
                   success:(void (^)(NSInteger statusCode, id responseObject))success
                   failure:(void (^)(NSInteger statusCode, NSArray* errors))failure{
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    [data setObject: text forKey:@"text"];
    [data setObject: [NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    [data setObject: [NSString stringWithFormat:@"%d", page] forKey:@"page"];
    
    if (fieldQueryString != nil) {
        [data setObject: fieldQueryString forKey:@"fq"];
    }
    
    if (fieldList != nil) {
        [data setObject:[self convertArrayToString: fieldList] forKey:@"fl"];
    }
    
    if (facet != nil) {
        [data setObject:[self convertArrayToString: facet] forKey:@"facet"];
    }
    
    HTTPRequestManager *manager = [HTTPRequestManager manager];
    
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:TEXT_SEARCH]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, responseObject[@"errors"]);
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation.response.statusCode, nil);
          }];
}

- (void)getProductDetailsWithIds:(NSArray *)ids
                         success:(void (^)(NSInteger, id))success
                         failure:(void (^)(NSInteger, id))failure
{
    //prepare data
    NSMutableDictionary *postData = [NSMutableDictionary dictionary];
    NSString *idsString = [ids componentsJoinedByString:@","];
    
    [postData setObject:idsString forKey:@"im_names"];
    
    //post
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"get products");
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:PRODUCT_DETAIL]
        parameters:postData
        success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            if ([self isRequestSuccessful: responseObject]) {
                success(operation.response.statusCode, responseObject);
            } else{
                failure(operation.response.statusCode, responseObject[@"errors"]);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            failure(operation.response.statusCode, nil);
        }];
    
    //set timeout interval back to 60s
}

- (void)sendEmailWithData:(NSDictionary *)data
                  success:(void (^)(NSInteger, id))success
                  failure:(void (^)(NSInteger, id))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:5];

    NSLog(@"start to share");
    [manager.requestSerializer setValue:[self generateUserAuthHeader] forHTTPHeaderField:@"Authorization"];
    [manager POST:[REQUEST_DOMAIN stringByAppendingString:@"/api/share"]
       parameters:data
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"%@", responseObject);
              if ([self isRequestSuccessful: responseObject]) {
                  success(operation.response.statusCode, responseObject);
              } else{
                  failure(operation.response.statusCode, [responseObject[@"errors"] objectAtIndex:0]);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@", error);
              failure(operation.response.statusCode, error.localizedDescription);
          }];
    //set timeout interval back to 60s
}

#pragma mark - Private

- (NSString*)convertArrayToString:(NSArray*)array{
    NSMutableString* result = [[NSMutableString alloc]init];
    for (int i = 0; i < array.count - 1; i++) {
        NSString* str = [array objectAtIndex:i];
        [result appendString:str];
        [result appendString:@","];
    }
    [result appendString:[array lastObject]];
    return result;
}

- (NSString*)generateUserAuthHeader{
    NSString* str = [NSString stringWithFormat:@"%@:%@", [DataClient sharedInstance].userAccessKey, [DataClient sharedInstance].userSecretKey];
    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [NSString stringWithFormat:@"Basic %@", [plainData base64EncodedStringWithOptions:0]];

    return base64String;
}

- (NSString*)generateAppAuthHeader{
    NSString* str = [NSString stringWithFormat:@"%@:%@", [DataClient sharedInstance].appAccessKey, [DataClient sharedInstance].appSecretKey];
    NSData *plainData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [NSString stringWithFormat:@"Basic %@", [plainData base64EncodedStringWithOptions:0]];
    
    return base64String;
}

- (BOOL) isRequestSuccessful: (id) responseObject{
    return [responseObject[@"status"] isEqualToString: @"OK"];
}

// Not used for now.
- (void) handleFailedResponse:(AFHTTPRequestOperation *)operation andError:(NSError *)error andFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    switch (operation.response.statusCode) {
        case 401: // Not authorized
            [self userNotAuthorized];
            break;
        case 500:
            [self internalServerError];
        default:
            failure(operation, error);
            break;
    }
}

- (void) userNotAuthorized{
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.lastViewController userLoggedOutWithReason:LOG_OUT_REASON_NOT_AUTH];
}

- (void) internalServerError{
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.lastViewController handleFailedRequestWithErrors:[NSArray arrayWithObjects:@"Sorry, some problem occurred at the server. Please try again later.", nil] withType:REQUEST_TYPE_SINGLE_REQUEST];
}

- (NSString*) getUploadImageUrl: (UIImage*)image{
        
    NSMutableString* url = [[NSMutableString alloc] init];
    NSString* code = [self getSHA1FromNSData:UIImageJPEGRepresentation(image, JPEG_IMAGE_COMPRESS_RATE)];
    
    [url appendString: HTTP_PREFIX];
    [url appendString: S3_END_POINT];
    [url appendString: S3_UPLOADER_BUCKET];
    [url appendString: SEARCH_ACCOUNT];
    [url appendString: APP_ACCOUNT];
    [url appendString: code];
    [url appendString: @".jpg"];
    
    return [NSString stringWithString: url];
}

- (NSString*)getSHA1FromNSData: (NSData*)data{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return [NSString stringWithString: output];
}

@end

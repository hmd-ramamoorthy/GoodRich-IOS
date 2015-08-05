//
//  SearchClient.h
//  Goodrich
//
//  Created by Zhixing on 29/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViSearchAPI.h"
#import "DataClient.h"
#import "Constants.h"
#import "HTTPClient.h"
#import "Filter.h"

@interface SearchClient : NSObject

+ (SearchClient *) sharedInstance;

- (void)registerViSearchSDK;

-(void) idSearch: (NSString*) idToSearch
   andFieldQuery: (NSDictionary*)fieldQueryDictionary
    andFieldList: (NSArray*)fieldList
        andFacet: (NSArray*)facet
        andLimit: (int)limit
         andPage: (int)page
     andScoreMin: (float)scoreMin
     andScoreMax: (float)scoreMax
         success:(void (^)(NSDictionary* responseObject))success
         failure:(void (^)(NSArray* errors))failure;

-(void) colorSearch: (NSString*) haxColor
      andFieldQuery: (NSDictionary*)fieldQueryDictionary
       andFieldList: (NSArray*)fieldList
           andFacet: (NSArray*)facet
           andLimit: (int)limit
            andPage: (int)page
        andScoreMin: (float)scoreMin
        andScoreMax: (float)scoreMax
            success:(void (^)(NSDictionary* responseObject))success
            failure:(void (^)(NSArray* errors))failure;

-(void) uploadSearch: (UIImage*) image
       andFieldQuery: (NSDictionary*)fieldQueryDictionary
        andFieldList: (NSArray*)fieldList
            andFacet: (NSArray*)facet
            andLimit: (int)limit
         andPriority: (NSString*)priority
             andPage: (int)page
         andScoreMin: (float)scoreMin
         andScoreMax: (float)scoreMax
     andCroppedFrame: (CGRect) frame
             success:(void (^)(NSDictionary* responseObject))success
             failure:(void (^)(NSArray* errors))failure;

- (void) searchForBrowingWithType: (BROWSING_ITEMS_TYPE) type
                    andIdToSearch: (NSString*) imName
                 andcolorToSearch: (UIColor*) colorToSearch
                 andimageToSearch: (UIImage*) imageToSearch
               andkeywordToSearch: (NSString*) keywordToSearch
                    andFieldQuery: (Filter*)filter
                     andFieldList: (NSArray*)fieldList
                      andPriority: (NSString*) priority
                         andFacet: (NSArray*)facet
                         andLimit: (int)limit
                          andPage: (int)page
                  andCroppedFrame: (CGRect) frame
                          success:(void (^)(NSDictionary* responseObject))success
                          failure:(void (^)(NSArray* errors))failure;


@end

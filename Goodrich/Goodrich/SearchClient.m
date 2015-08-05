//
//  SearchClient.m
//  Goodrich
//
//  Created by Zhixing on 29/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "SearchClient.h"

@implementation SearchClient

+ (SearchClient *)sharedInstance{
    static dispatch_once_t once;
    static SearchClient *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (void)registerViSearchSDK{
    [ViSearchAPI initWithAccessKey: [DataClient sharedInstance].appAccessKey
                      andSecretKey: [DataClient sharedInstance].appSecretKey];
}

#pragma mark - Search API

-(void) idSearch: (NSString*) idToSearch
   andFieldQuery: (NSDictionary*)fieldQueryDictionary
    andFieldList: (NSArray*)fieldList
        andFacet: (NSArray*)facet
        andLimit: (int)limit
         andPage: (int)page
     andScoreMin: (float)scoreMin
     andScoreMax: (float)scoreMax
         success:(void (^)(NSDictionary* responseObject))success
         failure:(void (^)(NSArray* errors))failure{
    
    SearchParams *searchParams = [[SearchParams alloc] init];
    searchParams.imName = idToSearch;
    searchParams.scoreMin = scoreMin;
    searchParams.scoreMax = scoreMax;
    [self constructSearchParams:searchParams andFieldQuery:fieldQueryDictionary andFieldList:fieldList andFacet:facet andLimit: limit andPage: page];
    [self performSearchWithPrarms:searchParams andSearchType:SEARCH_TYPE_ID success:success failure:failure];
}

-(void) colorSearch: (NSString*) haxColor
      andFieldQuery: (NSDictionary*)fieldQueryDictionary
       andFieldList: (NSArray*)fieldList
           andFacet: (NSArray*)facet
           andLimit: (int)limit
            andPage: (int)page
        andScoreMin: (float)scoreMin
        andScoreMax: (float)scoreMax
            success: (void (^)(NSDictionary* responseObject))success
            failure: (void (^)(NSArray* errors))failure{
    ColorSearchParams *colorSearchParams = [[ColorSearchParams alloc] init];
    colorSearchParams.color = haxColor;
    colorSearchParams.scoreMax = scoreMax;
    colorSearchParams.scoreMin = scoreMin;
    [self constructSearchParams:colorSearchParams andFieldQuery:fieldQueryDictionary andFieldList:fieldList andFacet:facet andLimit: limit andPage: page];
    [self performSearchWithPrarms:colorSearchParams andSearchType:SEARCH_TYPE_COLOR success:success failure:failure];
}

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
             failure:(void (^)(NSArray* errors))failure{
    
    UploadSearchParams *uploadSearchParams = [[UploadSearchParams alloc] init];
    uploadSearchParams.imageFile = image;
    uploadSearchParams.box = [self convertCGRectToBox:frame];
    uploadSearchParams.priority = priority;
    uploadSearchParams.scoreMax = scoreMax;
    uploadSearchParams.scoreMin = scoreMin;
    if([priority isEqualToString:@"color"]){
        uploadSearchParams.scoreMin = SCORE_MIN_DEFAULT_UPLOAD_COLOR;
    }
    [self constructSearchParams:uploadSearchParams andFieldQuery:fieldQueryDictionary andFieldList:fieldList andFacet:facet andLimit: limit andPage: page];
    [self performSearchWithPrarms:uploadSearchParams andSearchType:SEARCH_TYPE_IMAGE success:success failure:failure];
}

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
                          success: (void (^)(NSDictionary* responseObject))success
                          failure: (void (^)(NSArray* errors))failure{
    switch (type) {
        case BROWSING_ITEMS_TYPE_ALL:
        case BROWSING_ITEMS_TYPE_FAVOURITE:
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_PATTERN:{
            [[HTTPClient sharedInstance] getProductInfoWithLimit:limit
                                                         andPage:page
                                                   andFieldQuery:[filter getQueryArray]
                                                    andFieldList:fieldList
                                                        andFacet:facet
                                                         Success:^(NSInteger statusCode, id responseObject) {
                                                             success(responseObject);
                                                         } failure:^(NSInteger statusCode, NSArray *errors) {
                                                             failure(errors);
                                                         }];
            break;
        }
            
        case BROWSING_ITEMS_TYPE_SIMILAR_ITEM:{
            [self idSearch:imName
             andFieldQuery:[filter getQueryDictionary]
              andFieldList:fieldList
                  andFacet:facet
                  andLimit:limit
                   andPage:page
               andScoreMin: 0
               andScoreMax: 1
                   success:^(id responseObject) {
                       success(responseObject);
                   } failure:^(NSArray *errors) {
                       failure(errors);
                   }];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_COLOR:{
            [self colorSearch:[colorToSearch hexStringFromColor]
                andFieldQuery:[filter getQueryDictionary]
                 andFieldList:fieldList
                     andFacet:facet
                     andLimit:limit
                      andPage:page
                  andScoreMin:SCORE_MIN_DEFAULT_COLOR
                  andScoreMax:1
                      success:^(NSDictionary *responseObject) {
                          success(responseObject);
                      } failure:^(NSArray *errors) {
                          failure(errors);
                      }];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_IMAGE:{
            [self uploadSearch:imageToSearch
                 andFieldQuery:[filter getQueryDictionary]
                  andFieldList:fieldList
                      andFacet:facet
                      andLimit:limit
                   andPriority: priority
                       andPage:page
                   andScoreMin: SCORE_MIN_DEFAULT_UPLOAD
                   andScoreMax: 1
               andCroppedFrame: frame
                       success:^(NSDictionary *responseObject) {
                           success(responseObject);
                       } failure:^(NSArray *errors) {
                           failure(errors);
                       }];
            break;
        }
        case BROWSING_ITEMS_TYPE_SEARCH_RESULT_TEXT:{
            [[HTTPClient sharedInstance] textSearchWithText:keywordToSearch WithLimit:limit andPage:page andFieldQuery:[filter getQueryString] andFieldList:fieldList andFacet:facet success:^(NSInteger statusCode, id responseObject) {
                success(responseObject);
            } failure:^(NSInteger statusCode, NSArray *errors) {
                failure(errors);
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private

- (void)constructSearchParams:(BaseSearchParams*)searchParams
                andFieldQuery: (NSDictionary*)fieldQueryDictionary
                 andFieldList: (NSArray*)fieldList
                     andFacet: (NSArray*)facet
                     andLimit: (int)limit
                      andPage: (int)page{
    if (fieldQueryDictionary != nil) {
        searchParams.fq = fieldQueryDictionary;
    }
    if (fieldList != nil) {
        searchParams.fl = fieldList;
    }
    searchParams.facet = true;
    searchParams.facetSize = (int)facet.count;
    searchParams.facetField = facet;
    searchParams.limit = limit;
    searchParams.page = page;
}

- (void)performSearchWithPrarms: (id)params
                  andSearchType: (SEARCH_TYPE) searchType
                        success:(void (^)(NSDictionary* responseObject))success
                        failure:(void (^)(NSArray* errors))failure{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ViSearchResult *visenzeResult;
        switch (searchType) {
            case SEARCH_TYPE_COLOR:
                visenzeResult = [[ViSearchAPI search] colorSearch:params];
                break;
            case SEARCH_TYPE_ID:
                visenzeResult = [[ViSearchAPI search] search:params];
                break;
            case SEARCH_TYPE_IMAGE:
                visenzeResult = [[ViSearchAPI search] uploadSearch:params];
                break;
            default:
                NSLog(@"Error: search method not implemented in search API");
                break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(([visenzeResult.content objectForKey:@"status"]!=nil)&&([[visenzeResult.content objectForKey:@"status"] isEqualToString:@"OK"])){
                success(visenzeResult.content);
            }else{
                if (visenzeResult.error.message != nil) {
                    failure([NSArray arrayWithObject: visenzeResult.error.message]);
                } else{
                    failure(nil);
                }
            }
        });
    });
}

- (Box*) convertCGRectToBox: (CGRect) croppedFrame{
    if (CGRectEqualToRect(croppedFrame, FULL_FRAME_OF_IMAGE)) {
        return nil;
    } else{
        return [[Box alloc] initWithX1: croppedFrame.origin.x
                                    x2: croppedFrame.origin.x + croppedFrame.size.width
                                    y1: croppedFrame.origin.y
                                    y2: croppedFrame.origin.y + croppedFrame.size.height];
    }
}

@end
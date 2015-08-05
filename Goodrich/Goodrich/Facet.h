//
//  Facet.h
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Facet : NSObject

@property (strong, nonatomic) NSString* facetKey;
@property (strong, nonatomic) NSArray* facetItems;
@property (strong, nonatomic) NSArray* facetItemsCounts;

+ (instancetype)FacetFromDictionary: (NSDictionary*)dict;
+ (instancetype)FacetFromNotSearch: (NSDictionary*)dict;
+ (instancetype)FacetFromBrowsing: (NSDictionary*)dict;
@end

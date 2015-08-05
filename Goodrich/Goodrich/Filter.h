//
//  Filter.h
//  Goodrich
//
//  Created by Zhixing on 26/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Filter : NSObject

@property (strong, nonatomic) NSString* key;

- (void)removeFilterWithFilterName: (NSString*)key;

- (void)setFilterWithFilterName: (NSString*)key andFilterValues: (NSArray*)values;

- (NSArray*)getFilterValuesWithFilterName: (NSString*)key;

/*
 *  Return string with format: @"Category:wallcovering,PatternStyle:Kids|Damask|Fabric/Silks,ProductType:Paper"
 *  Returns nil if no query
 *  For for http search use
 */
- (NSString*)getQueryString;

/*
 *  Returns query dictionary:
 *  @Return: @{String key, String value from flattened array}
 *  For sdk search use
 */
- (NSDictionary*)getQueryDictionary;
- (NSArray*)getQueryArray;
- (NSDictionary*)getQueryDict;

/*
 *  Return string with format: @"Paper|Non Woven|RRR"
 *  Returns nil if no such key exists
 */
- (NSString*)getFilterValueByKey: (NSString*)key;

@end

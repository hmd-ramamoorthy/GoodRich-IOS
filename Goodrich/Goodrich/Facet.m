//
//  Facet.m
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "Facet.h"

@implementation Facet

+ (instancetype)FacetFromDictionary: (NSDictionary*)dict{
    Facet* facet = [[Facet alloc] init];
    
    facet.facetKey = dict[@"key"];
    
    NSMutableArray* tempItems = [[NSMutableArray alloc] init];
    NSMutableArray* tempItemsCounts = [[NSMutableArray alloc] init];

    for (NSDictionary* pair in dict[@"facetItems"]) {
        NSString* key = pair[@"value"];
        if (![key isEqualToString: @""]) {
            [tempItems addObject:key];
            [tempItemsCounts addObject:[NSNumber numberWithInteger:[(NSString*)pair[@"count"] integerValue]]];
        }
    }
    facet.facetItems = [NSArray arrayWithArray:tempItems];
    facet.facetItemsCounts = [NSArray arrayWithArray:tempItemsCounts];
    
    return facet;
}

+ (instancetype)FacetFromNotSearch: (NSDictionary*)dict{
    Facet* facet = [[Facet alloc] init];
    
    facet.facetKey = dict[@"key"];
    
    NSMutableArray* tempItems = [[NSMutableArray alloc] init];
    NSMutableArray* tempItemsCounts = [[NSMutableArray alloc] init];
    
    for (NSDictionary* pair in dict[@"items"]) {
        NSString* key = pair[@"value"];
        if (![key isEqualToString: @""]) {
            [tempItems addObject:key];
            [tempItemsCounts addObject:[NSNumber numberWithInteger:[(NSString*)pair[@"count"] integerValue]]];
        }
    }
    facet.facetItems = [NSArray arrayWithArray:tempItems];
    facet.facetItemsCounts = [NSArray arrayWithArray:tempItemsCounts];
    
    return facet;
}

+ (instancetype)FacetFromBrowsing: (NSDictionary*)dict{
    Facet* facet = [[Facet alloc] init];
    
    facet.facetKey = dict[@"key"];
    
    NSMutableArray* tempItems = [[NSMutableArray alloc] init];
    NSMutableArray* tempItemsCounts = [[NSMutableArray alloc] init];
    
    for (NSDictionary* pair in dict[@"facetItems"]) {
        NSString* key = pair[@"value"];
        if (![key isEqualToString: @""]) {
            [tempItems addObject:key];
            [tempItemsCounts addObject:[NSNumber numberWithInteger:[(NSString*)pair[@"count"] integerValue]]];
        }
    }
    facet.facetItems = [NSArray arrayWithArray:tempItems];
    facet.facetItemsCounts = [NSArray arrayWithArray:tempItemsCounts];
    
    return facet;
}

@end

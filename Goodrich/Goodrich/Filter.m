//
//  Filter.m
//  Goodrich
//
//  Created by Zhixing on 26/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "Filter.h"

@interface Filter ()

@property (strong, nonatomic) NSMutableDictionary* filterList;
@end

@implementation Filter
- (instancetype)init{
    self = [super init];
    if (self) {
        self.filterList = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Filter Logic

- (void)removeFilterWithFilterName: (NSString*)key{
    [self.filterList removeObjectForKey:key];
}
- (void)setFilterWithFilterName: (NSString*)key andFilterValues: (NSArray*)values{
    if (key == nil) {
        NSLog(@"Error: set filter with null key");
    } else if (values == nil || values.count == 0){
        [self removeFilterWithFilterName:key];
    } else{
        [self.filterList setObject:values forKey:key];
    }
}

- (NSArray*)getFilterValuesWithFilterName: (NSString*)key{
    if (key == nil) {
        NSLog(@"Error: get filter values with null key");
        return nil;
    } else{
        return [self.filterList objectForKey:key];
    }
}

- (NSString*)getQueryString{
    NSMutableString* result = [[NSMutableString alloc] init];
    
    for (NSString* key in [self.filterList allKeys]) {
        NSArray* value = [self.filterList objectForKey:key];
        if (key != nil && value != nil && value.count != 0) {
            [result appendFormat:@"%@:%@,",key, [self flattenArray:value]];
        }
    }
    
    if (result.length == 0){
        return nil;
    } else{
        return [result substringToIndex:result.length-1];
    }
}
- (NSArray*)getQueryArray{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    for (NSString* key in [self.filterList allKeys]) {
        NSArray* value = [self.filterList objectForKey:key];
        if (key != nil && value != nil && value.count != 0) {
            [result addObject: [NSString stringWithFormat:@"%@:%@",key, [self flattenArray:value]]];
        }
    }
    
    if ([result count] == 0){
        return nil;
    } else{
        return result;
    }
}

- (NSString*)getFilterValueByKey: (NSString*)key{
    if ([self.filterList objectForKey:key] == nil) {
        return nil;
    } else{
        return [self flattenArray:[self.filterList objectForKey:key]];
    }
}


- (NSDictionary*)getQueryDict{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    for (NSString* key in self.filterList.allKeys) {
        NSString* value = [self flattenArray:[self.filterList objectForKey:key]];
        if (key != nil && value != nil) {
            [result setObject:value forKey:key];
        }
    }
    if (result.allKeys.count > 0) {
        return [NSDictionary dictionaryWithDictionary: result];
    } else{
        return nil;
    }
}

- (NSDictionary*)getQueryDictionary{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    for (NSString* key in self.filterList.allKeys) {
        NSString* value = [self flattenArray:[self.filterList objectForKey:key]];
        if (key != nil && value != nil) {
            [result setObject:value forKey:key];
        }
    }
    if (result.allKeys.count > 0) {
        return [NSDictionary dictionaryWithDictionary: result];
    } else{
        return nil;
    }
}

#pragma mark - Private

/*
 @param: @[@"Paper", @"Non Woven", @"RRR"]
 @return: @"Paper|Non Woven|RRR"
 */
- (NSString*)flattenArray: (NSArray*)strArray{
    NSMutableString* result = [[NSMutableString alloc] init];
    for (int i = 0; i < strArray.count - 1; i++) {
        NSString* str = (NSString*)[strArray objectAtIndex: i];
        [result appendFormat:@"%@|", str];
    }
    [result appendString:[strArray lastObject]];
    return result;
}

@end

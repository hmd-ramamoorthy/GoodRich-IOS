//
//  Product.m
//  Goodrich
//
//  Created by Zhixing Yang on 18/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "Product.h"

@implementation Product

+(instancetype)productFromDictionary: (NSDictionary*)dict andKeyForSpecs:(NSString *)keyName{
    Product* product = [[Product alloc]init];
    product.productName = dict[@"im_name"];
    product.s3URL = dict[@"im_s3_url"];
    product.status = (int)[(NSString*)dict[@"status"] integerValue];
    product.details = [NSDictionary dictionary];
    
    NSString* key;
    if (dict[keyName] != nil) {
        key = keyName;
    } else if (dict[@"value_map"] != nil){
        key = @"value_map";
    } else if(dict[@"user_fields"] != nil){
        key = @"user_fields";
    }
    
    product.specifications = dict[key];
    
    return product;
}

- (NSString*)s3URL{
    if (_s3URL == nil || [_s3URL isKindOfClass:[NSNull class]]){
        return [self.specifications objectForKey: @"im_url"];
    } else{
        return _s3URL;
    }
}

@end

//
//  Product.h
//  Goodrich
//
//  Created by Zhixing Yang on 18/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

// Read from dictionary:
@property (strong, nonatomic) NSString* productName;

@property (strong, nonatomic) NSString* s3URL;
@property (nonatomic) int status;
@property (strong, nonatomic) NSDictionary* specifications;
@property NSDictionary* details;

+(instancetype)productFromDictionary: (NSDictionary*)dict andKeyForSpecs: (NSString*)keyName;

@end

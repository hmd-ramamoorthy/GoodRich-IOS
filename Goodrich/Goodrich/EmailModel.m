//
//  EmailModel.m
//  Goodrich
//
//  Created by Shaohuan on 3/3/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "EmailModel.h"
#import "Product.h"
#import "EmailModelServices.h"

@interface EmailModel()

@end

@implementation EmailModel

#pragma mark Lifecycle

- (id)initWithProducts:(NSArray *)products {
  self = [super init];
  if (self) {
    self.products = products;
    self.services = [EmailModelServices new];
    ((EmailModelServices *)self.services).model = self;
  }
  
  return self;
}

#pragma mark Customized Accessors

- (NSMutableArray *)productIds {
  NSMutableArray *ids = [NSMutableArray array];
  for (Product *p in self.products) {
    [ids addObject:p.productName];
  }
  
  return ids;
}

#pragma mark Instance Method

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *array = [NSMutableArray array];
    for (Product *p in self.products) {
        [array addObject:p.productName];
    }
    
    [dict setObject:[self.contacts componentsJoinedByString:@","] forKey:@"to"];
    [dict setObject:self.subject forKey:@"title"];
    [dict setObject:self.emailContent forKey:@"message"];
    [dict setObject:[array componentsJoinedByString:@","] forKey:@"im_names"];
    
    NSLog(@"to dict");
    NSLog(@"%@", dict);
    
    return dict;
}
@end

//
//  HTTPRequestManager.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "HTTPRequestManager.h"

@implementation HTTPRequestManager

+ (instancetype)manager{
    NSURL *url = [NSURL URLWithString:REQUEST_DOMAIN];
    return [[self alloc] initWithBaseURL:url];
}

- (id) initWithBaseURL:(NSURL *)url{
    
    self = [super initWithBaseURL:url];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    return self;
}
@end

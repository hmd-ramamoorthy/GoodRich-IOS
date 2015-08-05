//
//  User.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;

+ (User *)sharedInstance;

@end

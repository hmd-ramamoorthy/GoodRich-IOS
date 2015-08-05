//
//  EmailModelServices.h
//  Goodrich
//
//  Created by Shaohuan on 3/9/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmailModel.h"

/**
  This class help the email model class to implement its network logic
 */
@interface EmailModelServices : NSObject<EmailModelDelegate>

@property EmailModel *model;

@end

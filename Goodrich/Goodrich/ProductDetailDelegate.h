//
//  ProductDetailDelegate.h
//  Goodrich
//
//  Created by Zhixing Yang on 19/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductDetailDelegate <NSObject>

- (void) userLikedOrCanceledProductWithName: (NSString*) productName hasLiked: (BOOL) hasLiked;

@end

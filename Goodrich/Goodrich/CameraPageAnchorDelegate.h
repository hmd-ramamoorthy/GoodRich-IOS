//
//  CameraPageAnchorDelegate.h
//  Goodrich
//
//  Created by Zhixing Yang on 9/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol  CameraPageAnchorDelegate <NSObject>

- (void)searchResultReturnedWithSearchType: (SEARCH_TYPE)searchType
                           andSearchResult: (NSArray*)products
                          andImageToSearch: (UIImage*)image
                       andImageFrameToCrop: (CGRect)imageFrameToCrop;

@end

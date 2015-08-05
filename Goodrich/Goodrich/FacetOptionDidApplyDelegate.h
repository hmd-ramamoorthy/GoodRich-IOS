//
//  facetOptionDidApplyDelegate.h
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

@protocol FacetOptionDidApplyDelegate <NSObject>

- (void)facetOptionDidApplyWithOptions: (NSArray*)selectedOptions;
- (void)facetOptionDidCanceled;

@end


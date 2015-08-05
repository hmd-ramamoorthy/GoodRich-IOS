//
//  DataClient.h
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Constants.h"
#import <ViSearch/ViSearchAPI.h>

@interface DataClient : NSObject

@property (nonatomic, strong) User* user;

@property (nonatomic, strong) NSString *userSecretKey;
@property (nonatomic, strong) NSString *userAccessKey;

@property (nonatomic, strong) NSString *appSecretKey;
@property (nonatomic, strong) NSString *appAccessKey;
@property (nonatomic, strong) NSString *currentCategory;
@property (nonatomic) bool isMultiSelection;


/*
 "wallcovering": [Facet1,, Facet2, ...],
 "carpet": [Facet1,, Facet2, ...],
 "fabric": [Facet1,, Facet2, ...],
 "flooring": [Facet1,, Facet2, ...]
 */
@property (nonatomic, strong) NSDictionary* refineFieldList;

- (void)readAndApplyInfoFromUserPrefs;
- (void)userLogginInWithInfo: (NSDictionary*)dict;

+ (DataClient *)sharedInstance;
+ (void)eraseAllLocalPrefs;
+ (BOOL)isUserAndKeyValid;

- (NSString*)getRepresentationStringWithCategoryKey: (NSString*)categoryKey;
- (NSString*)getCategoryKeyWithRepresentationString: (NSString*)representationString;

@end

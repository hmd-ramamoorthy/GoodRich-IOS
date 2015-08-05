//
//  DataClient.m
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "DataClient.h"

@implementation DataClient

+ (DataClient *)sharedInstance
{
    static DataClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataClient alloc] init];
        // Do any other initialisation stuff:
        [sharedInstance readAndApplyInfoFromUserPrefs];
    });
    return sharedInstance;
}

- (void)readAndApplyInfoFromUserPrefs{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    User* user = [User sharedInstance];
    user.userID = [prefs stringForKey:@"id"];
    user.name = [prefs stringForKey:@"name"];
    
    self.user = user;
    self.appAccessKey = APP_ACCESS_KEY;
    self.appSecretKey = [prefs stringForKey:@"app_secret_key"];
    self.userAccessKey = [prefs stringForKey:@"user_access_key"];
    self.userSecretKey = [prefs stringForKey:@"user_secret_key"];
}

- (void)userLogginInWithInfo: (NSDictionary*)dict{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary* data = dict[@"result"];
    
    [prefs setObject: data[@"user_id"] forKey:@"id"];
    [prefs setObject: data[@"user_name"] forKey:@"name"];
    
    [prefs setObject: data[@"user_access_key"] forKey:@"user_access_key"];
    [prefs setObject: data[@"user_secret_key"] forKey:@"user_secret_key"];
    [prefs setObject: data[@"app_secret_key"] forKey:@"app_secret_key"];
    
    [prefs synchronize];
    
    [self readAndApplyInfoFromUserPrefs];
    
    // Print out info:
    NSLog(@"=========== Login successfully ================");
    NSLog(@"User access key: %@", [DataClient sharedInstance].userAccessKey);
    NSLog(@"User secret key: %@", [DataClient sharedInstance].userSecretKey);
    NSLog(@"App access key: %@", [DataClient sharedInstance].appAccessKey);
    NSLog(@"App secret key: %@", [DataClient sharedInstance].appSecretKey);
}

+ (void)eraseAllLocalPrefs{
    User* user = [User sharedInstance];
    user.userID = nil;
    user.name = nil;
    
    DataClient* dataClient = [DataClient sharedInstance];
    dataClient.appSecretKey = nil;
    dataClient.userSecretKey = nil;
    dataClient.userAccessKey = nil;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:nil forKey:@"id"];
    [prefs setObject:nil forKey:@"name"];
    
    [prefs setObject:nil forKey:@"user_secret_key"];
    [prefs setObject:nil forKey:@"user_access_key"];
    [prefs setObject:nil forKey:@"app_secret_key"];
    
    [prefs synchronize];
}

+ (BOOL)isUserAndKeyValid{
    
    NSLog(@"=========== App loaded ================");
    NSLog(@"User access key: %@", [DataClient sharedInstance].userAccessKey);
    NSLog(@"User secret key: %@", [DataClient sharedInstance].userSecretKey);
    NSLog(@"App access key: %@", [DataClient sharedInstance].appAccessKey);
    NSLog(@"App secret key: %@", [DataClient sharedInstance].appSecretKey);
    
    User* user = [User sharedInstance];
    DataClient* dataClient = [DataClient sharedInstance];
    return (user.userID != nil &&
            user.name != nil &&
            dataClient.appSecretKey != nil &&
            dataClient.userSecretKey != nil &&
            dataClient.userAccessKey != nil);
}

#pragma mark - Translation between key and string representation

- (NSString*)getRepresentationStringWithCategoryKey: (NSString*)categoryKey{
    NSDictionary* dict = @{
                           CATEGORY_KEY_WALLCOVERING : CATEGORY_TITLE_WALLCOVERING,
                           CATEGORY_KEY_FABRIC : CATEGORY_TITLE_FABRIC,
                           CATEGORY_KEY_CARPET : CATEGORY_TITLE_CARPET,
                           CATEGORY_KEY_FLOORING : CATEGORY_TITLE_FLOORING
                           };
    return [dict objectForKey: categoryKey];
}

- (NSString*)getCategoryKeyWithRepresentationString: (NSString*)representationString{
    NSDictionary* dict = @{
                           CATEGORY_TITLE_WALLCOVERING: CATEGORY_KEY_WALLCOVERING,
                           CATEGORY_TITLE_FABRIC: CATEGORY_KEY_FABRIC,
                           CATEGORY_TITLE_CARPET: CATEGORY_KEY_CARPET,
                           CATEGORY_TITLE_FLOORING: CATEGORY_KEY_FLOORING
                           };
    return [dict objectForKey: representationString];
}

#pragma mark - Others

@end

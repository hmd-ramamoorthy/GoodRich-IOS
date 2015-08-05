//
//  NSString+GeneralMethods.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (GeneralMethods)

+ (NSString*)convertDateWithDate:(int)date;
+ (NSString*)convertTimeWithTime:(int)time;
+ (NSString*)convertDateTimeWithDate:(int)date andTime:(int)time;

- (BOOL) NSStringIsValidEmail:(NSString *)checkString;
- (BOOL) isValidEmail;

// Returns true if self consists only of the digits 0 through 9
- (BOOL) isNumeric;

+ (int) currentDate;
+ (int) currentTime;

+ (NSString*) currentDateString;
+ (NSString*) currentTimeString;

// @Param: @"1991-10-19", @"yyyy-mm-dd"
// @Return: NSDate of the input string
+ (NSDate*) convertDateWithDateString: (NSString*)dateString
                      WithDateFormat: (NSString*)DateFormat;
+ (NSString*)convertDateWithNSDate: (NSDate*)date
                    WithDateFormat: (NSString*)DateFormat;

+ (NSString*) getCurrentTimeStamp;

@end

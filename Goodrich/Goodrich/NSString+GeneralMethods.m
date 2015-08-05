//
//  NSString+GeneralMethods.m
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "NSString+GeneralMethods.h"

@implementation NSString (GeneralMethods)

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL) isValidEmail{
    return [self NSStringIsValidEmail:self];
}

- (BOOL) isNumeric{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [self rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

+ (NSString*)convertDateWithDate:(int)date{
    return nil;
}

+ (NSString*)convertDateTimeWithDate:(int)date{
    int newDay = date % 100;
    date /= 100;
    
    int newMonth = date % 100;
    date /= 100;
    
    int newYear = date;
    
    // %0nd ==> 0 is used for padding. n is used for number of paddings
    NSString* newDate = [NSString stringWithFormat:@"%04d.%02d.%02d", newYear, newMonth, newDay];
    
    return newDate;
}

+ (NSString*)convertTimeWithTime:(int)time{
    //int newSecond = time % 100;
    time /= 100;
    
    int newMinute = time % 100;
    time /= 100;
    
    int newHour = time;
    
    NSString* newTime = [NSString stringWithFormat:@"%02d:%02d", newHour, newMinute];
    
    return newTime;
}


+ (NSString*)convertDateTimeWithDate:(int)date andTime:(int)time{
    NSString* newDate = [self convertDateTimeWithDate:date];
    NSString* newTime = [self convertTimeWithTime:time];
    
    return [NSString stringWithFormat:@"%@, %@", newTime, newDate];
}

+ (int) currentDate{
    return [[self currentDateString] intValue];
}

+ (int) currentTime{
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh"];
    int hour = [[dateFormatter stringFromDate: currentTime] intValue];
    
    [dateFormatter setDateFormat:@"mm"];
    int minute = [[dateFormatter stringFromDate: currentTime] intValue];
    
    return hour * 100 + minute;
}

+ (NSString*) currentDateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyymmdd"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    return yearString;
}

+ (NSString*) currentTimeString{
    return [NSString stringWithFormat:@"%d", [self currentTime]];
}

+ (NSDate*) convertDateWithDateString: (NSString*)dateString
                       WithDateFormat: (NSString*)DateFormat{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:DateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

+ (NSString*)convertDateWithNSDate: (NSDate*)date
                    WithDateFormat: (NSString*)DateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC+8"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:DateFormat];

    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString*)getCurrentTimeStamp{
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1];
}

@end


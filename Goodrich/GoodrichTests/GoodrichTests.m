//
//  GoodrichTests.m
//  GoodrichTests
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HTTPClient.h"
#import "AFHTTPRequestOperationManager.h"

@interface GoodrichTests : XCTestCase

@end

@implementation GoodrichTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testgetProductiDetails {
    __block int flag = 1;
    
    NSLog(@"get ids");
    [[HTTPClient sharedInstance] getPatternStyleListSuccess:^(NSInteger statusCode, id responseObject) {
        NSLog(@"%@", responseObject);
        flag = 0;
    } failure:^(NSInteger statusCode, NSArray *errors) {
        NSLog(@"%@", errors);
        flag = 0;
    }];
    
    //NSLog(@"get ids");
    //[[HTTPClient sharedInstance] getProductDetailsWithIds:@[@"OM26",@"OM27"] success:^(NSInteger statusCode, NSDictionary *data) {
    //    NSLog(@"%@", data);
    //    flag = 0;
    //} failure:^(NSInteger statusCode, NSDictionary *data) {
    //    NSLog(@"%@", data);
    //    flag = 0;
    //}];
    
    //while (flag);
    
    
    NSLog(@"finish get ids");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

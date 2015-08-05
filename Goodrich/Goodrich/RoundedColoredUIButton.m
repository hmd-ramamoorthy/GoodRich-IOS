//
//  RoundedColoredUIButton.m
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "RoundedColoredUIButton.h"

@implementation RoundedColoredUIButton

- (void)setupView{
    [super setupView];
    self.backgroundColor = [UIColor colorFromRGB:0x8a12bc];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end

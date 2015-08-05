//
//  PatternStyleKeyButton.m
//  Goodrich
//
//  Created by Zhixing on 2/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "PatternStyleKeyButton.h"

@implementation PatternStyleKeyButton

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])){
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

# pragma mark - main

- (void)setupView
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor colorFromRGB:0xa95ac8] forState:UIControlStateNormal];
}

@end

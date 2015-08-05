//
//  PatternStyleButton.m
//  Goodrich
//
//  Created by Zhixing on 2/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "PatternStyleButton.h"

@implementation PatternStyleButton

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
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
}

@end

//
//  RoundedUIButton.m
//  Goodrich
//
//  Created by Zhixing on 22/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "RoundedUIButton.h"

@implementation RoundedUIButton

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
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    
    /*
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowRadius = 0;
    [self clearHighlightView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.layer.bounds;
    gradient.cornerRadius = 10;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
                       (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor,
                       (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor,
                       (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor,
                       nil];
    float height = gradient.frame.size.height;
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.2*30/height],
                          [NSNumber numberWithFloat:1.0-0.1*30/height],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
    [self.layer addSublayer:gradient];
     */
}

- (void)highlightView
{
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.25;
}

- (void)clearHighlightView {
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [self highlightView];
    } else {
        [self clearHighlightView];
    }
    [super setHighlighted:highlighted];
}

@end

//
//  CropView.m
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "CropView.h"

#define SCREEN_WIDTH 320

@implementation CropView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    // Clockwise.
    // Tip for debug: draw this on white paper.
    [self drawCornerFrom:CGPointMake(0, 0)
               toPoint: CGPointMake(CORNER_RED_LINE_LENGTH, 0)];
    
    [self drawCornerFrom:CGPointMake(selfWidth, 0)
               toPoint: CGPointMake(selfWidth, CORNER_RED_LINE_LENGTH)];
    
    [self drawCornerFrom:CGPointMake(selfWidth, selfHeight)
               toPoint: CGPointMake(selfWidth - CORNER_RED_LINE_LENGTH, selfHeight)];
    
    [self drawCornerFrom:CGPointMake(0, selfHeight)
               toPoint: CGPointMake(0, selfHeight - CORNER_RED_LINE_LENGTH)];

    // Clockwise:
    [self drawCornerFrom:CGPointMake(0, CORNER_RED_LINE_LENGTH)
               toPoint: CGPointMake(0, CORNER_RED_LINE_WIDTH / 2)];
    
    [self drawCornerFrom:CGPointMake(selfWidth - CORNER_RED_LINE_LENGTH, 0)
               toPoint: CGPointMake(selfWidth - CORNER_RED_LINE_WIDTH / 2, 0)];
    
    [self drawCornerFrom:CGPointMake(selfWidth, selfHeight - CORNER_RED_LINE_LENGTH)
               toPoint: CGPointMake(selfWidth, selfHeight - CORNER_RED_LINE_WIDTH / 2)];
    
    [self drawCornerFrom:CGPointMake(CORNER_RED_LINE_LENGTH, selfHeight)
               toPoint: CGPointMake(CORNER_RED_LINE_WIDTH / 2, selfHeight)];
    
    // Draw white lines:
    CGFloat borderShift = 0.0;
    [self drawBorderFrom:CGPointMake(CORNER_RED_LINE_LENGTH, borderShift)
                 toPoint:CGPointMake(selfWidth - CORNER_RED_LINE_LENGTH, borderShift)];
    
    [self drawBorderFrom:CGPointMake(selfWidth - borderShift, CORNER_RED_LINE_LENGTH)
                 toPoint:CGPointMake(selfWidth - borderShift, selfHeight - CORNER_RED_LINE_LENGTH)];
    
    [self drawBorderFrom:CGPointMake(selfWidth - CORNER_RED_LINE_LENGTH, selfHeight - borderShift)
                 toPoint:CGPointMake(CORNER_RED_LINE_LENGTH, selfHeight - borderShift)];
    
    [self drawBorderFrom:CGPointMake(borderShift, selfHeight - CORNER_RED_LINE_LENGTH)
                 toPoint:CGPointMake(borderShift, CORNER_RED_LINE_LENGTH)];
}

- (void) drawCornerFrom: (CGPoint)startPoint toPoint: (CGPoint)endPoint{
    [self drawLineFrom:startPoint toPoint:endPoint withWidth:CORNER_RED_LINE_WIDTH andColor:[UIColor redColor]];
}

- (void) drawBorderFrom: (CGPoint)startPoint toPoint: (CGPoint)endPoint{
    [self drawLineFrom:startPoint toPoint:endPoint withWidth:BORDER_WIDTH andColor:[UIColor whiteColor]];
}

- (void) drawLineFrom: (CGPoint)startPoint toPoint: (CGPoint)endPoint withWidth: (CGFloat) width andColor: (UIColor*) color{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGContextSetLineWidth(context, width);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y); //start at this point
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y); //draw to this point
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

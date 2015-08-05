//
//  UIImageView+GetImageFrame.m
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "UIImageView+GetImageFrame.h"

@implementation UIImageView (GetImageFrame)

- (CGRect)innerImageFrameInSuperview{
    CGSize imageSize = self.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(self.bounds) / imageSize.width,
                               CGRectGetHeight(self.bounds) / imageSize.height);
    
    CGSize scaledImageSize = CGSizeMake(imageSize.width * imageScale, imageSize.height * imageScale);
    CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(self.bounds) - scaledImageSize.width) + self.frame.origin.x),
                                   roundf(0.5f*(CGRectGetHeight(self.bounds)-scaledImageSize.height) + self.frame.origin.y),
                                   roundf(scaledImageSize.width),
                                   roundf(scaledImageSize.height));
    return imageFrame;
}

@end

//
//  ImageSearchScanView.h
//  Goodrich
//
//  Created by Zhixing on 26/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageSearchScanView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *scanIcon;

+ (instancetype)imageSearchScanView;

- (void)beginAnimate;

@end

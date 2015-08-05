//
//  ImageSearchInfoView.m
//  Goodrich
//
//  Created by Zhixing on 26/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "ImageSearchInfoView.h"

@implementation ImageSearchInfoView

+ (instancetype)imageSearchInfoViewWithImageName: (NSString*) imageName{
    ImageSearchInfoView *imageSearchInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ImageSearchInfoView" owner:nil options:nil] objectAtIndex:0];
    
    // make sure customView is not nil or the wrong class!
    if ([imageSearchInfoView isKindOfClass:[ImageSearchInfoView class]]){
        imageSearchInfoView.imageView.image = [UIImage imageNamed: imageName];
        return imageSearchInfoView;
    } else{
        return nil;
    }
}

- (void)appearGradually{
    self.alpha = 0.1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (IBAction)viewClicked:(UIButton *)sender {
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

//
//  ImageSearchInfoView.h
//  Goodrich
//
//  Created by Zhixing on 26/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageSearchInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+ (instancetype)imageSearchInfoViewWithImageName: (NSString*) imageName;

- (void)appearGradually;

- (IBAction)viewClicked:(UIButton *)sender;

@end

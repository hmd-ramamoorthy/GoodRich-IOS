//
//  ImageSearchRefineViewController.h
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateViewController.h"
#import "CropView.h"
#import "UIImageView+GetImageFrame.h"
#import "ImageSearchInfoView.h"
#import "UIViewController+ScreenSize.h"
#import "ImageSearchViewController.h"
#import "Product.h"
#import "UIImage+Extensions.h"

@interface ImageSearchRefineViewController : TemplateViewController

@property (strong, nonatomic) UIImage* imageToCrop;
@property (nonatomic) CGRect imageFrameToCrop;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *searchOrCancelButton;
@property (weak, nonatomic) IBOutlet CropView *cropView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIImageView *takePhotoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *rotateIcon;
@property (weak, nonatomic) IBOutlet UIImageView *infoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *closeButton;

/*
 *  imageView is on top of imageViewWithMask. They have the same image.
 *  imageView.alpha + imageViewWithMask.alpha = 1
 *  The mask is applied to the imageViewWithMask, causing it to darken completely except for cropped area.
 *  imageView is there to add a transparent effect of the completely darkened area.
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView* imageViewWithMask;

- (IBAction)infoButtonClicked:(id)sender;
- (IBAction)takePhotoButtonClicked:(id)sender;
- (IBAction)searchButtonClicked:(id)sender;
- (IBAction)rotateButtonClicked:(id)sender;

@end

//
//  ImageSearchViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "UIViewController+ScreenSize.h"
#import "ImageSearchInfoView.h"
#import "SearchClient.h"
#import "UIView+ActivityIndicator.h"
#import "Product.h"
#import "SearchResultViewController.h"
#import "UIImageView+GetImageFrame.h"

@interface ImageSearchViewController : TemplateViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIView *flashModeButton;
@property (weak, nonatomic) IBOutlet UIImageView *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *galleryButton;
@property (weak, nonatomic) IBOutlet UIImageView *infoButtonIcon;

// Flash control. Feature has changed. We're not using this. It's hidden by default.
@property (weak, nonatomic) IBOutlet UIView     *flashModeButtonsHolderView;
@property (weak, nonatomic) IBOutlet UIButton   *flashModeAutoButton;
@property (weak, nonatomic) IBOutlet UIButton   *flashModeOnButton;
@property (weak, nonatomic) IBOutlet UIButton   *flashModeOffButton;
@property (weak, nonatomic) IBOutlet UILabel    *flashModeDisplayLabel;
@property (weak, nonatomic) IBOutlet UIButton   *flashButton;
@property (weak, nonatomic) IBOutlet UIImageView *flashImageIcon;

- (IBAction)takePhotoButtonClicked:  (UIButton *)sender;
- (IBAction)selectPhotoButtonClicked:(UIButton *)sender;
- (IBAction)flashButtonClicked:(UIButton *)sender;
- (IBAction)infoButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(UIButton *)sender;

// Flash:
- (IBAction)flashModeAutoButtonClicked:(id)sender;
- (IBAction)flashModeOnButtonClicked:(id)sender;
- (IBAction)flashModeOffButtonClicked:(id)sender;

@end

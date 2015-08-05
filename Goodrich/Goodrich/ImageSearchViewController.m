//
//  ImageSearchViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "ImageSearchViewController.h"

@interface ImageSearchViewController ()

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, strong) UIView *focusTapView;

// For cancelation in the process of searching. If canceled, this will be set to YES, and the result will not be displayed.
@property(nonatomic) BOOL isSearchCanceled;

// To disable the imagePickerButton and the cameraButton from continuously clicking
// Set to YES when: the control button is pressed and initialize camera
// Set to NO when user canceled image picking or search is canceled or completed
@property(nonatomic) BOOL shouldDisableControl;

// By default, is YES. Set to NO when input device is not found.
@property(nonatomic) BOOL isCameraAvailable;

@end

@implementation ImageSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // By default, we assume camera is available:
    self.isCameraAvailable = YES;
    // Hide the holder view. We're not using this feature:
    self.flashModeButtonsHolderView.hidden = YES;
    self.flashModeDisplayLabel.hidden = YES;
    self.shouldDisableControl = NO;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    self.focusTapView = [[UIView alloc] initWithFrame:self.imageView.frame];
    [self.view addSubview:self.focusTapView];
    [self.focusTapView addGestureRecognizer:gesture];

    //NSLog(@"in did load%lf", self.imageView.frame.origin.y);
    //NSLog(@"%lf", self.imageView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];

    NSLog(@"in will appear hahaga");
    NSLog(@"%lf", self.imageView.frame.size.height);
    if (self.shouldDisableControl == NO){
        [self cancelButtonClicked:nil];
    }
}

//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
//    
//    NSLog(@"in willlayout %lf", self.imageView.frame.origin.y);
//    NSLog(@"%lf", self.imageView.frame.size.height);
//    if (self.shouldDisableControl == NO){
//        [self cancelButtonClicked:nil];
//    }
//}
//
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
//    
//    NSLog(@"in willlayout %lf", self.imageView.frame.origin.y);
//    NSLog(@"%lf", self.imageView.frame.size.height);
//    if (self.shouldDisableControl == NO){
//        [self cancelButtonClicked:nil];
//    }
//}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self turnOffTorchLight];
    [self stopCameraAndRemovePreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Gesture

- (void)tapToFocus:(UITapGestureRecognizer *)sender {
    NSLog(@"tap");
    CGPoint touchPoint = [sender locationInView:self.imageView];
    CGPoint convertedPoint = [self.previewLayer captureDevicePointOfInterestForPoint:touchPoint];
    AVCaptureDevice *currentDevice = self.device;

    if([currentDevice isFocusPointOfInterestSupported] && [currentDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        NSError *error = nil;
        [currentDevice lockForConfiguration:&error];
        if(!error){
            [currentDevice setFocusPointOfInterest:convertedPoint];
            [currentDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            [currentDevice unlockForConfiguration];
        }
    }
}

#pragma mark - Button clicked

// Override
- (void)backButtonClicked:(id)sender{
    [self stopCameraAndRemovePreview];
    [super backButtonClicked:sender];
}

- (IBAction)takePhotoButtonClicked:(UIButton *)sender {
    
    if (!self.isCameraAvailable) {
        [self showCameraBlockedAlert];
        return;
    }
    
    if (self.shouldDisableControl) {
        return;
    } else{
        self.shouldDisableControl = YES;
    }
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    // Show the balck view to imitate shutter black-out:
    self.imageView.image = nil;
    [self shouldShowImageViewAndCancelButton:YES];
    
    // Block view to block user interactions on this screen:
    UIView* blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getScreenWidth], [self getScreenHeight])];
    [self.view addSubview:blockView];
    [self.view bringSubviewToFront:blockView];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         // Remove the black view:
         [blockView removeFromSuperview];
         
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         image = [image fixOrientation];
         
         self.imageView.image = image;
         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
         
         [self stopCameraAndRemovePreview];
         
         [self beginImageSearch:image andRecordHistory:YES];
         
         self.flashImageIcon.image = [UIImage imageNamed:@"camera_icon_light.png"];

    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (IBAction)selectPhotoButtonClicked:(UIButton *)sender {
    
    if (self.shouldDisableControl) {
        return;
    }else{
        self.shouldDisableControl = YES;
    }
    
    [self.view makeSpinnerActivity];
    [self stopCameraAndRemovePreview];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) toggleFlashModeButtonsHolderView{
    
    CGFloat duration = 0.3;
    
    if ([self.flashModeButtonsHolderView isHidden]) {
        self.flashModeButtonsHolderView.hidden = NO;
        self.flashModeButtonsHolderView.alpha = 0.1;
        [UIView animateWithDuration:duration animations:^{
            self.flashModeButtonsHolderView.alpha = 1.0;
        }];
    } else{
        self.flashModeButtonsHolderView.alpha = 1.0;
        [UIView animateWithDuration:duration animations:^{
            self.flashModeButtonsHolderView.alpha = 0.1;
        } completion:^(BOOL finished) {
            self.flashModeButtonsHolderView.hidden = YES;
        }];
    }
    [Flurry logEvent:@"flash button clicked"];
}

// Called when initializing camera:

- (void)renderFlashModeButton{
    
    UIButton* defaultFlashModeButton = nil;
    
    // Pick the default flash mode depending on availability:
    if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
        defaultFlashModeButton = self.flashModeAutoButton;
        [self changeFlashModeTo:AVCaptureFlashModeAuto];
        [self changeFlashModeTo:AVCaptureFlashModeAuto];
    } else if ([self.device isFlashModeSupported:AVCaptureFlashModeOff]) {
        defaultFlashModeButton = self.flashModeOffButton;
        [self changeFlashModeTo:AVCaptureFlashModeOff];
    } else if ([self.device isFlashModeSupported:AVCaptureFlashModeOn]){
        defaultFlashModeButton = self.flashModeOnButton;
        [self changeFlashModeTo:AVCaptureFlashModeOn];
    }
    
    // If not found an available mode:
    if (defaultFlashModeButton == nil) {
        self.flashButton.hidden = YES;
        self.flashModeDisplayLabel.hidden = YES;
        self.flashImageIcon.hidden = YES;
    }
    
    self.flashModeAutoButton.hidden = ![self.device isFlashModeSupported:AVCaptureFlashModeAuto];
    self.flashModeOnButton.hidden = ![self.device isFlashModeSupported:AVCaptureFlashModeOn];
    self.flashModeOffButton.hidden = ![self.device isFlashModeSupported:AVCaptureFlashModeOff];
    self.flashModeButtonsHolderView.hidden = YES;
}

- (IBAction)infoButtonClicked:(id)sender {
    ImageSearchInfoView* imageSearchInfoView = [ImageSearchInfoView imageSearchInfoViewWithImageName:@"camera_info_pic_first.png"];
    [self.view addSubview: imageSearchInfoView];
    imageSearchInfoView.frame = CGRectMake(0, 0, [self getScreenWidth], [self getScreenHeight]);
    [imageSearchInfoView appearGradually];
    [Flurry logEvent:@"help button clicked"];
}

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
    self.shouldDisableControl = NO;
    
    [self stopCameraAndRemovePreview];
    [self shouldShowImageViewAndCancelButton:NO];
    [self initializeCamera];
    self.flashButton.hidden = NO;
    self.closeButton.hidden = NO;
    self.flashModeButton.hidden = NO;
    self.galleryButton.hidden = NO;
    self.infoButton.hidden = NO;
    self.flashImageIcon.hidden = NO;
    self.infoButtonIcon.hidden = NO;
    [self.view removeScannerView];
    self.isSearchCanceled = YES;
}

#pragma mark - Flash Related

- (IBAction)flashButtonClicked:(UIButton *)sender {
    
    if (!self.isCameraAvailable) {
        [self showCameraBlockedAlert];
    } else if (!self.shouldDisableControl){
        // Not using this feature: [self toggleFlashModeButtonsHolderView];
        // We're using this: turn on torch:
        if ([self.device isTorchActive]) {
            [self turnOffTorchLight];
        } else{
            [self turnOnTorchLight];
        }
    }
}

- (void)turnOnTorchLight{
    if (self.device == nil) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    if([self.device isTorchAvailable] && [self.device isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [self.device lockForConfiguration:nil];
        if(success){
            self.flashImageIcon.image = [UIImage imageNamed:@"camera_icon_light_on.png"];
            [self.device setTorchMode:AVCaptureTorchModeOn];
            [self.device unlockForConfiguration];
        }
    } else {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                              message:@"Your device does not support torch light."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
}

- (void)turnOffTorchLight{
    if (self.device == nil) {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    if([self.device isTorchAvailable] && [self.device isTorchModeSupported:AVCaptureTorchModeOn])
    {
        BOOL success = [self.device lockForConfiguration:nil];
        if(success){
            self.flashImageIcon.image = [UIImage imageNamed:@"camera_icon_light.png"];
            [self.device setTorchMode:AVCaptureTorchModeOff];
            [self.device unlockForConfiguration];
        }
    }
}

- (IBAction)flashModeAutoButtonClicked:(id)sender {
    [self toggleFlashModeButtonsHolderView];
    [self changeFlashModeTo:AVCaptureFlashModeAuto];
}

- (IBAction)flashModeOnButtonClicked:(id)sender {
    [self toggleFlashModeButtonsHolderView];
    [self changeFlashModeTo:AVCaptureFlashModeOn];
}

- (IBAction)flashModeOffButtonClicked:(id)sender {
    [self toggleFlashModeButtonsHolderView];
    [self changeFlashModeTo:AVCaptureFlashModeOff];
}

- (void)changeFlashModeTo: (AVCaptureFlashMode)flashMode{
    self.device.flashMode = flashMode;
    switch (flashMode) {
        case AVCaptureFlashModeAuto:{
            
            [self highlightButton:self.flashModeAutoButton andDimButton:self.flashModeOnButton andButton:self.flashModeOffButton];
            self.flashModeDisplayLabel.text = @"Auto";
            
            break;
        }
        case AVCaptureFlashModeOn:{
            
            [self highlightButton:self.flashModeOnButton andDimButton:self.flashModeAutoButton andButton:self.flashModeOffButton];
            self.flashModeDisplayLabel.text = @"On";
            
            break;
        }
        case AVCaptureFlashModeOff:{
            
            [self highlightButton:self.flashModeOffButton andDimButton:self.flashModeOnButton andButton:self.flashModeAutoButton];
            self.flashModeDisplayLabel.text = @"Off";
            
            break;
        }
        default:
            break;
    }
}

- (void)highlightButton: (UIButton*)buttonA andDimButton: (UIButton*)buttonB andButton: (UIButton*)buttonC{
    [buttonA setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [buttonB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.view hideSpinnerActivity];
    
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chosenImage = [chosenImage fixOrientation];
    self.imageView.image = chosenImage;
    
    [self shouldShowImageViewAndCancelButton:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self beginImageSearch:chosenImage andRecordHistory:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.shouldDisableControl = NO;
    [self.view hideSpinnerActivity];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self cancelButtonClicked:nil];
    
}

#pragma mark - Helper 

- (BOOL) isCameraRunningAndPreviewShowing{
    return self.session != nil && [self.session isRunning];
}

- (void)initializeCamera{
    
    self.shouldDisableControl = NO;
    
    if ([self isCameraRunningAndPreviewShowing]) {
        [self stopCameraAndRemovePreview];
    }
    
    [self shouldShowImageViewAndCancelButton:NO];
    
    // Initialize session:
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    // Initialize device:
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self.device lockForConfiguration:nil];

    self.device.flashMode = AVCaptureTorchModeOff;
    //self.device.focusMode
    
    if ([self.device isFlashModeSupported:AVCaptureFlashModeOff]) {
        self.device.flashMode = AVCaptureTorchModeOff;
    }

    NSError *error0 = nil;
    if ([self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
        [self.device lockForConfiguration:&error0];
        [self.device setFocusPointOfInterest:autofocusPoint];
        [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    // This happens when the camera is initialized at the first time.
    // self.isCameraAvailable is YES at the first time.
    if (!input && self.isCameraAvailable) {
        [self showCameraBlockedAlert];
        self.isCameraAvailable = NO;
        self.flashModeDisplayLabel.text = @"Off";
        self.flashModeButtonsHolderView.hidden = YES;
        return;
    }
    
    // This happens later on. isCameraAvailable is set to NO already.
    if (!input && !self.isCameraAvailable){
        return;
    }
    
    [self.session addInput:input];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    [self.previewLayer setFrame:self.imageView.frame];
    [rootLayer insertSublayer:self.previewLayer atIndex:0];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.session addOutput:self.stillImageOutput];
    
    // Setup the flash:
    //[self renderFlashModeButton];
    
    [self.session startRunning];
}

- (void)showCameraBlockedAlert{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                          message:@"Your device has not been enabled access to camera."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
    [myAlertView show];
}

- (void)stopCameraAndRemovePreview{
    [self.session stopRunning];
    self.session = nil;
    
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
    self.device = nil;
    
    self.stillImageOutput = nil;
}

- (void)shouldShowImageViewAndCancelButton: (BOOL) show{
    self.imageView.hidden = !show;
    self.cancelButton.hidden = !show;
    
    if (show) {
        [self.view bringSubviewToFront:self.imageView];
    }
}

- (void)beginImageSearch: (UIImage*)image andRecordHistory: (BOOL) shouldRecord{
    [self.view addScannerViewAtFrame:[self.imageView innerImageFrameInSuperview]];
    
    self.isSearchCanceled = NO;
    
    self.flashButton.hidden = YES;
    self.closeButton.hidden = YES;
    self.flashModeButton.hidden = YES;
    self.galleryButton.hidden = YES;
    self.infoButton.hidden = YES;
    self.flashImageIcon.hidden = YES;
    self.infoButtonIcon.hidden = YES;
    
    NSArray* fieldList = [NSArray arrayWithObjects: @"im_url", @"Collection", @"Category", @"PatternNumber", nil];
    [[SearchClient sharedInstance] uploadSearch:image
                                  andFieldQuery:nil
                                   andFieldList:fieldList
                                       andFacet:nil
                                       andLimit: IMAGE_COUNT_LIMIT
                                    andPriority: nil
                                        andPage: 1
                                    andScoreMin: SCORE_MIN_DEFAULT_UPLOAD
                                    andScoreMax: 1
                                andCroppedFrame: FULL_FRAME_OF_IMAGE
                                        success:^(NSDictionary *responseObject) {
                                            if (self.isSearchCanceled) {
                                                NSLog(@"Search result returned. But user has canceled search in the process");
                                                // No need to do this:
                                                // [self.view removeScannerView]; // done in cancelButtonClicked:
                                                // [self cancelButtonClicked:nil]; // done when the user clicked "Cancel" button.
                                                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                               @"cancel", @"method",
                                                                               nil];
                                                
                                                [Flurry logEvent:@"upload search" withParameters:params];
                                            } else{
                                            
                                                NSLog(@"Found: %@", responseObject);
                                                [self cancelButtonClicked:nil];
                                                self.isSearchCanceled = YES;
                                                self.shouldDisableControl = NO;
                                                
                                                NSMutableArray* products = [[NSMutableArray alloc] init];
                                                for (NSDictionary* dict in responseObject[@"result"]) {
                                                   [products addObject: [Product productFromDictionary:dict andKeyForSpecs:@"value_map"]];
                                                }
                                                
                                                [self proceedToDisplaySearchResultWithProducts:products
                                                                                      andImage:image];
                                                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                        @"camera", @"method",
                                                                        nil];
                                                
                                                [Flurry logEvent:@"upload search" withParameters:params];
                                            }
    } failure:^(NSArray *errors) {
        if (!self.isSearchCanceled) {
            [self handleFailedRequestWithErrors:errors withType:REQUEST_TYPE_SINGLE_REQUEST];
            [self.view removeScannerView];
            [self cancelButtonClicked:nil];
        }
    }];
    
    if (shouldRecord) {
        [[HTTPClient sharedInstance] updateSearchHistoryWithMethod:@"upload_search" andImage:image andColor:nil andText:nil andLimit:100 andPage:1 andFieldList:fieldList success:^(NSInteger statusCode, id responseObject) {
            NSLog(@"Successfully updated search history");
        } failure:^(NSInteger statusCode, NSArray *errors) {
            NSLog(@"Oops.. Updated search history failed");
        }];
    }
}

- (void)proceedToDisplaySearchResultWithProducts: (NSArray*) products
                                        andImage: (UIImage*) image{
    
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.searchResultViewControllerDelegate == nil){
        
        SearchResultViewController* vc = (SearchResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
        
        vc.searchType = SEARCH_TYPE_IMAGE;
        vc.products = [NSArray arrayWithArray: products];
        vc.imageToSearch = image;
        vc.imageFrameToCrop = FULL_FRAME_OF_IMAGE;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        appDelegate.searchResultViewControllerDelegate = vc;
        
    } else{
        
        [self stopCameraAndRemovePreview];
        [appDelegate.searchResultViewControllerDelegate searchResultReturnedWithSearchType:SEARCH_TYPE_IMAGE andSearchResult:products andImageToSearch:image andImageFrameToCrop:FULL_FRAME_OF_IMAGE];
    }
}

@end
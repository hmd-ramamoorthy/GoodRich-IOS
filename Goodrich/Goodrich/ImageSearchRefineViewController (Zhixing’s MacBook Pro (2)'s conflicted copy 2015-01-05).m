//
//  ImageSearchRefineViewController.m
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define BORDER_BUTTON_LENGTH 32
#import "ImageSearchRefineViewController.h"

@interface ImageSearchRefineViewController ()

@property (strong, nonatomic) UIPanGestureRecognizer* panGestureRecognizer;
@property (nonatomic) CGPoint originalCenter;

@end

@implementation ImageSearchRefineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpGestureRecognizers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Render views

- (void)setUpGestureRecognizers{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(corpViewPanned:)];
    [self.cropView addGestureRecognizer: self.panGestureRecognizer];
}

#pragma mark - Gesture Recognizer Related


- (void)corpViewPanned:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.originalCenter = self.cropView.center;
    } else{
        
        CGPoint touchPoint = [panGestureRecognizer locationInView:self.cropView];
        if ([self isTouchAtTopLeftCorner:touchPoint]) {
            NSLog(@"Touched at top left corner");
            
        } else if ([ self isTouchAtTopRightCorner:touchPoint]){
            NSLog(@"Touched at top right corner");
            
        } else if ([self isTouchAtBottomRightCorner: touchPoint]){
            NSLog(@"Touched at bottom right corner");
            
        } else if ([self isTouchAtBottomLeftCorner: touchPoint]){
            NSLog(@"Touched at bottom left corner");
            
        } else{
            /*
            CGPoint translated = [panGestureRecognizer translationInView:self.view];
            CGPoint newCenter = CGPointMake(self.originalCenter.x + translated.x,
                                            self.originalCenter.y + translated.y);
            self.cropView.center = [self normalizeCenter:newCenter];
             */
            CGPoint translation = [panGestureRecognizer translationInView:self.view];
            
            CGPoint newCenter = CGPointMake(self.cropView.center.x + translation.x,
                                            self.cropView.center.y + translation.y);
            
            self.cropView.center = [self normalizeCenter:newCenter];
            [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        }
    }
}

- (CGPoint)normalizeCenter: (CGPoint)center{
    CGFloat width = self.cropView.frame.size.width;
    CGFloat height = self.cropView.frame.size.height;
    
    CGRect imageFrame = [self.imageView calculateInnerImageFrame];
    CGFloat x1_imageView = imageFrame.origin.x;
    CGFloat y1_imageView = imageFrame.origin.y;
    CGFloat x2_imageView = imageFrame.origin.x + imageFrame.size.width;
    CGFloat y2_imageView = imageFrame.origin.y + imageFrame.size.height;

    CGFloat newX = center.x - width / 2 < x1_imageView ? x1_imageView + width / 2 : center.x;
    newX = newX + width / 2 > x2_imageView ? x2_imageView - width / 2 : newX;
    CGFloat newY = center.y - height / 2 < y1_imageView ? y1_imageView + height / 2 : center.y;
    newY = newY + height / 2 > y2_imageView ? y2_imageView - height / 2 : newY;
    
    return CGPointMake(newX, newY);
}

- (BOOL)isTouchAtTopLeftCorner: (CGPoint) point{
    return ((point.x < BORDER_BUTTON_LENGTH) && (point.y < BORDER_BUTTON_LENGTH));
}

- (BOOL)isTouchAtTopRightCorner: (CGPoint) point{
    CGFloat cropFrameWidth = self.cropView.frame.size.width;
    return ((point.x > cropFrameWidth - BORDER_BUTTON_LENGTH) && (point.y < BORDER_BUTTON_LENGTH));
}

- (BOOL)isTouchAtBottomRightCorner: (CGPoint) point{
    CGFloat cropFrameWidth = self.cropView.frame.size.width;
    CGFloat cropFrameHeight = self.cropView.frame.size.height;
    return ((point.x > cropFrameWidth - BORDER_BUTTON_LENGTH) && (point.y > cropFrameHeight - BORDER_BUTTON_LENGTH));
}

- (BOOL)isTouchAtBottomLeftCorner: (CGPoint) point{
    CGFloat cropFrameHeight = self.cropView.frame.size.height;
    return ((point.x < BORDER_BUTTON_LENGTH) && (point.y > cropFrameHeight - BORDER_BUTTON_LENGTH));
}

#pragma mark - Button Clicked


- (IBAction)infoButtonClicked:(id)sender {
    
}

- (IBAction)takePhotoButtonClicked:(id)sender {
    
}

- (IBAction)searchButtonClicked:(id)sender {
    
}

@end

//
//  TemplateViewController.m
//  Goodrich
//
//  Created by Zhixing Yang on 15/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "EmailSharingService.h"
#import "Product.h"
#import "UIView+ActivityIndicator.h"
#import "WhatsAppService.h"

static NSInteger const IconWidth = 22;
static NSInteger const IconHeight = 22;

@interface TemplateViewController()<UIActionSheetDelegate> {
    NSArray *rightBarButtons;
    NSArray *sendingProducts;
}

- (UIBarButtonItem *)setupUIBarButtonWith:(NSString *)imagePath Selector:(SEL)selector;

@end

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *btnArray = [NSMutableArray array];
    
    if ([self isHomeButtonDisplayed]) {
        [btnArray addObject:[self setupUIBarButtonWith:@"home.png" Selector:@selector(homeButtonClicked:)]];
    }

    if ([self isShareButtonDisplayed]) {
        [btnArray addObject:[self setupUIBarButtonWith:@"share.png" Selector:@selector(share:)]];
    }
    
    if (![self isSearchButtonDisplayed]) {
        self.navigationItem.rightBarButtonItems = btnArray;
    }
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                        @"Email",
                        @"WhatsApp",
                        nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            NSLog(@"Email");
            [EmailSharingService sendEmailWithProducts:sendingProducts completed:^(UIViewController *vc) {
                [self.navigationController presentViewController:vc animated:YES completion:nil];
                
                // update share history
                NSMutableArray *idsToShare = [NSMutableArray array];
                for (Product *p in sendingProducts) {
                    [idsToShare addObject:p.productName];
                }

                [[HTTPClient sharedInstance] updateShareHistory:idsToShare success:^(NSInteger statusCode, id responseObject) {
                    NSLog(@"Successfully updated share history");
                    [self.view hideSpinnerActivity];
                } failure:^(NSInteger statusCode, NSArray *errors) {
                    NSLog(@"Oops.. Updated share history failed");
                    [self.view hideSpinnerActivity];
                }];
                
                [Flurry logEvent:@"share clicked"];

            }];
            break;
        }
        case 1: {
            NSLog(@"WhatsApp");
            [WhatsAppService sendWhatsAppMessageWithProducts:sendingProducts];
            break;
        }
        default:
            break;
    }
}

- (void)prepareSendingProducts:(NSArray *)products {
    sendingProducts = products;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self registerCurrentViewControllerNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private instance method

- (UIBarButtonItem *)setupUIBarButtonWith:(NSString *)imagePath Selector:(SEL)selector {
    UIButton* btn = [UIButton buttonWithType: UIButtonTypeInfoLight];
    [btn setImage:[[UIImage imageNamed:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = btn.frame;
    frame.size.height = IconHeight;
    frame.size.width = IconWidth;
    btn.frame = frame;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barButtonItem;
}

#pragma template method to initialize right bar buttons

- (void)setRightBarButtonItemsCollection:(NSArray *)rightBarButtonItemsCollection {
    rightBarButtons = [rightBarButtonItemsCollection sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:YES]]];
}

- (NSArray*)rightBarButtonItemsCollection {
    return rightBarButtons;
}

- (BOOL)isShareButtonDisplayed {
    return NO;
}

- (BOOL)isHomeButtonDisplayed {
    return NO;
}

- (BOOL)isSearchButtonDisplayed {
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)homeButtonClicked:(id)sender {
    NSLog(@"home clicked in template");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)share:(id)sender {
    NSLog(@"share button clicked");
}

@end

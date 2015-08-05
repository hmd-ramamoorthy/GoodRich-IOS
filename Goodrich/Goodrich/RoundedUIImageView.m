//
//  RoundedUIImageView.m
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "RoundedUIImageView.h"

@implementation RoundedUIImageView

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])){
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

# pragma mark - main

- (void)setupView
{
    self.layer.cornerRadius = 4.0;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    
    /*
     self.layer.borderWidth = 0.0;
     self.layer.borderColor = [UIColor clearColor].CGColor;
     self.layer.shadowColor = [UIColor clearColor].CGColor;
     self.layer.shadowRadius = 0;
     [self clearHighlightView];
     
     CAGradientLayer *gradient = [CAGradientLayer layer];
     gradient.frame = self.layer.bounds;
     gradient.cornerRadius = 10;
     gradient.colors = [NSArray arrayWithObjects:
     (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
     (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor,
     (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor,
     (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor,
     nil];
     float height = gradient.frame.size.height;
     gradient.locations = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:0.0f],
     [NSNumber numberWithFloat:0.2*30/height],
     [NSNumber numberWithFloat:1.0-0.1*30/height],
     [NSNumber numberWithFloat:1.0f],
     nil];
     [self.layer addSublayer:gradient];
     */
}

- (void)highlightView
{
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.25;
}

- (void)clearHighlightView {
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [self highlightView];
    } else {
        [self clearHighlightView];
    }
    [super setHighlighted:highlighted];
}

- (void)goodRichSetImageWithURL: (NSString*) imageURL toSize: (IMAGE_SIZE) imageSize{
    NSString* url = [self convertImageURLString: imageURL toSizeOf:imageSize];

    UIImage* defaultImage = [UIImage imageNamed:@"browsing_default_img.png"];
    UIImage* failedImage = [UIImage imageNamed:@"browsing_fail_img.png"];

    /*
     self.image = defaultImage;
    [self hnk_setImageFromURL:[NSURL URLWithString: url] placeholder:[UIImage imageNamed:@"browsing_default_img.png"] success:^(UIImage *image) {
        self.image = image;
    } failure:^(NSError *error) {
        self.image = failedImage;
    }];
     */
    
    if (url == nil) {
        self.image = failedImage;
        return;
    } else{
        [self sd_setImageWithURL:[NSURL URLWithString: url]
                placeholderImage:defaultImage
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           if (error != nil) {
                               self.image = failedImage;
                           }
                       }];
    }
}

- (NSString*)convertImageURLString: (NSString*) urlString toSizeOf: (IMAGE_SIZE) imageSize{
    
    if (urlString == nil || [urlString isKindOfClass: [NSNull class]] || [urlString isEqualToString:@""] ) {
        return nil;
    }
    
    NSArray* components = [urlString componentsSeparatedByString:@"/"];
    NSMutableString* result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < components.count - 1; i++) {
        [result appendFormat:@"%@/", components[i]];
    }
    
    NSString* key;
    switch (imageSize) {
        case IMAGE_SIZE_THUMBNAIL:
            key = @"thumbnail";
            break;
        case IMAGE_SIZE_SMALL:
            key = @"small";
            break;
        case IMAGE_SIZE_MEDIUM:
            key = @"medium";
            break;
        case IMAGE_SIZE_LARGE:
            key = @"large";
            break;
        case IMAGE_SIZE_ORIGINAL:
            key = @"original";
            break;
        default:
            break;
    }
    [result appendFormat:@"%@/", key];
    [result appendString:components[components.count - 1]];
    
    NSLog(@"rrr %@", result);
    return [NSString stringWithString: result];
}

@end

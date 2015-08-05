//
//  RoundedUIImageView.h
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import "UIImageView+Haneke.h" pod 'Haneke', '~> 1.0'
#import <SDWebImage/UIImageView+WebCache.h>

typedef enum {
    IMAGE_SIZE_THUMBNAIL = 1,   // 250px
    IMAGE_SIZE_SMALL = 2,       // 500px
    IMAGE_SIZE_MEDIUM = 3,      // 1200px
    IMAGE_SIZE_LARGE = 4,       // 1500px
    IMAGE_SIZE_ORIGINAL = 5     // Original
}IMAGE_SIZE;

@interface RoundedUIImageView : UIImageView

- (void)goodRichSetImageWithURL: (NSString*) imageURL toSize: (IMAGE_SIZE) imageSize;

- (NSString*)convertImageURLString: (NSString*) urlString toSizeOf: (IMAGE_SIZE) imageSize;

@end

//
//  ShareTableViewCell.h
//  Goodrich
//
//  Created by Shaohuan on 3/3/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedUIImageView.h"

@interface ShareTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet RoundedUIImageView  *contentImageView;
@property (strong, nonatomic) IBOutlet UITextView *contentDetail;

@end

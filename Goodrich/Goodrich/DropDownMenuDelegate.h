//
//  DropDownMenuDelegate.h
//  Goodrich
//
//  Created by Zhixing on 2/1/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

@protocol DropDownMenuDelegate <NSObject>

- (void)dropDownItemButtonClicked:(UIButton *)sender;
- (void)setTitleToTitleLabel: (NSString*)title;
@end
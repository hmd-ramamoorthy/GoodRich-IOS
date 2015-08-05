//
//  ToggleSideBarButtonClickedDelegate.h
//  Goodrich
//
//  Created by Zhixing on 30/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

@protocol ToggleSideBarButtonClickedDelegate <NSObject>

- (void) toggleSideBarButtonClicked;

- (void) setSideBarEnabled: (BOOL)enabled;

@end

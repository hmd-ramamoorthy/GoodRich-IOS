//
//  SidebarItemClickedDelegate.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SidebarItemClickedDelegate <NSObject>

- (void) sidebarItemClickedWithNewViewController: (UIViewController*)vc;

@end

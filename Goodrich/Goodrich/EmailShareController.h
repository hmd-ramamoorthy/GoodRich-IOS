//
//  EmailShareController.h
//  Goodrich
//
//  Created by Shaohuan on 3/3/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmailModel;

@interface EmailShareController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contactsTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *emailContentTextView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)sendButtonClicked:(id)sender;
- (IBAction)addContact:(id)sender;

/**
 Set up a email model for this view controller
 
 ##warning
 This method should be called before present this controller
 */
- (void)setModel:(EmailModel *)model;

@end

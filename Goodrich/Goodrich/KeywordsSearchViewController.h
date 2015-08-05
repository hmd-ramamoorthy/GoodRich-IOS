//
//  KeywordsSearchViewController.h
//  Goodrich
//
//  Created by Zhixing Yang on 17/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#import "TemplateViewController.h"
#import "Product.h"
#import "SearchResultViewController.h"
#import "TextSearchDelegate.h"

@interface KeywordsSearchViewController : TemplateViewController<TextSearchDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)searchButtonClicked:(id)sender;

@end

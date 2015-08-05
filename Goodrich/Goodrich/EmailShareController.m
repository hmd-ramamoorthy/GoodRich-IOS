//
//  EmailShareController.m
//  Goodrich
//
//  Created by Shaohuan on 3/3/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "EmailShareController.h"
#import "EmailModel.h"
#import "EmailModelServices.h"
#import "ShareTableViewCell.h"
#import "Product.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <Toast/UIView+Toast.h>
#import "Constants.h"


#define RGB(R,G,B,A) ([UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A])

@interface EmailShareController()<ABPeoplePickerNavigationControllerDelegate>

@end

static NSString * const EmailValidation = @"emailAddresses.@count > 0";
static CGFloat const AccessorViewHeight = 30;
static CGFloat const AccessorViewButtonWidth = 70;

@implementation EmailShareController {
    EmailModel *emailModel;
    id<EmailModelDelegate> emailModelServices;
    UIApplication *app;
    UIActivityIndicatorView *spinner;
}

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    app = [UIApplication sharedApplication];
    spinner = [[UIActivityIndicatorView alloc]
               initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //add spinner
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    
    // Calculate scroll view height
    CGSize size = self.scrollView.frame.size;
    size.height = self.emailContentTextView.frame.origin.y * 2 + self.emailContentTextView.frame.size.height
    + self.tableView.rowHeight * emailModel.products.count;
    
    self.scrollView.contentSize = size;
    
    // Tableview height
    CGRect frame = self.tableView.frame;
    frame.size.height = emailModel.products.count * self.tableView.rowHeight;
    self.tableView.frame = frame;
    
    // Add input accessor view on textview
    UIView *view = [self inputAccessoryView];
    self.contactsTextField.inputAccessoryView = view;
    self.subjectTextField.inputAccessoryView = view;
    self.emailContentTextView.inputAccessoryView = view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)cancelButtonClicked:(id)sender {
    [app setNetworkActivityIndicatorVisible:NO];
    [spinner stopAnimating];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)sendButtonClicked:(id)sender {
    //hide the keyboard
    [self.view endEditing:YES];
    
    emailModel.contacts = [self.contactsTextField.text componentsSeparatedByString:@";"];
    emailModel.subject = self.subjectTextField.text;
    emailModel.emailContent = self.emailContentTextView.text;
    
    //disable send button when start sending email
    [self.sendButton setEnabled:NO];
    [app setNetworkActivityIndicatorVisible:YES];
    [spinner startAnimating];
    
    [emailModelServices sendEmailWithsuccess:^(NSInteger statusCode, id response) {
        // Do something if send succeeds
        NSLog(@"send email successfully");
        
        [self.sendButton setEnabled:YES];
        [app setNetworkActivityIndicatorVisible:NO];
        [spinner stopAnimating];
        [self.view makeToast:@"Email sent successfully" duration:TOAST_MESSAGE_DURATION position:TOAST_MESSAGE_POSITION];
    } failure:^(NSInteger statusCode, id response) {
        // Do something if send fails
        NSLog(@"fail to send the email");
        
        [self.sendButton setEnabled:YES];
        [app setNetworkActivityIndicatorVisible:NO];
        [spinner stopAnimating];
        [self.view makeToast:((NSString *)response) duration:TOAST_MESSAGE_DURATION position:TOAST_MESSAGE_POSITION];
        
    }];
}

- (IBAction)addContact:(id)sender {
    NSLog(@"ADD NEW CONTACT");
    
    static ABPeoplePickerNavigationController *picker = nil;
    if (!picker) {
        picker = [ABPeoplePickerNavigationController new];
        picker.peoplePickerDelegate = self;
        picker.predicateForEnablingPerson = [NSPredicate predicateWithFormat:EmailValidation];
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return emailModel.products.count;
}

- (ShareTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ShareTableCell";
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    Product *product = [emailModel.products objectAtIndex:indexPath.row];
    NSLog(@"%@",[NSValue valueWithCGRect:cell.contentImageView.frame]);
    // Add product image
    [cell.contentImageView goodRichSetImageWithURL:product.s3URL toSize:IMAGE_SIZE_THUMBNAIL];
    NSLog(@"%@",[NSValue valueWithCGRect:cell.contentImageView.frame]);
    
    // Add product detail
    NSString *description = @"";
    NSArray *sequenceKeys = [self detailSequenceKeysWithType:[product.details objectForKey:@"Category"]];
    for (NSString *key in sequenceKeys) {
        if (![product.details objectForKey:key]) continue; // if nil, no need to display
        
        description = [description stringByAppendingString:
                       [NSString stringWithFormat:@"%@ : %@\n",key, [product.details objectForKey:key]] ];
    }
    cell.contentDetail.text = description;
    
    return cell;
}

#pragma mark PeoplePicker Delegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    CFStringRef emailRef;
    // TODO Consider send all email of a user, currently only send the first email address
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (ABMultiValueGetCount(multi) > 0) {
        emailRef = ABMultiValueCopyValueAtIndex(multi, 0);
    }
    
    CFStringRef sourceName = (CFStringRef)ABRecordCopyValue(person, kABSourceNameProperty);
    if (!sourceName) {
        sourceName = emailRef;
    }
    NSLog(@"%@ has email %@", sourceName, emailRef);
    
    //check whether contacts string end with a semicolon or empty
    NSString *contactsString = self.contactsTextField.text;
    NSString *reg = @"(.*;)?";
    NSPredicate *predict = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    if (![predict evaluateWithObject:contactsString]) {//not match the reg
        contactsString = [contactsString stringByAppendingString:@";"];
    }
    contactsString = [contactsString stringByAppendingString:(__bridge NSString *)emailRef];
    self.contactsTextField.text = contactsString;
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Instance Methods

- (void)setModel:(EmailModel *)model {
    emailModel = model;
    emailModelServices = model.services;
    
    [emailModelServices retrieveDetailWithIds:emailModel.productIds success:^(NSInteger statusCode, id response) {
        // Do something if update successfully
        [self.tableView reloadData];
    } failure:^(NSInteger statusCode, id response) {
        // Do something if update fails
    }];
}

#pragma mark Private Methods

- (UIView *)inputAccessoryView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, AccessorViewHeight)];
    view.backgroundColor = RGB(0xF2, 0xF2, 0xF2, 1.0);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:
        CGRectMake(view.frame.size.width - AccessorViewButtonWidth, 0, AccessorViewButtonWidth, AccessorViewHeight)];
    [btn setTitle:@"Done" forState:UIControlStateNormal];
    [btn setTitleColor:RGB(0x24, 0x24, 0x24, 1.0) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(textEditDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:btn];
    
    return view;
}

- (void)textEditDone:(id)sender {
    NSLog(@"clicked");
    [self.view endEditing:YES];
}

- (NSArray *)detailSequenceKeysWithType:(NSString *)type {
    if (!type) {
        return nil;
    }
    
    NSMutableArray *keys = [NSMutableArray array];
    
    if([type isEqualToString:@"wallcovering"]){
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"RollWidth"];
        [keys addObject:@"RollLength"];
        [keys addObject:@"Weight"];
        [keys addObject:@"Backing"];
        [keys addObject:@"PatternRepeat"];
        [keys addObject:@"FireRating"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"Origin"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"Category"];
    }else if([type isEqualToString:@"fabric"]){
        [keys addObject:@"Color"];
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"Width"];
        [keys addObject:@"Composition"];
        [keys addObject:@"Abrasion"];
        [keys addObject:@"PatternRepeat"];
        [keys addObject:@"Remarks"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"Usage"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"Category"];
    }else if([type isEqualToString:@"carpet"]){
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"Size/Width"];
        [keys addObject:@"PileWeight"];
        [keys addObject:@"DyeingMethod"];
        [keys addObject:@"Yarn"];
        [keys addObject:@"Backing"];
        [keys addObject:@"Construction"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"Category"];
    }else{
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"WoodSpecies"];
        [keys addObject:@"Size(Length-mm)"];
        [keys addObject:@"Size(Width-mm)"];
        [keys addObject:@"Size(sqm/UOM)"];
        [keys addObject:@"Size(Thickness-mm)"];
        [keys addObject:@"UOM"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"CountryofOrigin"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"Category"];
    }
    
    return keys;
}

@end

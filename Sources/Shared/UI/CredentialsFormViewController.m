//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//


#import "CredentialsFormViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "ServerAddingViewController.h"
#import "LanguageHelper.h"
#import "defines.h"

#define kCredentialItemCellTextlabelTag 10
#define kCredentialsFormSectionTitleHeight 10.0

static NSString* CredentialsFormCellIdentifier = @"CredentialItem";

@interface CredentialsFormViewController ()

@end

@implementation CredentialsFormViewController

@synthesize doneButton;
@synthesize username;
@synthesize password;
@synthesize account;
@synthesize delegate;

#pragma mark Initialization

- (instancetype)initWithAccount:(ServerObj*)selectedAccount andDelegate:(id<CredentialsFormResultDelegate>)dlg
{
    self = [super initWithNibName:@"CredentialsFormViewController" bundle:nil];
    if (self) {
        self.account = selectedAccount;
        self.delegate = dlg;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Sign In") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    
    [self initTextFields];
    [self setDoneButtonVisible];
    
    // Table view background
    self.tableView.backgroundColor = EXO_BACKGROUND_COLOR;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)dealloc
{
    self.doneButton = nil;
    self.username = nil;
    self.password = nil;
    self.account = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void) initTextFields
{
    self.username = [[ServerAddingViewController textInputFieldForCellWithSecure:NO andRequired:YES] retain];
    [self.username setReturnKeyType:UIReturnKeyNext];
	self.username.delegate = self;
    if (![self.account.username isEqualToString:@""])
        self.username.text = self.account.username;
    [self.username addTarget:self action:@selector(setDoneButtonVisible)
                   forControlEvents:UIControlEventEditingChanged];
    
    self.password = [[ServerAddingViewController textInputFieldForCellWithSecure:YES andRequired:YES] retain];
    [self.password setReturnKeyType:UIReturnKeyDone];
	self.password.delegate = self;
    if (![self.account.password isEqualToString:@""])
        self.password.text = self.account.password;
    [self.password addTarget:self action:@selector(setDoneButtonVisible)
            forControlEvents:UIControlEventEditingChanged];
}

#pragma mark Actions

- (void) doneAction
{
    // call the delegate method and remove this view from the navigation controller stack
    if (self.delegate != nil && ![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""]) {
        self.account.username = self.username.text;
        self.account.password = self.password.text;
        [self.delegate onCredentialsFormSubmittedWithAccount:self.account];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) setDoneButtonVisible
{
    if (![self.username.text isEqualToString:@""] && ![self.password.text isEqualToString:@""])
        [self.doneButton setEnabled:YES];
    else
        [self.doneButton setEnabled:NO];
}

#pragma mark TextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    // Move from one text field to another when tapping Next
    // Save when tapping Done on the last field
    if ([theTextField isEqual:self.username]) {
        [self.password becomeFirstResponder];
    } else if([theTextField isEqual:self.password]) {
        [self doneAction];
    }
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched.
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return Localize(@"Your credentials"); // Your Credentials
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kCredentialsFormSectionTitleHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomBackgroundForCell_iPhone *cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CredentialsFormCellIdentifier];
    if (cell == nil) {
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CredentialsFormCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect cellBounds = cell.bounds;
        UILabel *textLabel = [[[UILabel alloc] init] autorelease];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        textLabel.frame = CGRectMake(cell.indentationWidth, 0, cellBounds.size.width / 3, cellBounds.size.height);
        textLabel.tag = kCredentialItemCellTextlabelTag;
        [cell.contentView addSubview:textLabel];
    }
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:kCredentialItemCellTextlabelTag];
    if (indexPath.row == 0) {
        textLabel.text = Localize(@"Username");
        [cell.contentView addSubview:self.username];
    } else if (indexPath.row == 1) {
        textLabel.text = Localize(@"Password");
        [cell.contentView addSubview:self.password];
    }
    int row = (int)indexPath.row;
    int size = (int)[self tableView:tableView numberOfRowsInSection:indexPath.section];
    [cell setBackgroundForRow:row inSectionSize:size];
    
    return cell;
}


@end

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
#import <Three20/Three20.h>

#import "ServerEditingViewController.h"
#import "ServerAddingViewController.h"
#import "ApplicationPreferencesManager.h"
#import "UserPreferencesManager.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "URLAnalyzer.h"
#import "LanguageHelper.h"
#import "defines.h"
#import "SettingsViewController.h"

static NSString *ServerObjCellIdentifier = @"ServerObj";

@implementation ServerEditingViewController

@synthesize _txtfServerName;
@synthesize _txtfServerUrl;
@synthesize usernameTf = _usernameTf;
@synthesize passwordTf = _passwordTf;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _serverObj = [[ServerObj alloc] init];
        [self initTextFields];
        _intIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    [_strServerName release];
    [_strServerUrl release];
    [_txtfServerName release];
    [_txtfServerUrl release];
    [_serverObj release];
    [_usernameTf release];
    [_passwordTf release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set title of the screen as the account name
    if (_serverObj != nil) self.title = _serverObj.accountName;
    else self.title = Localize(@"ServerModify");
    
    // Create and add a Done button in the navigation bar
    _bbtnEdit = [[UIBarButtonItem alloc] initWithTitle:Localize(@"DoneButton") style:UIBarButtonItemStyleDone target:self action:@selector(onBbtnDone)];
    [self.navigationItem setRightBarButtonItem:_bbtnEdit];
    
    // Table view background
    self.tableView.backgroundColor = EXO_BACKGROUND_COLOR;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_txtfServerName setTextColor:[UIColor grayColor]];
    [_txtfServerUrl setTextColor:[UIColor grayColor]];
    [_usernameTf setTextColor:[UIColor grayColor]];
    [_passwordTf setTextColor:[UIColor grayColor]];
    [_bbtnEdit setEnabled:NO];
    
    [_txtfServerName becomeFirstResponder];
    
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{    
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
    
    [super viewWillDisappear:YES];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    [super disablesAutomaticKeyboardDismissal];
    return NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

- (void)setServerObj:(ServerObj*)serverObj andIndex:(int)index
{
    _serverObj.accountName = serverObj.accountName;
    _serverObj.serverUrl = serverObj.serverUrl;
    
    _serverObj.username = serverObj.username;
    _serverObj.password = serverObj.password;
    
    _serverObj.bSystemServer = serverObj.bSystemServer;
    [_txtfServerName setText:_serverObj.accountName];
    [_txtfServerUrl setText:_serverObj.serverUrl];
    
    if([serverObj.username length] > 0) {
        _usernameTf.text = serverObj.username;
    } else {
        [_usernameTf setPlaceholder:Localize(@"Optional")];
    }
    
    if([serverObj.password length] > 0) {
        _passwordTf.text = serverObj.password;
    } else {
        [_passwordTf setPlaceholder:Localize(@"Optional")];
    }
    
    _intIndex = index;
    
    // YES : all fields are enabled and can be edited
    // NO  : only the account name can be edited
    BOOL sameAccount = [ApplicationPreferencesManager sharedInstance].selectedServerIndex == _intIndex;
    BOOL connected   = [UserPreferencesManager sharedInstance].isUserLogged;
    _canEdit = !sameAccount || !connected;
}

- (void)onBbtnDone
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
    
    if ([_delegate editServerObjAtIndex:_intIndex withSeverName:[_txtfServerName text] andServerUrl:[_txtfServerUrl text] withUsername:_usernameTf.text andPassword:_passwordTf.text]) {
     [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark TextField methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_bbtnEdit setEnabled:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    // Move from one text field to another when tapping Next
    // Save when tapping Done on the last field
    
    if (theTextField == _txtfServerName) {
        [_txtfServerUrl becomeFirstResponder];
    } else if(theTextField == _txtfServerUrl) {
        [_usernameTf becomeFirstResponder];
    } else if(theTextField == _usernameTf) {
        [_passwordTf becomeFirstResponder];
    } else {
        [_passwordTf resignFirstResponder];
        [self onBbtnDone];
    }
    return YES;        
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched.
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];	
    [super touchesBegan:touches withEvent:event];
}


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
    if (section == 0)
        tmpStr = Localize(@"Account");
    else if(section == 1)
        tmpStr = Localize(@"Your credentials"); // You credentials
	return tmpStr;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // There are 2 rows per section:
    return 2;
}

#define kServerEditCellTextlabelTag 10
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomBackgroundForCell_iPhone *cell = (CustomBackgroundForCell_iPhone*)[tableView  dequeueReusableCellWithIdentifier:ServerObjCellIdentifier];
    if(cell == nil){
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServerObjCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGRect cellBounds = cell.bounds;
        UILabel *textLabel = [[[UILabel alloc] init] autorelease];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        textLabel.frame = CGRectMake(cell.indentationWidth, 0, cellBounds.size.width / 3, cellBounds.size.height);
        textLabel.tag = kServerEditCellTextlabelTag;
        [cell.contentView addSubview:textLabel];
    }
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:kServerEditCellTextlabelTag];
    if(indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            textLabel.text = Localize(@"ServerName");
            [self configureTextField:_txtfServerName withTextLabel:textLabel inCell:cell];
        }
        else
        {
            textLabel.text = Localize(@"ServerUrl");
            [_txtfServerUrl setEnabled:_canEdit];
            [self configureTextField:_txtfServerUrl withTextLabel:textLabel inCell:cell];
        }
        
    } else {
        if(indexPath.row == 0)
        {
            textLabel.text = Localize(@"Username");
            [_usernameTf setEnabled:_canEdit];
            [self configureTextField:_usernameTf withTextLabel:textLabel inCell:cell];
        }
        else
        {
            textLabel.text = Localize(@"Password");
            [_passwordTf setEnabled:_canEdit];
            [self configureTextField:_passwordTf withTextLabel:textLabel inCell:cell];
        }
    }

    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
}

#pragma mark Text fields helper
- (void) initTextFields
{
    [_txtfServerName release];
    _txtfServerName = [[ServerAddingViewController textInputFieldForCellWithSecure:NO andRequired:YES] retain];
    [_txtfServerName setReturnKeyType:UIReturnKeyNext];
	_txtfServerName.delegate = self;
    
    [_txtfServerUrl release];
	_txtfServerUrl = [[ServerAddingViewController textInputFieldForCellWithSecure:NO andRequired:YES] retain];
    [_txtfServerUrl setReturnKeyType:UIReturnKeyNext];
    //Customize the style of the texfield
    _txtfServerUrl.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	_txtfServerUrl.delegate = self;
    
    // credentials text fields
    [_usernameTf release];
    _usernameTf = [[ServerAddingViewController textInputFieldForCellWithSecure:NO andRequired:NO] retain];
    [_usernameTf setReturnKeyType:UIReturnKeyNext];
	_usernameTf.delegate = self;
    
    [_passwordTf release];
    _passwordTf = [[ServerAddingViewController textInputFieldForCellWithSecure:YES andRequired:NO] retain];
    [_passwordTf setReturnKeyType:UIReturnKeyDone];
	_passwordTf.delegate = self;
}


- (void)configureTextField:(UITextField *)tf withTextLabel:(UILabel *)textLabel inCell:(UITableViewCell *)cell
{
    [cell.contentView addSubview:tf];
}
@end



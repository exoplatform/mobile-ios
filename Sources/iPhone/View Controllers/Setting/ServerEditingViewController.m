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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [_btnDelete release];
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
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"ServerModify");
    _bbtnEdit = [[UIBarButtonItem alloc] initWithTitle:Localize(@"DoneButton") style:UIBarButtonItemStyleDone target:self action:@selector(onBbtnDone)];
    [self.navigationItem setRightBarButtonItem:_bbtnEdit];
        
    _btnDelete = [[UIButton alloc] init];

    int marginLeft;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        marginLeft = 32;
    else
        marginLeft = 10;

    [_btnDelete setFrame:CGRectMake(marginLeft, 10, self.navigationController.view.frame.size.width - marginLeft*2, 44)];

        
    [_btnDelete setBackgroundImage:[[UIImage imageNamed:@"DeleteButton"]
                                    stretchableImageWithLeftCapWidth:5 topCapHeight:5]
                          forState:UIControlStateNormal];
    [_btnDelete setTitle:Localize(@"Delete") forState:UIControlStateNormal];
    [_btnDelete addTarget:self action:@selector(onBtnDelete) forControlEvents:UIControlEventTouchUpInside];
    
    
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
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

- (void)setServerObj:(ServerObj*)serverObj andIndex:(int)index
{
    _serverObj._strServerName = serverObj._strServerName;
    _serverObj._strServerUrl = serverObj._strServerUrl;
    
    _serverObj.username = serverObj.username;
    _serverObj.password = serverObj.password;
    
    _serverObj._bSystemServer = serverObj._bSystemServer;
    [_txtfServerName setText:_serverObj._strServerName];
    [_txtfServerUrl setText:_serverObj._strServerUrl];
    
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
}

- (void)onBbtnDone
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
    
    if ([_delegate editServerObjAtIndex:_intIndex withSeverName:[_txtfServerName text] andServerUrl:[_txtfServerUrl text] withUsername:_usernameTf.text andPassword:_passwordTf.text]) {
     [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onBtnDelete
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder]; 
    if ([_delegate deleteServerObjAtIndex:_intIndex]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_SERVER_DELETED object:self];
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
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    
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
    if(section == 1) {
        tmpStr = Localize(@"Your credentials");
    }
	return tmpStr;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 1) {
        return 44.0;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 1) { //add the delete button at the bottom of the table view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        [view addSubview:_btnDelete];
        return view;
    }
    return nil;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
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
            [self configureTextField:_txtfServerUrl withTextLabel:textLabel inCell:cell];
        }
        
    } else {
        if(indexPath.row == 0)
        {
            textLabel.text = Localize(@"Username");
            [self configureTextField:_usernameTf withTextLabel:textLabel inCell:cell];
        }
        else
        {
            textLabel.text = Localize(@"Password");
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



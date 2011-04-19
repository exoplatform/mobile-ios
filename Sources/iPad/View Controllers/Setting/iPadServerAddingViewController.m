//
//  iPadiPadServerAddingViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "iPadServerAddingViewController.h"
#import "ServerManagerViewController.h"
#import "ContainerCell.h"
#import "defines.h"
#import "LoginViewController.h"

@implementation iPadServerAddingViewController

@synthesize _txtfServerName;
@synthesize _txtfServerUrl;
@synthesize _tblvServerInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dictLocalize = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_strServerName release];
    [_strServerUrl release];
    [_txtfServerName release];
    [_txtfServerUrl release];
    [_dictLocalize release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
    _dictLocalize = [_delegate getLocalization];
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self changeOrientation:interfaceOrientation];
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        [_tblvServerInfo setFrame:CGRectMake(0, 44, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD - 44)];
        [_btnDone setFrame:CGRectMake(690, 5, 60, 37)];
	}
    
    if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        [_tblvServerInfo setFrame:CGRectMake(0, 44, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD - 44)];
        [_btnDone setFrame:CGRectMake(946, 5, 60, 37)];
	}
    _interfaceOrientation = interfaceOrientation;
    [_tblvServerInfo reloadData];
}

- (IBAction)onBtnBack:(id)sender
{
    [_delegate onBackDelegate];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    _txtfServerName = [iPadServerAddingViewController textInputFieldForCellWithSecure:NO];
    [_txtfServerName setReturnKeyType:UIReturnKeyNext];
	_txtfServerName.delegate = self;
	_txtfServerUrl = [iPadServerAddingViewController textInputFieldForCellWithSecure:NO];
    [_txtfServerUrl setReturnKeyType:UIReturnKeyDone];
	_txtfServerUrl.delegate = self;

    _btnDone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnDone setFrame:CGRectMake(100, 10, 60, 37)];
    [_btnDone.titleLabel setTextColor:[UIColor redColor]];
    [_btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [_btnDone addTarget:self action:@selector(onBtnDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDone];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)onBtnDone
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
    _strServerName = [_txtfServerName text];
    _strServerUrl = [_txtfServerUrl text];
    
    if ([_strServerName length] > 0 && [_strServerUrl length] > 0) 
    {
        [_delegate addServerObjWithServerName:_strServerName andServerUrl:_strServerUrl];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Info" message:@"You cannot add a server with an empty name or url" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure 
{
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(220, 12, 400, 22)];
    textField.placeholder = @"Required";
    textField.secureTextEntry = secure;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view 
{
    NSString *MyIdentifier = label.text;
    ContainerCell *cell = (ContainerCell*)[_tblvServerInfo dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) 
    {
        cell = [[ContainerCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = label.text;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell attachContainer:view];
    
    return cell;
}

- (UITableViewCell*)textCellWithLabel:(UILabel*)label 
{
    NSString *MyIdentifier = label.text;
    ContainerCell *cell = (ContainerCell*)[_tblvServerInfo dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) 
    {
        cell = [[ContainerCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = label.text;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
//    if ((theTextField == _txtfServerName) || (theTextField == _txtfServerUrl))
//    {
//        [theTextField resignFirstResponder];
//    }
    
    if (theTextField == _txtfServerName) 
    {
        [_txtfServerUrl becomeFirstResponder];
    }
    else
    {    
        [_txtfServerUrl resignFirstResponder];
        [self onBtnDone];
    }    
    
    _strServerName = [[_txtfServerName text] retain];
    _strServerUrl = [[_txtfServerUrl text] retain];
    if ([_strServerName length] > 0 && [_strServerUrl length] > 0) 
    {
        [_btnDone setEnabled:YES];
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	return tmpStr;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServerObjCellIdentifier];
    if(cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServerObjCellIdentifier] autorelease];
    }
    
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        [_txtfServerName setFrame:CGRectMake(220, 12, 500, 22)];
        [_txtfServerUrl setFrame:CGRectMake(220, 12, 500, 22)];
    }
    
    if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {	
        [_txtfServerName setFrame:CGRectMake(220, 12, 750, 22)];
        [_txtfServerUrl setFrame:CGRectMake(220, 12, 750, 22)];
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            UILabel* lbServerName = [[UILabel alloc] init];
            lbServerName.text = @"Server Name"; //it will be localized later
            return [self containerCellWithLabel:lbServerName view:_txtfServerName];
            break;
        }	
        case 1:
        {
            UILabel* lbServerUrl = [[UILabel alloc] init];
            lbServerUrl.text = @"Server Url"; //it will be localized later
            return [self containerCellWithLabel:lbServerUrl view:_txtfServerUrl];
            break;
        }
    }
    return cell;
}

@end


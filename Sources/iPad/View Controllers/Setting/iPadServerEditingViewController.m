//
//  iPadServerEditingViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/29/11.
//  Copyright 2011 home. All rights reserved.
//

#import "iPadServerEditingViewController.h"
#import "iPadServerAddingViewController.h"
#import "iPadServerManagerViewController.h"
#import "Configuration.h"
#import "ContainerCell.h"
#import "defines.h"
#import "LoginViewController.h"

@implementation iPadServerEditingViewController

@synthesize _txtfServerName;
@synthesize _txtfServerUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _serverObj = [[ServerObj alloc] init];
        _txtfServerName = [iPadServerAddingViewController textInputFieldForCellWithSecure:NO];
        _txtfServerName.delegate = self;
        _txtfServerUrl = [iPadServerAddingViewController textInputFieldForCellWithSecure:NO];
        _txtfServerUrl.delegate = self;
        _intIndex = -1;
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
    [_serverObj release];
    [_dictLocalize release];
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
    //_bbtnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onBbtnEdit)];
    _bbtnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onBbtnEdit)]; //It will be localized later
    [self.navigationItem setRightBarButtonItem:_bbtnEdit];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    _bEdit = NO;
    [_txtfServerName setEnabled:NO];
    [_txtfServerUrl setEnabled:NO];
    [_txtfServerName setTextColor:[UIColor grayColor]];
    [_txtfServerUrl setTextColor:[UIColor grayColor]];
    [super viewWillAppear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
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
	}
    
    if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        [_tblvServerInfo setFrame:CGRectMake(0, 44, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD - 44)];
	}
}

- (IBAction)onBtnBack:(id)sender
{
    [_delegate onBackDelegate];
}

- (void)setServerObj:(ServerObj*)serverObj andIndex:(int)index
{
    _serverObj._strServerName = serverObj._strServerName;
    _serverObj._strServerUrl = serverObj._strServerUrl;
    _serverObj._bSystemServer = serverObj._bSystemServer;
    [_txtfServerName setText:_serverObj._strServerName];
    [_txtfServerUrl setText:_serverObj._strServerUrl];
    
    _intIndex = index;
}

- (void)onBbtnEdit
{
    _bEdit = !_bEdit;
    [_txtfServerName setEnabled:_bEdit];
    [_txtfServerUrl setEnabled:_bEdit];

    if (_bEdit) 
    {
        [_bbtnEdit setTitle:@"Done"];
        [_txtfServerName setTextColor:[UIColor blackColor]];
        [_txtfServerUrl setTextColor:[UIColor blackColor]];
        
        UIButton* btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
        [btnDelete setBackgroundColor:[UIColor redColor]];
        [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(onBtnDelete) forControlEvents:UIControlEventTouchUpInside];
        [_tblvServerInfo addSubview:btnDelete];
        [btnDelete release];                        
    }
    else
    {
        [_bbtnEdit setTitle:@"Edit"];
        [_txtfServerName resignFirstResponder];
        [_txtfServerUrl resignFirstResponder];
        [_txtfServerName setTextColor:[UIColor grayColor]];
        [_txtfServerUrl setTextColor:[UIColor grayColor]];
        _strServerName = [_txtfServerName text];
        _strServerUrl = [_txtfServerUrl text];
        [_delegate editServerObjAtIndex:_intIndex withSeverName:_strServerName andServerUrl:_strServerUrl];
    }
}

- (void)onBtnDelete
{
    [_delegate deleteServerObjAtIndex:_intIndex];
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
    if ((theTextField == _txtfServerName) || (theTextField == _txtfServerUrl))
    {
        [theTextField resignFirstResponder];
    }
    
    _strServerName = [[_txtfServerName text] retain];
    _strServerUrl = [[_txtfServerUrl text] retain];

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



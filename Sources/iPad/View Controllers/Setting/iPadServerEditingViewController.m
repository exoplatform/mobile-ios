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
    [_btnDelete release];
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
    _btnEdit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnEdit setFrame:CGRectMake(100, 10, 60, 37)];
    [_btnEdit.titleLabel setTextColor:[UIColor redColor]];
    [_btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    [_btnEdit addTarget:self action:@selector(onBtnEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEdit];
    
    _btnDelete = [[UIButton alloc] init];
    [_btnDelete setBackgroundColor:[UIColor redColor]];
    [_btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    [_btnDelete addTarget:self action:@selector(onBtnDelete) forControlEvents:UIControlEventTouchUpInside];
    [_tblvServerInfo addSubview:_btnDelete];
    
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
        [_btnEdit setFrame:CGRectMake(690, 5, 60, 37)];
	}
    
    if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        [_tblvServerInfo setFrame:CGRectMake(0, 44, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD - 44)];
        [_btnEdit setFrame:CGRectMake(946, 5, 60, 37)];
	}
    _interfaceOrientation = interfaceOrientation;
}

- (IBAction)onBtnBack:(id)sender
{
    _bEdit = NO;
    [_btnDelete setHidden:YES];
    [_btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
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

- (void)onBtnEdit
{
    _bEdit = !_bEdit;
    
    [_txtfServerName setEnabled:_bEdit];
    [_txtfServerUrl setEnabled:_bEdit];

    if (_bEdit) 
    {
        [_btnEdit setTitle:@"Done" forState:UIControlStateNormal];
        [_txtfServerName setTextColor:[UIColor blackColor]];
        [_txtfServerUrl setTextColor:[UIColor blackColor]];
        
        
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            [_btnDelete setFrame:CGRectMake(40, 150, 688, 37)];
        }
        
        if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {
            [_btnDelete setFrame:CGRectMake(40, 150, 944, 37)];
        }
        
        [_btnDelete setHidden:NO];                        
    }
    else
    {
        [_btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        [_txtfServerName resignFirstResponder];
        [_txtfServerUrl resignFirstResponder];
        [_txtfServerName setTextColor:[UIColor grayColor]];
        [_txtfServerUrl setTextColor:[UIColor grayColor]];
        _strServerName = [_txtfServerName text];
        _strServerUrl = [_txtfServerUrl text];
        [_delegate editServerObjAtIndex:_intIndex withSeverName:_strServerName andServerUrl:_strServerUrl];
        [_btnDelete setHidden:YES];                                
    }
}

- (void)onBtnDelete
{
    _bEdit = !_bEdit;
    [_btnDelete setHidden:YES];    
    [_btnEdit setTitle:@"Edit" forState:UIControlStateNormal];

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



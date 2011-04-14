//
//  ServerEditingViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/29/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ServerEditingViewController.h"
#import "ServerAddingViewController.h"
#import "ServerManagerViewController.h"
#import "Configuration.h"
#import "ContainerCell.h"

@implementation ServerEditingViewController

@synthesize _txtfServerName;
@synthesize _txtfServerUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _serverObj = [[ServerObj alloc] init];
        _txtfServerName = [ServerAddingViewController textInputFieldForCellWithSecure:NO];
        _txtfServerName.delegate = self;
        _txtfServerUrl = [ServerAddingViewController textInputFieldForCellWithSecure:NO];
        _txtfServerUrl.delegate = self;
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
    
    _btnDelete = [[UIButton alloc] init];
    [_btnDelete setFrame:CGRectMake(10, 110, 300, 40)];
    [_btnDelete setBackgroundColor:[UIColor redColor]];
    [_btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    [_btnDelete addTarget:self action:@selector(onBtnDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:_btnDelete]; 
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    _bEdit = NO;
    [_btnDelete setHidden:YES];
    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    
    [super viewWillDisappear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
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

        [_btnDelete setHidden:NO];                    
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
        [_btnDelete setHidden:YES];
    }
}

- (void)onBtnDelete
{
    _bEdit = !_bEdit;
    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    [_btnDelete setHidden:YES];
    [_delegate deleteServerObjAtIndex:_intIndex];
}

- (UITableViewCell*)containerCellWithLabel:(UILabel*)label view:(UIView*)view 
{
    NSString *MyIdentifier = label.text;
    ContainerCell *cell = (ContainerCell*)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
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
    ContainerCell *cell = (ContainerCell*)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
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



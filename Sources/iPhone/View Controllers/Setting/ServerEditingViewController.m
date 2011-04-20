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
        [_txtfServerName setReturnKeyType:UIReturnKeyNext];
        _txtfServerName.delegate = self;
        _txtfServerUrl = [ServerAddingViewController textInputFieldForCellWithSecure:NO];
        [_txtfServerUrl setReturnKeyType:UIReturnKeyDone];
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
    _bbtnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onBbtnDone)]; //It will be localized later
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
    [_txtfServerName setTextColor:[UIColor grayColor]];
    [_txtfServerUrl setTextColor:[UIColor grayColor]];
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{    
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

- (void)onBbtnDone
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
    _strServerName = [_txtfServerName text];
    _strServerUrl = [_txtfServerUrl text];
    
    NSRange range = [_strServerUrl rangeOfString:@"http://"];
    if(range.length == 0)
    {
        _strServerUrl = [NSString stringWithFormat:@"http://%@", _strServerUrl];
    }
    
    if ([_strServerName length] > 0 && [_strServerUrl length] > 0) 
    {
        [_delegate editServerObjAtIndex:_intIndex withSeverName:_strServerName andServerUrl:_strServerUrl];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Info" message:@"You cannot add an empty username or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)onBtnDelete
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder]; 
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
//    if ((theTextField == _txtfServerName) || (theTextField == _txtfServerUrl))
//    {
//        [theTextField resignFirstResponder];
//    }
//    
//    _strServerName = [[_txtfServerName text] retain];
//    _strServerUrl = [[_txtfServerUrl text] retain];
    if (theTextField == _txtfServerName) 
    {
        [_txtfServerUrl becomeFirstResponder];
    }
    else
    {    
        [_txtfServerUrl resignFirstResponder];
        [self onBbtnDone];
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
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"Server Name";
            [cell addSubview:_txtfServerName];
        }
        else
        {
            cell.textLabel.text = @"Server Url";
            [cell addSubview:_txtfServerUrl];
        }
    }
    
    return cell;
}

@end



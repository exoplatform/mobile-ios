//
//  ServerAddingViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ServerAddingViewController.h"
#import "ServerManagerViewController.h"
#import "ContainerCell.h"


@implementation ServerAddingViewController

@synthesize _txtfServerName;
@synthesize _txtfServerUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_strServerName release];
    [_strServerUrl release];
    [_txtfServerName release];
    [_txtfServerUrl release];
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
    _txtfServerName = [ServerAddingViewController textInputFieldForCellWithSecure:NO];
	_txtfServerName.delegate = self;
	_txtfServerUrl = [ServerAddingViewController textInputFieldForCellWithSecure:NO];
	_txtfServerUrl.delegate = self;

    _bbtnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBbtnDone)];
    [_bbtnDone setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:_bbtnDone];
    
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
    [_txtfServerName setText:@""];
    [_txtfServerUrl setText:@""];
    [super viewWillAppear:YES];
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

- (void)onBbtnDone
{
    [_delegate addServerObjWithServerName:_strServerName andServerUrl:_strServerUrl];
}

+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure 
{
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 170, 22)];
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
    if ([_strServerName length] > 0 && [_strServerUrl length] > 0) 
    {
        [_bbtnDone setEnabled:YES];
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


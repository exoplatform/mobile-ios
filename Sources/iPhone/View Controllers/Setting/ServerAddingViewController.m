//
//  ServerAddingViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ServerAddingViewController.h"
#import "ServerManagerViewController.h"
#import "CustomBackgroundForCell_iPhone.h"


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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _txtfServerName = [ServerAddingViewController textInputFieldForCellWithSecure:NO];
    [_txtfServerName setReturnKeyType:UIReturnKeyNext];
	_txtfServerName.delegate = self;
    
    
	_txtfServerUrl = [ServerAddingViewController textInputFieldForCellWithSecure:NO];
    [_txtfServerUrl setReturnKeyType:UIReturnKeyDone];
    //Customize the style of the texfield
    _txtfServerUrl.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    _txtfServerUrl.adjustsFontSizeToFitWidth = YES;
	_txtfServerUrl.delegate = self;
    
    _bbtnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onBbtnDone)];
    //[_bbtnDone setEnabled:NO];
    [self.navigationItem setRightBarButtonItem:_bbtnDone];
    
    //Set the background Color of the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
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
    [_bbtnDone setEnabled:NO];
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
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
    _strServerName = [_txtfServerName text];
    _strServerUrl = [_txtfServerUrl text];
    
    NSRange range = [_strServerUrl rangeOfString:@"http://"];
    if(range.length == 0 && [_strServerUrl length] > 0)
    {
        _strServerUrl = [NSString stringWithFormat:@"http://%@", _strServerUrl];
    }
    
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
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(140, 15, 170, 22)];
    textField.placeholder = @"Required";
    textField.secureTextEntry = secure;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //Customize the style of the texfield
    textField.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    textField.adjustsFontSizeToFitWidth = YES;
    textField.textColor = [UIColor grayColor];
    
    return textField;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_bbtnDone setEnabled:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    
    if (theTextField == _txtfServerName) 
    {
        [_txtfServerUrl becomeFirstResponder];
    }
    else
    {    
        [_txtfServerUrl resignFirstResponder];
        _strServerName = [[_txtfServerName text] retain];
        _strServerUrl = [[_txtfServerUrl text] retain];
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
   
        CustomBackgroundForCell_iPhone *cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServerObjCellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0)
        {
            //TODO localize the label
            cell.textLabel.text = @"Server Name";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];

            [cell addSubview:_txtfServerName];
        }
        else
        {
            //TODO localize this label
            cell.textLabel.text = @"Server Url";
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            
            [cell addSubview:_txtfServerUrl];
        }
    

    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];

    
    return cell;

}

@end


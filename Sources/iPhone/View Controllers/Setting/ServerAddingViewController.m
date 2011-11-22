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
#import "URLAnalyzer.h"
#import "LanguageHelper.h"

static NSString *ServerObjCellIdentifier = @"ServerObj";


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
    self.title = Localize(@"ServerInformation");
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
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    //backgroundView.frame = self.view.frame;
    //self.tableView.backgroundView = backgroundView;
    //[backgroundView release];
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];

    
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
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
    
    [_txtfServerName becomeFirstResponder];
    
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)setDelegate:(id<ServerManagerProtocol>)delegate
{
    _delegate = delegate;
}

- (void)onBbtnDone
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder];
    _strServerName = [_txtfServerName text];
    _strServerUrl = [URLAnalyzer parserURL:[_txtfServerUrl text]];
    
    if ([_delegate addServerObjWithServerName:_strServerName andServerUrl:_strServerUrl]) [self.navigationController popViewControllerAnimated:YES];
}

+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure 
{
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
    textField.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
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

#pragma mark TextField methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_bbtnDone setEnabled:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Only characters in the NSCharacterSet you choose will insertable.
    NSCharacterSet *invalidCharSet = nil;
    
    if(textField == _txtfServerName)
        invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR_NAME_SET] invertedSet];
    else
        invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR_URL_SET] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
   
    if(string && [string length] > 0)
        return ![string isEqualToString:filtered];
    
    return YES;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0)
        {
            //TODO localize the label
            cell.textLabel.text = Localize(@"ServerName");
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];

            cell.accessoryView = _txtfServerName;
        }
        else
        {
            //TODO localize this label
            cell.textLabel.text = Localize(@"ServerUrl");
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            
            cell.accessoryView = _txtfServerUrl;
        }
    

    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];

    
    return cell;

}

@end


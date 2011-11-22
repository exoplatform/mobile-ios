//
//  ServerEditingViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/29/11.
//  Copyright 2011 home. All rights reserved.
//
#import <Three20/Three20.h>

#import "ServerEditingViewController.h"
#import "ServerAddingViewController.h"
#import "ServerManagerViewController.h"
#import "ServerPreferencesManager.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "URLAnalyzer.h"
#import "LanguageHelper.h"

static NSString *ServerObjCellIdentifier = @"ServerObj";


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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = Localize(@"ServerModify");
    //_bbtnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onBbtnEdit)];
    _bbtnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onBbtnDone)]; //It will be localized later
    [self.navigationItem setRightBarButtonItem:_bbtnEdit];
    
        
    _btnDelete = [[UIButton alloc] init];
    
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSRange range = [deviceName rangeOfString:@"iPad"];

    int marginLeft;
    
    if(range.length > 0)
        marginLeft = 32;
    else
        marginLeft = 10;

    [_btnDelete setFrame:CGRectMake(marginLeft, 10, self.navigationController.view.frame.size.width - marginLeft*2, 44)];
    //[_btnDelete setBackgroundColor:[UIColor redColor]];
    [_btnDelete setBackgroundImage:[[UIImage imageNamed:@"DeleteButton"]
                                    stretchableImageWithLeftCapWidth:5 topCapHeight:5]
                          forState:UIControlStateNormal];
    [_btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    [_btnDelete addTarget:self action:@selector(onBtnDelete) forControlEvents:UIControlEventTouchUpInside];
    
    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    //backgroundView.frame = self.view.frame;
    //self.tableView.backgroundView = backgroundView;
    //[backgroundView release];
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
    
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
    _strServerUrl = [URLAnalyzer parserURL:[_txtfServerUrl text]];
    
    if ([_delegate editServerObjAtIndex:_intIndex withSeverName:_strServerName andServerUrl:_strServerUrl]) [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBtnDelete
{
    [_txtfServerName resignFirstResponder];
    [_txtfServerUrl resignFirstResponder]; 
    if ([_delegate deleteServerObjAtIndex:_intIndex]) [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TextField methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_bbtnEdit setEnabled:YES];
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


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    [view addSubview:_btnDelete];
    
    return view;
    
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
            cell.textLabel.text = Localize(@"ServerName");
            
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            
            cell.accessoryView = _txtfServerName;
        }
        else
        {
            cell.textLabel.text = Localize(@"ServerUrl");
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            
            cell.accessoryView = _txtfServerUrl;
        }
    
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
}

@end



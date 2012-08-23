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
#import "defines.h"

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
        _txtfServerName = [[ServerAddingViewController textInputFieldForCellWithSecure:NO] retain];
        [_txtfServerName setReturnKeyType:UIReturnKeyNext];
        _txtfServerName.delegate = self;
        _txtfServerUrl = [[ServerAddingViewController textInputFieldForCellWithSecure:NO] retain];
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

    int marginLeft;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
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
    
    if ([_delegate editServerObjAtIndex:_intIndex withSeverName:[_txtfServerName text] andServerUrl:[_txtfServerUrl text]]) [self.navigationController popViewControllerAnimated:YES];
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
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textLabel.frame = CGRectMake(cell.indentationWidth, 0, cellBounds.size.width / 3, cellBounds.size.height);
        textLabel.tag = kServerEditCellTextlabelTag;
        [cell.contentView addSubview:textLabel];
    }
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:kServerEditCellTextlabelTag];
    if(indexPath.row == 0)
    {
        textLabel.text = Localize(@"ServerName");
        _txtfServerName.frame = CGRectMake(textLabel.frame.origin.x + textLabel.frame.size.width + 2., textLabel.frame.origin.y, cell.bounds.size.width - textLabel.frame.origin.x - textLabel.frame.size.width - 2., textLabel.frame.size.height);
        _txtfServerName.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:_txtfServerName];
    }
    else
    {
        textLabel.text = Localize(@"ServerUrl");    
        _txtfServerUrl.frame = CGRectMake(textLabel.frame.origin.x + textLabel.frame.size.width + 2., textLabel.frame.origin.y, cell.bounds.size.width - textLabel.frame.origin.x - textLabel.frame.size.width - 2., textLabel.frame.size.height);
        _txtfServerUrl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:_txtfServerUrl];
    }

    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
}

@end



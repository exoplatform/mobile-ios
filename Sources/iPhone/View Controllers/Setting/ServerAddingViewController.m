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
#import "defines.h"

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
    self.title = Localize(@"NewServer");
    [_txtfServerName release];
    _txtfServerName = [[ServerAddingViewController textInputFieldForCellWithSecure:NO] retain];
    [_txtfServerName setReturnKeyType:UIReturnKeyNext];
	_txtfServerName.delegate = self;
    
    [_txtfServerUrl release];
	_txtfServerUrl = [[ServerAddingViewController textInputFieldForCellWithSecure:NO] retain];
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
    
    //self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
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
    
    if ([_delegate addServerObjWithServerName:[_txtfServerName text] andServerUrl:[_txtfServerUrl text]]) [self.navigationController popViewControllerAnimated:YES];
}

+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure
{
    UITextField* textField = [[[UITextField alloc] initWithFrame:CGRectMake(120, 14, 190, 21)] autorelease];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    textField.placeholder = Localize(@"Required");
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

#define kServerAddCellTextLabelTag 10

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    CustomBackgroundForCell_iPhone *cell = (CustomBackgroundForCell_iPhone*)[tableView  dequeueReusableCellWithIdentifier:ServerObjCellIdentifier];
    if(cell == nil){
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServerObjCellIdentifier] autorelease];
        CGRect cellBounds = cell.bounds;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *textLabel = [[[UILabel alloc] init] autorelease];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor darkGrayColor];
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textLabel.frame = CGRectMake(cell.indentationWidth, 0, cellBounds.size.width / 3, cellBounds.size.height);
        textLabel.tag = kServerAddCellTextLabelTag;
        [cell.contentView addSubview:textLabel];
    }
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:kServerAddCellTextLabelTag];
    
    if(indexPath.row == 0)
    {
        //TODO localize the label
        textLabel.text = Localize(@"ServerName");
        _txtfServerName.frame = CGRectMake(textLabel.frame.origin.x + textLabel.frame.size.width + 2., textLabel.frame.origin.y, cell.bounds.size.width - textLabel.frame.origin.x - textLabel.frame.size.width - 2., textLabel.frame.size.height);
        _txtfServerName.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        [cell.contentView addSubview:_txtfServerName];
    }
    else
    {
        //TODO localize this label
        textLabel.text = Localize(@"ServerUrl");
        _txtfServerUrl.frame = CGRectMake(textLabel.frame.origin.x + textLabel.frame.size.width + 2., textLabel.frame.origin.y, cell.bounds.size.width - textLabel.frame.origin.x - textLabel.frame.size.width - 2., textLabel.frame.size.height);
        _txtfServerUrl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        [cell.contentView addSubview:_txtfServerUrl];
    }
    

    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];

    
    return cell;

}

@end


//
//  ServerAddingViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import "ServerAddingViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "URLAnalyzer.h"
#import "LanguageHelper.h"
#import "defines.h"

static NSString *ServerObjCellIdentifier = @"ServerObj";


@implementation ServerAddingViewController

@synthesize _txtfServerName;
@synthesize _txtfServerUrl;
@synthesize usernameTf = _usernameTf;
@synthesize passwordTf = _passwordTf;

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
    [_usernameTf release];
    [_passwordTf release];
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
    [self initTextFields];
    
    _bbtnDone = [[UIBarButtonItem alloc] initWithTitle:Localize(@"DoneButton") style:UIBarButtonItemStyleDone target:self action:@selector(onBbtnDone)];
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
    [_usernameTf resignFirstResponder];
    [_passwordTf resignFirstResponder];
    if ([_delegate addServerObjWithServerName:[_txtfServerName text] andServerUrl:[_txtfServerUrl text] withUsername:_usernameTf.text andPassword:_passwordTf.text]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure andRequired:(BOOL)isRequired
{
    UITextField* textField = [[[UITextField alloc] initWithFrame:CGRectMake(120, 14, 190, 21)] autorelease];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    textField.placeholder = isRequired ? Localize(@"Required") : Localize(@"Optional");
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
    
    if (theTextField == _txtfServerName) {
        [_txtfServerUrl becomeFirstResponder];
    } else if(theTextField == _txtfServerUrl) {
        [_usernameTf becomeFirstResponder];
    } else if(theTextField == _usernameTf) {
        [_passwordTf becomeFirstResponder];
    } else {
        [_passwordTf resignFirstResponder];
        _strServerName = [[_txtfServerName text] retain];
        _strServerUrl = [[_txtfServerUrl text] retain];
        [self onBbtnDone];
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
    return 2;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
    if(section == 1) {
        tmpStr = @"Your credentials";
    }
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
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            //TODO localize the label
            textLabel.text = Localize(@"ServerName");
            [self configureTextFields:_txtfServerName withTextLabel:textLabel inCell:cell];
        }
        else
        {
            //TODO localize this label
            textLabel.text = Localize(@"ServerUrl");
            [self configureTextFields:_txtfServerUrl withTextLabel:textLabel inCell:cell];
        }

    } else {
        if(indexPath.row == 0)
        {
            //TODO localize the label
            textLabel.text = Localize(@"Username");
            [self configureTextFields:_usernameTf withTextLabel:textLabel inCell:cell];
        }
        else
        {
            //TODO localize this label
            textLabel.text = Localize(@"Password");
            [self configureTextFields:_passwordTf withTextLabel:textLabel inCell:cell];
        }
    }
        

    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];

    
    return cell;

}

#pragma mark Text fields helper
- (void) initTextFields
{
    [_txtfServerName release];
    _txtfServerName = [[ServerAddingViewController textInputFieldForCellWithSecure:NO andRequired:YES] retain];
    [_txtfServerName setReturnKeyType:UIReturnKeyNext];
	_txtfServerName.delegate = self;
    
    [_txtfServerUrl release];
	_txtfServerUrl = [[ServerAddingViewController textInputFieldForCellWithSecure:NO andRequired:YES] retain];
    [_txtfServerUrl setReturnKeyType:UIReturnKeyNext];
    //Customize the style of the texfield
    _txtfServerUrl.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    _txtfServerUrl.adjustsFontSizeToFitWidth = YES;
	_txtfServerUrl.delegate = self;
    
    // credentials text fields
    [_usernameTf release];
    _usernameTf = [[ServerAddingViewController textInputFieldForCellWithSecure:NO andRequired:NO] retain];
    [_usernameTf setReturnKeyType:UIReturnKeyNext];
	_usernameTf.delegate = self;
    
    
    [_passwordTf release];
    _passwordTf = [[ServerAddingViewController textInputFieldForCellWithSecure:YES andRequired:NO] retain];
    [_passwordTf setReturnKeyType:UIReturnKeyDone];
	_passwordTf.delegate = self;
}


- (void)configureTextFields:(UITextField *)tf withTextLabel:(UILabel *)textLabel inCell:(UITableViewCell *)cell
{
    tf.frame = CGRectMake(textLabel.frame.origin.x + textLabel.frame.size.width + 2., textLabel.frame.origin.y, cell.bounds.size.width - textLabel.frame.origin.x - textLabel.frame.size.width - 2., textLabel.frame.size.height);
    tf.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [cell.contentView addSubview:tf];
}
@end


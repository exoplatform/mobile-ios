//
//  eXoAppViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "eXoAppViewController.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "CXMLDocument.h"
#import "eXoSettingViewController.h"
#import "eXoApplicationsViewController.h"
#import "Connection.h"
#import "DataProcess.h"
#import "NSString+HTML.h"

static NSString *CellIdentifier = @"MyIdentifier";

@implementation eXoAppViewController

@synthesize _txtfUserName;
@synthesize _txtfUserPasswd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		_bSuccessful = [[NSString alloc] init];
		_bSuccessful = NO;
		_selectedLanguage = 0;
		btnSignIn = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(onSignInBtn:)];
		UIButton *btnTmp = [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 30, 30)];
		[btnTmp addTarget:self action:@selector(onSettingBtn) forControlEvents:UIControlEventTouchUpInside];
		[btnTmp setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
		btnSetting = [[UIBarButtonItem alloc] initWithCustomView:btnTmp];
		
		isFirstTimeLogin = YES;
		
    }
    return self;
}

- (void)loadView 
{
	[super loadView];
	
	[[self navigationItem] setRightBarButtonItem:btnSignIn];
	[[self navigationItem] setLeftBarButtonItem:btnSetting];
	
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	//[self viewWillAppear:NO];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	_bSuccessful = NO;
	
}

- (void)viewWillAppear:(BOOL)animated
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(_selectedLanguage == 0)
	{
		filePath = [[[NSBundle mainBundle] pathForResource:@"Localize_EN" ofType:@"xml"] retain];
	}	
	else
	{	
		filePath = [[[NSBundle mainBundle] pathForResource:@"Localize_FR" ofType:@"xml"] retain];
	}	
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	[[self navigationItem] setTitle:[_dictLocalize objectForKey:@"SignInPageTitle"]];	
	
	[btnSignIn setTitle:[_dictLocalize objectForKey:@"SignInButton"]];

	bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];

	_txtfDomainName = [eXoAppViewController textInputFieldForCellWithSecure:NO];
	_txtfDomainName.delegate = self;
	_txtfUserName = [eXoAppViewController textAccountInputFieldForCellWithSecure:NO];
	_txtfUserName.delegate = self;
	_txtfUserPasswd = [eXoAppViewController textAccountInputFieldForCellWithSecure:YES];
	_txtfUserPasswd.delegate = self; 

	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	if(domain)
	{
		[_txtfDomainName setText:domain];
	}
	
	
	if(bRememberMe || bAutoLogin)
	{
		NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
		NSString* password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
		if(username)
		{
			[_txtfUserName setText:username];
		}
		
		if(password)
		{
			[_txtfUserPasswd setText:password];
		}
	}
	else 
	{
		[_txtfUserName setText:@""];
		[_txtfUserPasswd setText:@""];
		
		[_txtfUserName becomeFirstResponder];
	}
	
	[self.tableView reloadData];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	if(domain)
	{
		[_txtfDomainName setText:domain];
	}
	
	NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]; 
	if(username)
	{
		[_txtfUserName setText:username];
	}
	
	if (_txtfUserName.text.length == 0 && _txtfUserPasswd.text.length == 0) 
	{
		[_txtfUserName becomeFirstResponder];
	}
	
	if (_txtfUserName.text.length > 0)
	{
		[_txtfUserPasswd becomeFirstResponder];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	isFirstTimeLogin = NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	switch (section) 
	{
		case 0:
		{
			tmpStr = [_dictLocalize objectForKey:@"DomainHeader"];
			break;
		}
			
		case 1:
		{
			tmpStr = [_dictLocalize objectForKey:@"AccountHeader"];			
			break;
		}
			
		default:
			break;
	}
	
	return tmpStr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	int numberOfRowsInSection = 0;
	
	switch (section) 
	{
		case 0:
		{
			numberOfRowsInSection = 1;
			break;
		}
		case 1:
		{
			numberOfRowsInSection = 2;
			break;
		}
		case 2:
		{
			numberOfRowsInSection = 2;
			break;
		}
		default:
			break;
	}
	
	return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 32.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) 
        {
            case 0:
            {
                cell.textLabel.text = [_dictLocalize objectForKey:@"DomainCellTitle"];
                
                [cell addSubview:_txtfDomainName];
                
                break;
            }
            case 1:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        cell.textLabel.text = [_dictLocalize objectForKey:@"UserNameCellTitle"];
                        [cell addSubview:_txtfUserName];
                        break;
                    }	
                    case 1:
                    {
                        cell.textLabel.text = [_dictLocalize objectForKey:@"PasswordCellTitle"];
                        [cell addSubview:_txtfUserPasswd];
                        
                        break;
                    }
                }
                
                break;
            }
                
            default:
                break;
        }
    }
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {	
	if(indexPath.section == 0 && !isFirstTimeLogin) {
		cell.userInteractionEnabled = NO;
		[cell setBackgroundColor:[UIColor cyanColor]];
	}
	
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	return YES;
}


+ (UITextField*)textInputFieldForCellWithSecure:(BOOL)secure 
{
	UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 6, 200, 25)];
	textField.placeholder = @"Required";
	textField.secureTextEntry = secure;
	textField.keyboardType = UIKeyboardTypeASCIICapable;
	textField.returnKeyType = UIReturnKeyDone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	return textField;
}

+ (UITextField*)textAccountInputFieldForCellWithSecure:(BOOL)secure 
{
	UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(135, 6, 170, 25)];
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
	if ((theTextField == _txtfUserName) || (theTextField == _txtfUserPasswd))
	{
		[theTextField resignFirstResponder];
	}
	return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched.
    [_txtfUserName resignFirstResponder];
    [_txtfUserPasswd resignFirstResponder];	
    [super touchesBegan:touches withEvent:event];
}

-(void)login
{
	[[self navigationItem] setRightBarButtonItem:nil];
	[self view].userInteractionEnabled = NO;
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	[_indicator startAnimating];
	_indicator.hidesWhenStopped = YES;

	[_txtfDomainName resignFirstResponder];
	[_txtfUserName resignFirstResponder];
	[_txtfUserPasswd resignFirstResponder];
	
	
	NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
	endThread = [[NSThread alloc] initWithTarget:self selector:@selector(signInProgress) object:nil];
	[endThread start];
	
	[startThread release];
	
}

-(IBAction)onSettingBtn
{
	eXoApplicationsViewController *apps = [[eXoApplicationsViewController alloc] init];
	apps._dictLocalize = _dictLocalize;
	eXoSettingViewController *setting = [[eXoSettingViewController alloc] initWithStyle:UITableViewStyleGrouped delegate:apps];

	[self.navigationController pushViewController:setting animated:YES];
	
}

- (IBAction)onSignInBtn:(id)sender
{
	if([_txtfUserName.text isEqualToString:@""])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"Authorization"]
														message:[_dictLocalize objectForKey:@"UserNameEmpty"]
													   delegate:self 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
	}
	else
	{		
		NSString *domainStr = [_txtfDomainName text];
		NSRange httpRange = [domainStr rangeOfString:@"http://"];
		if(httpRange.length == 0)
			_txtfDomainName.text = [NSString stringWithFormat:@"http://%@", domainStr];
		
		[self login];
	}
}

-(void)loginSuccess
{
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	[appDelegate changeToActivityStreamsViewController:_dictLocalize];
	
	endThread = nil;
	[endThread release];
	
}

-(void)loginFailed
{
	endThread = nil;
	[endThread release];
	[self view].userInteractionEnabled = YES;
	[[self navigationItem] setRightBarButtonItem:btnSignIn];
	[[self navigationItem] setLeftBarButtonItem:btnSetting];
}

-(void)startInProgress {
	 
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
	[[self navigationItem] setRightBarButtonItem:progressBtn];
	[pool release];
}

- (void)signInProgress
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	Connection* conn = [[Connection alloc] init];
	
	NSString* domain = [_txtfDomainName text];
	NSString* username = [_txtfUserName text];
	NSString* password = [_txtfUserPasswd text];
		
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:domain forKey:EXO_PREFERENCE_DOMAIN];
	[userDefaults setObject:username forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:password forKey:EXO_PREFERENCE_PASSWORD];	
	
	_bSuccessful = [conn sendAuthenticateRequest:domain username:username password:password];
	
	if(_bSuccessful == @"YES")
	{
		[self performSelectorOnMainThread:@selector(loginSuccess) withObject:nil waitUntilDone:NO];
	}
	else if(_bSuccessful == @"NO")
	{
		//[_indicator stopAnimating];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"Authorization"]
														 message:[_dictLocalize objectForKey:@"WrongUserNamePassword"]
														delegate:self 
											   cancelButtonTitle:@"OK"
											   otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(loginFailed) withObject:nil waitUntilDone:NO];		
	}
	else if(_bSuccessful == @"ERROR")
	{
		//[_indicator stopAnimating];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"NetworkConnection"]
														 message:[_dictLocalize objectForKey:@"NetworkConnectionFailed"]
														delegate:self 
											   cancelButtonTitle:@"OK"
											   otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(loginFailed) withObject:nil waitUntilDone:NO];
		//[[self navigationItem] setRightBarButtonItem:signInBtn];				
	}
	
	[pool release];

	
}
	
- (void)dealloc 
{
	[_txtfUserName release];
	[_txtfUserPasswd release];
	[_txtfDomainName release];
	
    [super dealloc];	
}

@end


//--------------------------------------------
@implementation ContainerCell

- (void)attachContainer:(UIView*)view 
{
//	[_vContainer removeFromSuperview];
//	[_vContainer release];
//	_vContainer = [view retain];
	[self addSubview:view];
}

@end


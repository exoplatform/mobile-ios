//
//  eXoAppViewController.m
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "eXoAppViewController.h"
#import "eXoAppAppDelegate.h"
#import "defines.h"
#import "eXoAccount.h"
#import "CXMLDocument.h"
#import "eXoSetting.h"
#import "eXoApplicationsViewController.h"


@implementation eXoAppViewController

@synthesize _txtfUserName;
@synthesize _txtfUserPasswd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
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
		
    }
    return self;
}

- (void)loadView 
{
	[super loadView];
	
	[[self navigationItem] setRightBarButtonItem:btnSignIn];
	[[self navigationItem] setLeftBarButtonItem:btnSetting];
	
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	
	_txtfDomainName = [eXoAppViewController textInputFieldForCellWithSecure:NO];
	_txtfDomainName.delegate = self;
	_txtfUserName = [eXoAppViewController textAccountInputFieldForCellWithSecure:NO];
	_txtfUserName.delegate = self;
	_txtfUserPasswd = [eXoAppViewController textAccountInputFieldForCellWithSecure:YES];
	_txtfUserPasswd.delegate = self; 
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* domain = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	if(domain)
	{
		[_txtfDomainName setText:domain];
	}
	
	[self viewWillAppear:NO];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	_bSuccessful = NO;
	
}

- (void)viewWillAppear:(BOOL)animated
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_selectedLanguage = [[userDefaults objectForKey:EXO_LANGUAGE] intValue];
	NSString* filePath;
	if(_selectedLanguage == 0)
	{
		filePath = [[[NSBundle mainBundle] pathForResource:@"LocalizeEN" ofType:@"xml"] retain];
	}	
	else
	{	
		filePath = [[[NSBundle mainBundle] pathForResource:@"LocalizeFR" ofType:@"xml"] retain];
	}	
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	[[self navigationItem] setTitle:[_dictLocalize objectForKey:@"SignInPageTitle"]];	
	
	[btnSignIn setTitle:[_dictLocalize objectForKey:@"SignInButton"]];

	bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];

	
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

- (void)viewDidAppear:(BOOL)animated
{
	
}

- (void)dealloc 
{
	[_txtfUserName release];
	[_txtfUserPasswd release];
	[_txtfDomainName release];
	[_txtfDomainName1 release];
	
    [super dealloc];	
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
			//tmpStr = @"Please input domain name:";
			tmpStr = [_dictLocalize objectForKey:@"DomainHeader"];
			break;
		}
			
		case 1:
		{
			//tmpStr = @"Sign In with an eXo account:";
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
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	switch (indexPath.section) 
	{
		case 0:
		{
			UILabel* domainNameLabel = [[UILabel alloc] init];
			domainNameLabel.text = [_dictLocalize objectForKey:@"DomainCellTitle"];			
			//domainNameLabel.text = @"Domain";
			return [self containerCellWithLabel:domainNameLabel view:_txtfDomainName];
			break;
		}
				
		case 1:
		{
			switch (indexPath.row)
			{
				case 0:
				{
					UILabel* userNameLabel = [[UILabel alloc] init];
					//userNameLabel.text = @"UserName";
					userNameLabel.text = [_dictLocalize objectForKey:@"UserNameCellTitle"];
					return [self containerCellWithLabel:userNameLabel view:_txtfUserName];
					break;
				}	
				case 1:
				{
					UILabel* userPswdLabel = [[UILabel alloc] init];
					//userPswdLabel.text = @"Password";
					userPswdLabel.text = [_dictLocalize objectForKey:@"PasswordCellTitle"];
					return [self containerCellWithLabel:userPswdLabel view:_txtfUserPasswd];
					
					break;
				}
			}
			
			break;
		}
			
		default:
			break;
	}
		
	return cell;
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
	
	//[self performSelectorOnMainThread:@selector(signInProgress) withObject:nil waitUntilDone:NO];
	endThread = [[NSThread alloc] initWithTarget:self selector:@selector(signInProgress) object:nil];
	[endThread start];
	//[NSThread detachNewThreadSelector:@selector(signInProgress) toTarget:self withObject:nil];
	[startThread release];
	
}

-(IBAction)onSettingBtn
{
	eXoApplicationsViewController *apps = [[eXoApplicationsViewController alloc] init];
	apps._dictLocalize = _dictLocalize;
	eXoSetting *setting = [[eXoSetting alloc] initWithStyle:UITableViewStyleGrouped delegate:apps];

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
	eXoAppAppDelegate *appDelegate = (eXoAppAppDelegate *)[[UIApplication sharedApplication] delegate];
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
	
	eXoUserClient* exoUserClient = [eXoUserClient instance];
	
	NSString* domain = [_txtfDomainName text];
	NSString* username = [_txtfUserName text];
	NSString* password = [_txtfUserPasswd text];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:domain forKey:EXO_PREFERENCE_DOMAIN];
	[userDefaults setObject:username forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:password forKey:EXO_PREFERENCE_PASSWORD];	
	
	_bSuccessful = [exoUserClient signInDomain:domain withUserName:username password:password];
	
	
	//[[self navigationItem] setRightBarButtonItem:signInBtn];
	
	if(_bSuccessful == @"YES")
	{
		//[_indicator stopAnimating];
		eXoAccount* account = [eXoAccount instance];
		if(account)
		{
			[account setUsername:username];
			[account setPassword:password];
		}
		
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
	

@end


//--------------------------------------------
@implementation ContainerCell

- (void)attachContainer:(UIView*)view 
{
	[_vContainer removeFromSuperview];
	[_vContainer release];
	_vContainer = [view retain];
	[self addSubview:view];
}

@end


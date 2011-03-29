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
#import "Configuration.h"

static NSString *CellIdentifier = @"MyIdentifier";

@implementation eXoAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
		_bSuccessful = [[NSString alloc] init];
		_bSuccessful = NO;
		_selectedLanguage = 0;
        _intSelectedServer = -1;
        _arrServerList = [[NSMutableArray alloc] init];
		isFirstTimeLogin = YES;
    }
    return self;
}

- (void)loadView 
{
	[super loadView];
	self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	_bSuccessful = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    Configuration* configuration = [Configuration sharedInstance];
    _arrServerList = [configuration getServerList];
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(_selectedLanguage == 0)
	{
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_EN" ofType:@"xml"];
	}	
	else
	{	
		filePath = [[NSBundle mainBundle] pathForResource:@"Localize_FR" ofType:@"xml"];
	}	
	
	_dictLocalize = [[NSDictionary alloc] initWithContentsOfFile:filePath];
	[[self navigationItem] setTitle:[_dictLocalize objectForKey:@"SignInPageTitle"]];	
	
	_intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];

	bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];

	_strHost = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	
	if(bRememberMe || bAutoLogin)
	{
		NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
		NSString* password = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
		if(username)
		{
			[_txtfUsername setText:username];
		}
		
		if(password)
		{
			[_txtfPassword setText:password];
		}
	}
	else 
	{
		[_txtfUsername setText:@""];
		[_txtfPassword setText:@""];
	}
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
	_strHost = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	
	NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]; 
	if(username)
	{
		[_txtfUsername setText:username];
	}
	
	if (_txtfUsername.text.length == 0 && _txtfPassword.text.length == 0) 
	{
		[_txtfUsername becomeFirstResponder];
	}
	
	if (_txtfUsername.text.length > 0)
	{
		[_txtfPassword becomeFirstResponder];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	isFirstTimeLogin = NO;
}

- (IBAction)onBtnAccount:(id)sender
{
    [_btnServerList setBackgroundColor:[UIColor grayColor]];
    [_btnAccount setBackgroundColor:[UIColor blueColor]];
    [_vLoginView bringSubviewToFront:_vAccountView];
}

- (IBAction)onBtnServerList:(id)sender
{
    [_btnServerList setBackgroundColor:[UIColor blueColor]];
    [_btnAccount setBackgroundColor:[UIColor grayColor]];    
    [_vLoginView bringSubviewToFront:_vServerListView];    
    [_tbvlServerList reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	return YES;
}

#pragma UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    return [_arrServerList count];
}
	
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    if (indexPath.row == _intSelectedServer) 
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
	ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];

    UILabel* lbServerName = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 150, 30)];
    lbServerName.text = tmpServerObj._strServerName;
    lbServerName.textColor = [UIColor brownColor];
    [cell addSubview:lbServerName];
    [lbServerName release];

    UILabel* lbServerUrl = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 120, 30)];
    lbServerUrl.text = tmpServerObj._strServerUrl;
    [cell addSubview:lbServerUrl];
    [lbServerUrl release];

	return cell;
            }
                

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    _strHost = [tmpServerObj._strServerUrl retain];
    _intSelectedServer = indexPath.row;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_strHost forKey:EXO_PREFERENCE_DOMAIN];
	[userDefaults setObject:[NSString stringWithFormat:@"%d",_intSelectedServer] forKey:EXO_PREFERENCE_SELECTED_SEVER];
    [_tbvlServerList reloadData];
}
	

- (void)login
{
	[[self navigationItem] setRightBarButtonItem:nil];
	[self view].userInteractionEnabled = NO;
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	[_indicator startAnimating];
	_indicator.hidesWhenStopped = YES;

	[_txtfUsername resignFirstResponder];
	[_txtfPassword resignFirstResponder];
	
	
	NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
	endThread = [[NSThread alloc] initWithTarget:self selector:@selector(signInProgress) object:nil];
	[endThread start];
	
	[startThread release];
	
}

- (IBAction)onSettingBtn
{
	eXoApplicationsViewController *apps = [[eXoApplicationsViewController alloc] init];
	apps._dictLocalize = _dictLocalize;
	eXoSettingViewController *setting = [[eXoSettingViewController alloc] initWithStyle:UITableViewStyleGrouped delegate:apps];

	[self.navigationController pushViewController:setting animated:YES];
	
}

- (IBAction)onSignInBtn:(id)sender
{
	if([_txtfUsername.text isEqualToString:@""])
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
		NSRange httpRange = [_strHost rangeOfString:@"http://"];
		if(httpRange.length == 0)
        {
			_strHost = [NSString stringWithFormat:@"http://%@", _strHost];
		}
		[self login];
	}
}

- (void)loginSuccess
{
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	[appDelegate changeToActivityStreamsViewController:_dictLocalize];
	
	endThread = nil;
	[endThread release];
}

- (void)loginFailed
{
	endThread = nil;
	[endThread release];
	[self view].userInteractionEnabled = YES;
}

- (void)startInProgress 
{	 
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
	[[self navigationItem] setRightBarButtonItem:progressBtn];
	[pool release];
}

- (void)signInProgress
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	Connection* conn = [[Connection alloc] init];
	
	NSString* username = [_txtfUsername text];
	NSString* password = [_txtfPassword text];
		
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:username forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:password forKey:EXO_PREFERENCE_PASSWORD];	
	
	_bSuccessful = [conn sendAuthenticateRequest:_strHost username:username password:password];
	
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
	[_txtfUsername release];
	[_txtfPassword release];
	[_arrServerList release];
    [super dealloc];	
}

@end



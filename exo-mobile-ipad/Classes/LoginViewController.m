//
//  LoginViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import "LoginViewController.h"
#import "eXoMobileViewController.h"
#import "Checkbox.h"
#import "defines.h"
#import "Connection.h"
#import "SettingViewController.h"
#import "SupportViewController.h"

@implementation LoginViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		// Custom initialization
//		_btnSetting = [[UIButton alloc] init];
//		[_btnSetting setBackgroundImage:[UIImage imageNamed:@"SettingBtn.png"] forState:UIControlStateNormal];
//		[_btnSetting addTarget:self action:@selector(onSettingBtn:) forControlEvents:UIControlEventTouchDown];
//		[[self view] addSubview:_btnSetting];
		
		_settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
		[_settingViewController setDelegate:self];
		_bDismissSettingView = NO;
		
		_lbHelpTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 40)];
		[_lbHelpTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
		[_lbHelpTitle setText:@"eXoMobile"];
		
		_wvHelp = [[UIWebView alloc] init];
		_wvHelp.scalesPageToFit = YES;
		
		_btnHelpClose = [[UIButton alloc] init];
		[_btnHelpClose setBackgroundImage:[UIImage imageNamed:@"CloseBtn.png"] forState:UIControlStateNormal];
		[_btnHelpClose addTarget:self action:@selector(onCloseBtn:) forControlEvents:UIControlEventTouchDown];

		_cbxRememberMe = [[Checkbox alloc] initWithFrame:CGRectMake(280, 280, 20, 20) andState:NO];
		[_cbxRememberMe setDelegate:self];
		[[self view] addSubview:_cbxRememberMe];
		
		_cbxAutoSignIn = [[Checkbox alloc] initWithFrame:CGRectMake(280, 320, 20, 20) andState:NO];
		[_cbxAutoSignIn setDelegate:self];
		[[self view] addSubview:_cbxAutoSignIn];
		
		_strHost = @"";
		_strUsername = @"";
		_strPassword = @"";
		
		_bMoveUp = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(myKeyboardWillHideHandler:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[_actiSigningIn setHidden:YES];
	[_lbSigningInStatus setHidden:YES];
	_txtfHost.clearButtonMode = UITextFieldViewModeWhileEditing;
	_txtfUsername.clearButtonMode = UITextFieldViewModeWhileEditing;
	_txtfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	_strHost = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	[_txtfHost setText:_strHost];
	
	NSString* strAutoSignIn = [userDefaults objectForKey:EXO_AUTO_SIGIN];
	
	if([strAutoSignIn isEqualToString:@"YES"])
	{
		[_cbxAutoSignIn setStatus:YES];
		[self setPreferenceValues];
		[self onSignInBtn:self];
	}
	else 
	{
		[_cbxAutoSignIn setStatus:NO];
		NSString* strRememberMe = [userDefaults objectForKey:EXO_REMEMBER_ME];
		if([strRememberMe isEqualToString:@"YES"])
		{
			[_cbxRememberMe setStatus:YES];
			[self setPreferenceValues];
		}
		else 
		{
			[_cbxRememberMe setStatus:NO];
		}
	}
}

- (void)setPreferenceValues
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];

	_strUsername = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]; 
	if(_strUsername)
	{
		[_txtfUsername setText:_strUsername];
		[_txtfUsername resignFirstResponder];
	}
	
	_strPassword = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD]; 
	if(_strPassword)
	{
		[_txtfPassword setText:_strPassword];
		[_txtfPassword resignFirstResponder];
	}
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
	_intSelectedLanguage = [_delegate getSelectedLanguage];

//	if (_intSelectedLanguage == 0) 
//	{
//		[_btnSetting setBackgroundImage:[UIImage imageNamed:@"EN.gif"] forState:UIControlStateNormal];
//	}
//	else if (_intSelectedLanguage == 1) 
//	{
//		[_btnSetting setBackgroundImage:[UIImage imageNamed:@"FR.gif"] forState:UIControlStateNormal];
//	}
//	else if (_intSelectedLanguage == 2) 
//	{
//		[_btnSetting setBackgroundImage:[UIImage imageNamed:@"VN.gif"] forState:UIControlStateNormal];
//	}
	
	[_lbHostInstruction setText:[_dictLocalize objectForKey:@"DomainHeader"]];
	[_lbHost setText:[_dictLocalize objectForKey:@"DomainCellTitle"]];
	[_lbAccountInstruction setText:[_dictLocalize objectForKey:@"AccountHeader"]];
	[_lbRememberMe setText:[_dictLocalize objectForKey:@"RememberMe"]];
	[_lbAutoSignIn setText:[_dictLocalize objectForKey:@"AutoLogin"]];
	[_btnSignIn setTitle:[_dictLocalize objectForKey:@"SignInButton"] forState:UIControlStateNormal];
	[_btnSetting setTitle:[_dictLocalize objectForKey:@"Language"] forState:UIControlStateNormal];
	[_lbSigningInStatus setText:[_dictLocalize objectForKey:@"SigningIn"]];
						   
	[_settingViewController localize];
}

- (void)setSelectedLanguage:(int)languageId
{
	[_delegate setSelectedLanguage:languageId];
}

- (int)getSelectedLanguage
{
	return _intSelectedLanguage;
}

- (NSDictionary*)getLocalization
{
	return _dictLocalize;
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
		[[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBgPortrail.png"]]];
		[_btnLogo setFrame:CGRectMake(284, 192, 200, 85)];
		[_lbHostInstruction setFrame:CGRectMake(204, 285, 360, 21)];
		[_btnHost setFrame:CGRectMake(204, 314, 360, 46)];
		[_txtfHost setFrame:CGRectMake(220, 314, 325, 46)];
		[_lbAccountInstruction setFrame:CGRectMake(204, 383, 360, 21)];
		[_btnUsername setFrame:CGRectMake(204, 418, 360, 46)];
		[_txtfUsername setFrame:CGRectMake(213, 418, 341, 46)];
		[_btnPassword setFrame:CGRectMake(204, 472, 360, 46)];
		[_txtfPassword setFrame:CGRectMake(213, 472, 341, 46)];
		
		[_cbxRememberMe setFrame:CGRectMake(224, 531, 21, 21)];
		[_lbRememberMe setFrame:CGRectMake(249, 531, 160, 21)];
		[_cbxAutoSignIn setFrame:CGRectMake(419, 531, 21, 21)];
		[_lbAutoSignIn setFrame:CGRectMake(444, 531, 150, 21)];
		
		[_btnSignIn setFrame:CGRectMake(335, 565, 110, 37)];
		[_actiSigningIn setFrame:CGRectMake(320, 565, 37, 37)];
		[_lbSigningInStatus setFrame:CGRectMake(373, 573, 170, 21)];
		
		[_wvHelp setFrame:CGRectMake(0, 80, 768, 924)];
		[_btnHelp setFrame:CGRectMake(448, 20, 140, 32)];
		[_btnHelpClose setFrame:CGRectMake(717, 20, 31, 31)];
		[_btnSetting setFrame:CGRectMake(608, 20, 140, 32)];
	}
	
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
		[[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBgLandscape.png"]]];
		[_btnLogo setFrame:CGRectMake(412, 137, 200, 85)];		
		[_lbHostInstruction setFrame:CGRectMake(332, 285 - 60, 360, 21)];
		[_btnHost setFrame:CGRectMake(332, 314 - 65, 360, 46)];
		[_txtfHost setFrame:CGRectMake(348, 314 - 65, 325, 46)];
		[_lbAccountInstruction setFrame:CGRectMake(332, 383 - 75, 360, 21)];
		[_btnUsername setFrame:CGRectMake(332, 418 - 85, 360, 46)];
		[_txtfUsername setFrame:CGRectMake(341, 418 - 85, 341, 46)];
		[_btnPassword setFrame:CGRectMake(332, 472 - 85, 360, 46)];
		[_txtfPassword setFrame:CGRectMake(341, 472 - 85, 341, 46)];
		
		[_cbxRememberMe setFrame:CGRectMake(352, 531 - 85, 21, 21)];
		[_lbRememberMe setFrame:CGRectMake(377, 531 - 85, 160, 21)];
		[_cbxAutoSignIn setFrame:CGRectMake(547, 531 - 85, 21, 21)];
		[_lbAutoSignIn setFrame:CGRectMake(572, 531 - 85, 150, 21)];
		
		[_btnSignIn setFrame:CGRectMake(463, 565 - 85, 110, 37)];
		[_actiSigningIn setFrame:CGRectMake(448, 565 - 85, 37, 37)];
		[_lbSigningInStatus setFrame:CGRectMake(511, 573 - 85, 170, 21)];
		
		[_wvHelp setFrame:CGRectMake(0, 80, 768, 924)];
		[_btnHelp setFrame:CGRectMake(704, 20, 140, 32)];
		[_btnHelpClose setFrame:CGRectMake(717, 20, 31, 31)];
		[_btnSetting setFrame:CGRectMake(864, 20, 140, 32)];	
	}
	
	if(_supportViewController)
	{
		[_supportViewController changeOrientation:interfaceOrientation];
	}
	
	_interfaceOrientation = interfaceOrientation;
	[_txtfHost resignFirstResponder];
	[_txtfUsername resignFirstResponder];
	[_txtfPassword resignFirstResponder];
}

- (IBAction)onHostInput:(id)sender
{
	if(!_bMoveUp && ((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight)))
	{
		[self moveUIControls:-130];
	}
}

- (IBAction)onUsernameInput:(id)sender
{
	if(!_bMoveUp && ((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight)))
	{
		[self moveUIControls:-130];
	}
}

- (IBAction)onPasswordInput:(id)sender
{
	if(!_bMoveUp && ((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight)))
	{
		[self moveUIControls:-130];
	}
}

- (void)moveUIControls:(int)intOffset
{
	[_btnLogo setFrame:CGRectMake(412, 137 + intOffset, 200, 85)];
	[_lbHostInstruction setFrame:CGRectMake(332, 285 - 60 + intOffset, 360, 21)];
	[_btnHost setFrame:CGRectMake(332, 314 - 65 + intOffset, 360, 46)];
	[_txtfHost setFrame:CGRectMake(348, 314 - 65 + intOffset, 325, 46)];
	[_lbAccountInstruction setFrame:CGRectMake(332, 383 - 75 + intOffset, 360, 21)];
	[_btnUsername setFrame:CGRectMake(332, 418 - 85 + intOffset, 360, 46)];
	[_txtfUsername setFrame:CGRectMake(341, 418 - 85 + intOffset, 341, 46)];
	[_btnPassword setFrame:CGRectMake(332, 472 - 85 + intOffset, 360, 46)];
	[_txtfPassword setFrame:CGRectMake(341, 472 - 85 + intOffset, 341, 46)];
	
	[_cbxRememberMe setFrame:CGRectMake(352, 531 - 85 + intOffset, 21, 21)];
	[_lbRememberMe setFrame:CGRectMake(377, 531 - 85 + intOffset, 160, 21)];
	[_cbxAutoSignIn setFrame:CGRectMake(547, 531 - 85 + intOffset, 21, 21)];
	[_lbAutoSignIn setFrame:CGRectMake(572, 531 - 85 + intOffset, 150, 21)];
	
	[_btnSignIn setFrame:CGRectMake(463, 565 - 85 + intOffset, 110, 37)];
	[_actiSigningIn setFrame:CGRectMake(448, 565 - 85 + intOffset, 37, 37)];
	[_lbSigningInStatus setFrame:CGRectMake(511, 573 - 85 + intOffset, 170, 21)];	
	//[_wvHelp setFrame:CGRectMake(0, 80 + intOffset, 1024, 668)];
	//[_btnHelp setFrame:CGRectMake(908, 20 + intOffset, 31, 31)];
	//[_btnHelpClose setFrame:CGRectMake(973, 20 + intOffset, 31, 31)];
	//[_btnSetting setFrame:CGRectMake(959, 20 + intOffset, 45, 31)];	
	
	if (intOffset < 0) 
	{
		_bMoveUp = YES;
	}
	else 
	{
		_bMoveUp = NO;
	}
}

- (void) myKeyboardWillHideHandler:(NSNotification *)notification 
{
	if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{
		if(_bMoveUp)
		{
			[self moveUIControls:0];
		}		
	}
}

- (IBAction)onSettingBtn:(id)sender
{
	popoverController = [[UIPopoverController alloc] initWithContentViewController:_settingViewController];
	[popoverController setPopoverContentSize:CGSizeMake(320, 106) animated:YES];
	[popoverController presentPopoverFromRect:[_btnSetting frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	[popoverController dismissPopoverAnimated:YES];
    return YES;
}

- (IBAction)onHelpBtn:(id)sender
{	
//	[_lbHelpTitle removeFromSuperview];
//	[_btnHelp removeFromSuperview];
//	[_wvHelp removeFromSuperview];
//	[_btnHelpClose removeFromSuperview];
//	[_btnSetting removeFromSuperview];
//	[[self view] addSubview:_wvHelp];
//	[[self view] addSubview:_btnHelpClose];
//	[[self view] addSubview:_lbHelpTitle];
//	_urlHelp = [NSURLRequest requestWithURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"HowtoUse-EN" ofType:@"htm"]]];
//	[_wvHelp loadRequest:_urlHelp];

	if (_supportViewController == nil)
	{
		_supportViewController = [[SupportViewController alloc] initWithNibName:@"SupportViewController" bundle:nil];
		_supportViewController.view.frame = self.view.frame;
		[_supportViewController setDelegate:self];
		[[self view] addSubview:[_supportViewController view]];
	}
	else 
	{
		[[self view] addSubview:[_supportViewController view]];
	}
	[_supportViewController changeOrientation:_interfaceOrientation];
}

- (IBAction)onCloseBtn:(id)sender
{
	[[_supportViewController view] removeFromSuperview];
//	[_lbHelpTitle removeFromSuperview];	
//	[_wvHelp removeFromSuperview];
//	[_btnHelpClose removeFromSuperview];
//	[[self view] addSubview:_btnHelp];
//	[[self view] addSubview:_btnSetting];
}

/*
- (void)onCheckBoxBtn:(Checkbox*)checkbox
{
	if(checkbox == _cbxRememberMe)
	{
		_bRememberMe == [checkbox getStatus];
	}
	if(checkbox == _cbxAutoSignIn)
	{
		_bAutoSignIn = [checkbox getStatus];
	}
}
*/

- (IBAction)onSignInBtn:(id)sender
{
	[_txtfHost resignFirstResponder];
	[_txtfUsername resignFirstResponder];
	[_txtfPassword resignFirstResponder];
	
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
		_strHost = [_txtfHost text];
		NSRange range = [_strHost rangeOfString:@"http://"];
		if(range.length == 0)
		{
			_txtfHost.text = [NSString stringWithFormat:@"http://%@", _strHost];
		}
		[self doSignIn];
	}
}

- (void)doSignIn
{
	[_btnSignIn setHidden:YES];
	[_actiSigningIn setHidden:NO];
	[_lbSigningInStatus setHidden:NO];
	[_actiSigningIn startAnimating];
	[NSThread detachNewThreadSelector:@selector(startSignInProgress) toTarget:self withObject:nil];
}

- (void)startSignInProgress 
{  	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_strHost = [_txtfHost text];
	_strUsername = [_txtfUsername text];
	_strPassword = [_txtfPassword text];
	
	NSString* strResult = [[_delegate _connection] sendAuthenticateRequest:_strHost username:_strUsername password:_strPassword];
	
	//NSString* strResult = @"YES";
	
	UIAlertView* alert;
	
	if(strResult == @"YES")
	{
		[self performSelectorOnMainThread:@selector(signInSuccesfully) withObject:nil waitUntilDone:NO];  
	}
	else if(strResult == @"NO")
	{
		alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"Authorization"]
														message:[_dictLocalize objectForKey:@"WrongUserNamePassword"]
													   delegate:self 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(signInFailed) withObject:nil waitUntilDone:NO];		
		
	}
	else if(strResult == @"ERROR")
	{
		alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"NetworkConnection"]
														message:[_dictLocalize objectForKey:@"NetworkConnectionFailed"]
													   delegate:self 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(signInFailed) withObject:nil waitUntilDone:NO];  
	}

    [pool release];
}

- (void)signInSuccesfully
{
	[_actiSigningIn stopAnimating];
	[_actiSigningIn setHidden:YES];
	[_lbSigningInStatus setHidden:YES];
	[_btnSignIn setHidden:NO];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:_strHost forKey:EXO_PREFERENCE_DOMAIN];
	[userDefaults setObject:_strUsername forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:_strPassword forKey:EXO_PREFERENCE_PASSWORD];

	
	_bRememberMe = [_cbxRememberMe getStatus];
	if(_bRememberMe)
	{
		//[userDefaults setObject:_strHost forKey:EXO_PREFERENCE_DOMAIN];
		//[userDefaults setObject:_strUsername forKey:EXO_PREFERENCE_USERNAME];
		//[userDefaults setObject:_strPassword forKey:EXO_PREFERENCE_PASSWORD];
		[userDefaults setObject:@"YES" forKey:EXO_REMEMBER_ME];
	}
	else 
	{
		[userDefaults setObject:@"NO" forKey:EXO_REMEMBER_ME];
	}

	
	_bAutoSignIn = [_cbxAutoSignIn getStatus];
	if(_bAutoSignIn)
	{
		//[userDefaults setObject:_strHost forKey:EXO_PREFERENCE_DOMAIN];
		//[userDefaults setObject:_strUsername forKey:EXO_PREFERENCE_USERNAME];
		//[userDefaults setObject:_strPassword forKey:EXO_PREFERENCE_PASSWORD];
		[userDefaults setObject:@"YES" forKey:EXO_AUTO_SIGIN];
	}
	else 
	{
		[userDefaults setObject:@"NO" forKey:EXO_AUTO_SIGIN];
	}

	[_delegate showMainViewController];
}

- (void)signInFailed
{
	[_actiSigningIn stopAnimating];
	[_actiSigningIn setHidden:YES];
	[_lbSigningInStatus setHidden:YES];
	[_btnSignIn setHidden:NO];
}

@end

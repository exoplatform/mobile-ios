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
#import "SupportViewController.h"
#import "Configuration.h"
#import "iPadSettingViewController.h"
#import "iPadServerManagerViewController.h"
#import "iPadServerAddingViewController.h"
#import "iPadServerEditingViewController.h"
#import "SSHUDView.h"

#import "eXoSettingViewController.h"

#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20

@implementation LoginViewController

@synthesize _dictLocalize;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_strBSuccessful = [[NSString alloc] init];
		_intSelectedLanguage = 0;
        _intSelectedServer = -1;
        _arrServerList = [[NSMutableArray alloc] init];
		isFirstTimeLogin = YES;
        
        _arrViewOfViewControllers = [[NSMutableArray alloc] init];
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
    _vContainer.alpha = 0;
    [UIView beginAnimations:nil context:nil];  
    [UIView setAnimationDuration:1.0];  
    _vContainer.alpha = 100;
    [UIView commitAnimations];   
    
    _strBSuccessful = @"NO";
    Configuration* configuration = [Configuration sharedInstance];
    _arrServerList = [configuration getServerList];
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_intSelectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(_intSelectedLanguage == 0)
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
    if (_strHost == nil) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:_intSelectedServer];
        _strHost = tmpServerObj._strServerUrl;
    }
    
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
    
    [_arrViewOfViewControllers addObject:_vLoginView];
    [_actiSigningIn setHidden:YES];
    [_lbSigningInStatus setHidden:YES];
    [_tbvlServerList setHidden:YES];
    [_vAccountView setHidden:NO];

    _vAccountView.backgroundColor = [UIColor clearColor];
    _vServerListView.backgroundColor = [UIColor clearColor];
    _btnServerList.backgroundColor = [UIColor clearColor];
    _btnAccount.backgroundColor = [UIColor clearColor];
    
    //Set the state of the first selected tab
    [_btnAccount setSelected:YES];
    
    //Add the background image for the settings button
    [_btnSettings setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                      stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                            forState:UIControlStateNormal];
    
    
    //Add the background image for the login button
    [_btnLogin setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                   stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                         forState:UIControlStateNormal];
    
    [_tbvlServerList setFrame:CGRectMake(42,194, 532, 209)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

	[super viewDidLoad];
}

- (void)keyboardWillShow:(NSNotification *)notification 
{
    [self moveUp:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self moveUp:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationItem setLeftBarButtonItem:nil];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_hud dismiss];
    [_hud release];
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
    if (_iPadSettingViewController) 
    {
        [_iPadSettingViewController release];
    }
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController release];
    }
    if (_iPadServerAddingViewController) 
    {
        [_iPadServerAddingViewController release];
    }
    if (_iPadServerEditingViewController) 
    {
        [_iPadServerEditingViewController release];
    }
    [_arrServerList release];
    [_arrViewOfViewControllers release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    return YES;
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
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
	/*
	[_lbHostInstruction setText:[_dictLocalize objectForKey:@"DomainHeader"]];
	[_lbHost setText:[_dictLocalize objectForKey:@"DomainCellTitle"]];
	[_lbAccountInstruction setText:[_dictLocalize objectForKey:@"AccountHeader"]];
	[_lbRememberMe setText:[_dictLocalize objectForKey:@"RememberMe"]];
	[_lbAutoSignIn setText:[_dictLocalize objectForKey:@"AutoLogin"]];
	[_btnSignIn setTitle:[_dictLocalize objectForKey:@"SignInButton"] forState:UIControlStateNormal];
	[_btnSetting setTitle:[_dictLocalize objectForKey:@"Language"] forState:UIControlStateNormal];
	[_lbSigningInStatus setText:[_dictLocalize objectForKey:@"SigningIn"]];
						   
	[_settingViewController localize];
    */ 
    [_lbSigningInStatus setText:[_dictLocalize objectForKey:@"SigningIn"]];
    if (_iPadSettingViewController) 
    {
        [_iPadSettingViewController localize];
    }
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController localize];
    }
    if (_iPadServerAddingViewController) 
    {
        [_iPadServerAddingViewController localize];
    }
    if (_iPadServerEditingViewController) 
    {
        [_iPadServerEditingViewController localize];
    }
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
     _interfaceOrientation = interfaceOrientation;
    
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        //[_vLoginView setFrame:CGRectMake(226, 114, 609, 654)];
        [_vLoginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Portrait~ipad.png"]]];
        [_vContainer setFrame:CGRectMake(80, 200, 609, 591)];        
	}
	
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        //[_vLoginView setFrame:CGRectMake(80, 200, 609, 654)];
        [_vLoginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]]];
        [_vContainer setFrame:CGRectMake(207, 114, 609, 591)];
	}
    
    [self moveView];
}


- (IBAction)onSettingBtn:(id)sender
{
	if(_iPadSettingViewController == nil)
    {
        _iPadSettingViewController = [[iPadSettingViewController alloc] initWithNibName:@"iPadSettingViewController" bundle:nil];
        [_iPadSettingViewController setDelegate:self];
        //[_iPadSettingViewController setInterfaceOrientation:_interfaceOrientation];
        //[self.view addSubview:_iPadSettingViewController.view];
    }
    
    if (_modalNavigationSettingViewController == nil) 
    {
        _modalNavigationSettingViewController = [[UINavigationController alloc] initWithRootViewController:_iPadSettingViewController];
        _modalNavigationSettingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _modalNavigationSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
    }
    [self presentModalViewController:_modalNavigationSettingViewController animated:YES];
    
    //[self pushViewIn:_iPadSettingViewController.view];
}

- (IBAction)onSignInBtn:(id)sender
{
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
		NSRange range = [_strHost rangeOfString:@"http://"];
		if(range.length == 0)
		{
			_strHost = [NSString stringWithFormat:@"http://%@", _strHost];
		}
		[self doSignIn];
	}
}

- (void)doSignIn
{
    _hud = [[SSHUDView alloc] initWithTitle:@"Loading..."];
    [_hud show];
    
	[_btnLogin setHidden:YES];
	[_actiSigningIn setHidden:NO];
	[_lbSigningInStatus setHidden:NO];
	[_actiSigningIn startAnimating];
	[NSThread detachNewThreadSelector:@selector(startSignInProgress) toTarget:self withObject:nil];
}

- (void)startSignInProgress 
{  	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_strUsername = [_txtfUsername text];
	_strPassword = [_txtfPassword text];
	
	UIAlertView* alert;
	
	NSString* strResult = [[_delegate _connection] sendAuthenticateRequest:_strHost username:_strUsername password:_strPassword];
	//NSString* strResult = @"YES";
	if(strResult == @"YES")
	{
        [_hud completeAndDismissWithTitle:@"Success..."];
        [_hud dismiss];
		[self performSelectorOnMainThread:@selector(signInSuccesfully) withObject:nil waitUntilDone:NO];  
	}
	else if(strResult == @"NO")
	{
        [_hud dismiss];
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
        [_hud dismiss];
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
	[_btnLogin setHidden:NO];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];

	[userDefaults setObject:_strHost forKey:EXO_PREFERENCE_DOMAIN];
	[userDefaults setObject:_strUsername forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:_strPassword forKey:EXO_PREFERENCE_PASSWORD];

	//[_delegate showMainViewController];
    [_delegate showHomeViewController];
    //[_delegate showHome];

}

- (void)signInFailed
{
	[_actiSigningIn stopAnimating];
	[_actiSigningIn setHidden:YES];
	[_lbSigningInStatus setHidden:YES];
	[_btnLogin setHidden:NO];
}

- (IBAction)onBtnAccount:(id)sender
{
    [_btnAccount setImage:[UIImage imageNamed:@"AuthenticateCredentialsIconIpadOn.png"] forState:UIControlStateNormal];
    [_btnServerList setImage:[UIImage imageNamed:@"AuthenticateServersIconIpadOff.png"] forState:UIControlStateNormal];
    [_btnAccount setSelected:YES];
    [_btnServerList setSelected:NO];
    //[_btnServerList setBackgroundColor:[UIColor grayColor]];
    //[_btnAccount setBackgroundColor:[UIColor blueColor]];
    [_vLoginView bringSubviewToFront:_vAccountView];
    [_tbvlServerList setHidden:YES];
    [_vAccountView setHidden:NO];
}

- (IBAction)onBtnServerList:(id)sender
{
    [_btnAccount setImage:[UIImage imageNamed:@"AuthenticateCredentialsIconIpadOff.png"] forState:UIControlStateNormal];
    [_btnServerList setImage:[UIImage imageNamed:@"AuthenticateServersIconIpadOn.png"] forState:UIControlStateNormal];
    [_btnAccount setSelected:NO];
    [_btnServerList setSelected:YES];
    [_tbvlServerList setHidden:NO];
    [_vAccountView setHidden:YES];
    
    //[_btnServerList setBackgroundColor:[UIColor blueColor]];
    //[_btnAccount setBackgroundColor:[UIColor grayColor]];    
    //[_vLoginView bringSubviewToFront:_vServerListView];   
    [_vLoginView bringSubviewToFront:_tbvlServerList];   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];
    [_tbvlServerList reloadData];
}

- (void)moveUp:(BOOL)bUp
{
    CGRect frameToGo = _vContainer.frame;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        if (bUp) 
        {
            frameToGo.origin.y = 150;
        }
        else
        {
            frameToGo.origin.y = 200;
        }
    }
    
    if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {	
        if (bUp) 
        {
            frameToGo.origin.y = 0;
        }
        else
        {
            frameToGo.origin.y = 114;
        }
    }

    [UIView animateWithDuration:0.5 
                     animations:^{
                         _vContainer.frame = frameToGo;
                     }
     ];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _txtfUsername) 
    {
        [_txtfPassword becomeFirstResponder];
    }
    else
    {    
        [_txtfPassword resignFirstResponder];
        [self onSignInBtn:nil];
    }    
    
	return YES;
}

- (void)hitAtView:(UIView*) view
{
	if([view class] != [UITextField class])
	{
		[_txtfUsername resignFirstResponder];
		[_txtfPassword resignFirstResponder];
	}
}

- (void)pushViewIn:(UIView*)view
{
    [_arrViewOfViewControllers addObject:view];
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        [view setFrame:CGRectMake(SCR_WIDTH_PRTR_IPAD, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
        [self.view setFrame:CGRectMake(0, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
	}
	
	if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        [view setFrame:CGRectMake(SCR_WIDTH_LSCP_IPAD, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
        [self.view setFrame:CGRectMake(0, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
	}
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
    [self moveView];
    [UIView commitAnimations];
}

- (void)pullViewOut:(UIView*)viewController
{
    [self jumpToViewController:[_arrViewOfViewControllers count] - 2]; 
    [_arrViewOfViewControllers removeLastObject];
}

- (void)jumpToViewController:(int)index
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationDelegate:self];
    for (int i = 0; i < [_arrViewOfViewControllers count]; i++) 
    {
        UIView* tmpView = [_arrViewOfViewControllers objectAtIndex:i];
        int p = i - index;
//        if (p == 0) 
//        {
//            _intCurrentViewId = i;
//        }
//        [tmpView setFrame:CGRectMake(p*SCR_WIDTH_LSCP_IPAD, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_PRTR_IPAD, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
        }
        
        if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {	
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_LSCP_IPAD, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
        }
    }
    [UIView commitAnimations];
}



- (void)moveView
{
    for (int i = 0; i < [_arrViewOfViewControllers count]; i++) 
    {
        UIView* tmpView = [_arrViewOfViewControllers objectAtIndex:i];
        [tmpView removeFromSuperview];
        
        int p = i - [_arrViewOfViewControllers count] + 1;
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_PRTR_IPAD, 0, SCR_WIDTH_PRTR_IPAD, SCR_HEIGHT_PRTR_IPAD)];
        }
        
        if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
        {	
            [tmpView setFrame:CGRectMake(p*SCR_WIDTH_LSCP_IPAD, 0, SCR_WIDTH_LSCP_IPAD, SCR_HEIGHT_LSCP_IPAD)];
        }
        [self.view addSubview:tmpView];
    }
    if (_iPadSettingViewController) 
    {
        //[_iPadSettingViewController changeOrientation:_interfaceOrientation];
    }
    if (_iPadServerManagerViewController) 
    {
        //[_iPadServerManagerViewController changeOrientation:_interfaceOrientation];
    }
    if (_iPadServerAddingViewController) 
    {
        //[_iPadServerAddingViewController changeOrientation:_interfaceOrientation];
    }
    if (_iPadServerEditingViewController) 
    {
        //[_iPadServerEditingViewController changeOrientation:_interfaceOrientation];
    }
}

- (void)onBackDelegate
{
    [self pullViewOut:[_arrViewOfViewControllers lastObject]];
    if (_iPadSettingViewController) 
    {
        [_iPadSettingViewController.tblView reloadData];
    }
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController._tbvlServerList reloadData];
    }
    if (_iPadServerAddingViewController) 
    {
        [_iPadServerAddingViewController._tblvServerInfo reloadData];
    }
    if (_iPadServerEditingViewController) 
    {
        [_iPadServerEditingViewController._tblvServerInfo reloadData];
    }
    [_tbvlServerList reloadData];
}


- (void)showiPadServerManagerViewController
{
    /*
    if (_iPadServerManagerViewController == nil) 
    {
        _iPadServerManagerViewController = [[iPadServerManagerViewController alloc] initWithNibName:@"iPadServerManagerViewController" bundle:nil];
        [_iPadServerManagerViewController setDelegate:self];
        [_iPadServerManagerViewController setInterfaceOrientation:_interfaceOrientation];
        [self.view addSubview:_iPadServerManagerViewController.view];
    }
    [self pushViewIn:_iPadServerManagerViewController.view];
     */
    if (_iPadServerManagerViewController == nil) 
    {
        _iPadServerManagerViewController = [[iPadServerManagerViewController alloc] initWithNibName:@"iPadServerManagerViewController" bundle:nil];
        [_iPadServerManagerViewController setDelegate:self];
    }
    
    if ([_modalNavigationSettingViewController.viewControllers containsObject:_iPadServerManagerViewController]) 
    {
        [_modalNavigationSettingViewController popToViewController:_iPadServerManagerViewController animated:YES];
    }
    else
    {
        [_modalNavigationSettingViewController pushViewController:_iPadServerManagerViewController animated:YES];
    }
}


- (void)showiPadServerAddingViewController
{
    /*
    if (_iPadServerAddingViewController == nil) 
    {
        _iPadServerAddingViewController = [[iPadServerAddingViewController alloc] initWithNibName:@"iPadServerAddingViewController" bundle:nil];
        [_iPadServerAddingViewController setDelegate:self];
        [_iPadServerAddingViewController setInterfaceOrientation:_interfaceOrientation];
        [self.view addSubview:_iPadServerAddingViewController.view];
    }
    [_iPadServerAddingViewController._txtfServerName setText:@""];
    [_iPadServerAddingViewController._txtfServerUrl setText:@""];    
    [self pushViewIn:_iPadServerAddingViewController.view];
    */
    
    if (_iPadServerAddingViewController == nil) 
    {
        _iPadServerAddingViewController = [[iPadServerAddingViewController alloc] initWithNibName:@"iPadServerAddingViewController" bundle:nil];
        [_iPadServerAddingViewController setDelegate:self];
    }
    
    if ([_modalNavigationSettingViewController.viewControllers containsObject:_iPadServerAddingViewController]) 
    {
        [_modalNavigationSettingViewController popToViewController:_iPadServerAddingViewController animated:YES];
    }
    else
    {
        [_modalNavigationSettingViewController pushViewController:_iPadServerAddingViewController animated:YES];
    }
}

- (void)showiPadServerEditingViewControllerWithServerObj:(ServerObj*)serverObj andIndex:(int)index
{
    /*
    if (_iPadServerEditingViewController == nil) 
    {
        _iPadServerEditingViewController = [[iPadServerEditingViewController alloc] initWithNibName:@"iPadServerEditingViewController" bundle:nil];
        [_iPadServerEditingViewController setDelegate:self];
        [_iPadServerEditingViewController setInterfaceOrientation:_interfaceOrientation];
        [self.view addSubview:_iPadServerEditingViewController.view];
    }
    [_iPadServerEditingViewController setServerObj:serverObj andIndex:index];
    [self pushViewIn:_iPadServerEditingViewController.view];
    */
    
    if (_iPadServerEditingViewController == nil) 
    {
        _iPadServerEditingViewController = [[iPadServerEditingViewController alloc] initWithNibName:@"iPadServerEditingViewController" bundle:nil];
        [_iPadServerEditingViewController setDelegate:self];
    }
    
    [_iPadServerEditingViewController setServerObj:serverObj andIndex:index];
    
    if ([_modalNavigationSettingViewController.viewControllers containsObject:_iPadServerEditingViewController]) 
    {
        [_modalNavigationSettingViewController popToViewController:_iPadServerEditingViewController animated:YES];
    }
    else
    {
        [_modalNavigationSettingViewController pushViewController:_iPadServerEditingViewController animated:YES];
    }
}

- (void)editServerObjAtIndex:(int)intIndex withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController editServerObjAtIndex:intIndex withSeverName:strServerName andServerUrl:strServerUrl];
        //[self pullViewOut:[_arrViewOfViewControllers lastObject]];
    }
}

- (void)deleteServerObjAtIndex:(int)intIndex
{
    if (_iPadServerManagerViewController) 
    {
        [_iPadServerManagerViewController deleteServerObjAtIndex:intIndex];
    }
}

- (void)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl
{
    if(_iPadServerManagerViewController)
    {
        [_iPadServerManagerViewController addServerObjWithServerName:strServerName andServerUrl:strServerUrl]; 
        //[self pullViewOut:[_arrViewOfViewControllers lastObject]];
    }    
}


-(UIImageView *) makeCheckmarkOffAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOff.png"]] autorelease];
}

-(UIImageView *) makeCheckmarkOnAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOn.png"]] autorelease];
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

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //temporary code. It will be updated as soon as BD team provide us UI design
    float fWidth = 0;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        fWidth = 450;
    }
    
    if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        fWidth = 450;
    }
    float fHeight = 44.0;
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    NSString* text = tmpServerObj._strServerUrl; 
    CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    fHeight = 44*((int)theSize.height/44 + 1);
    return fHeight;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForServerCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AuthenticateServerCellIdentifier";
    static NSString *CellNib = @"AuthenticateServerCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNib owner:self options:nil];
        cell = (UITableViewCell *)[nib objectAtIndex:0];
        
        //Some customize of the cell background :-)
        [cell setBackgroundColor:[UIColor clearColor]];
        
        //Create two streachables images for background states
        UIImage *imgBgNormal = [[UIImage imageNamed:@"AuthenticateServerCellBgNormal.png"]
                                stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        
        UIImage *imgBgSelected = [[UIImage imageNamed:@"AuthenticateServerCellBgSelected.png"]
                                  stretchableImageWithLeftCapWidth:7 topCapHeight:0];
        
        //Add images to imageView for the backgroundview of the cell
        UIImageView *ImgVCellBGNormal = [[UIImageView alloc] initWithImage:imgBgNormal];
        
        UIImageView *ImgVBGSelected = [[UIImageView alloc] initWithImage:imgBgSelected];
        
        //Define the ImageView as background of the cell
        [cell setBackgroundView:ImgVCellBGNormal];
        [ImgVCellBGNormal release];
        
        //Define the ImageView as background of the cell
        [cell setSelectedBackgroundView:ImgVBGSelected];
        [ImgVBGSelected release];
        
    }
    
    
    if (indexPath.row == _intSelectedServer) 
    {
        cell.accessoryView = [self makeCheckmarkOnAccessoryView];
    }
    else
    {
        cell.accessoryView = [self makeCheckmarkOffAccessoryView];
    }
    
	ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    
    UILabel* lbServerName = (UILabel*)[cell viewWithTag:kTagInCellForServerNameLabel];
    
    lbServerName.text = tmpServerObj._strServerName;
    
    
    UILabel* lbServerUrl = (UILabel*)[cell viewWithTag:kTagInCellForServerURLLabel];
    lbServerUrl.text = tmpServerObj._strServerUrl;
    
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



/*
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
    
//    UILabel* lbServerUrl = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 400, 30)];
//    lbServerUrl.text = tmpServerObj._strServerUrl;
//    [cell addSubview:lbServerUrl];
//    [lbServerUrl release];
    float fWidth = 0;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        fWidth = 450;
    }
    
    if((_interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (_interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        fWidth = 450;
    }
    
    UILabel* lbServerUrl = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 400, 30)];
    NSString* text = tmpServerObj._strServerUrl; 
    CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    [lbServerUrl setFrame:CGRectMake(220, 5, fWidth, 44*((int)theSize.height/44 + 1) - 10)];
    [lbServerUrl setNumberOfLines:(int)theSize.height/44 + 1];
    lbServerUrl.text = tmpServerObj._strServerUrl;
    [cell addSubview:lbServerUrl];
    [lbServerUrl release];
    
	return cell;
}
*/

/*
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
*/
@end

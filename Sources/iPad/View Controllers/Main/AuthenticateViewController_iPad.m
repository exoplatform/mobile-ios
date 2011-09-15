//
//  LoginViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import "AuthenticateViewController_iPad.h"
#import "defines.h"
#import "AuthenticateProxy.h"
#import "SupportViewController.h"
#import "Configuration.h"
#import "SettingsViewController_iPad.h"
#import "SSHUDView.h"
#import "AppDelegate_iPad.h"

#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20

@implementation AuthenticateViewController_iPad

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
        
	}
	return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    [self.navigationController.navigationItem setLeftBarButtonItem:nil];
    [self.navigationController.navigationBar setHidden:YES];

}

- (void)signInAnimation:(int)animationMode
{
    _vContainer.alpha = 0;
    
    if(animationMode == 1)//Auto signIn
    {
        _vContainer.alpha = 1;
        [self onSignInBtn:nil];
    }
    else if(animationMode == 0)//Normal signIn
    {
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationDuration:1.0];  
        _vContainer.alpha = 1;
        [UIView commitAnimations];   
    }
    else//just show signIn screen
    {
        _vContainer.alpha = 1;
    }
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    
    [self changeOrientation:[[UIDevice currentDevice] orientation]];

    
    //Stevan UI fixes
    _panelBackground.image = [[UIImage imageNamed:@"AuthenticatePanelBg.png"] 
                              stretchableImageWithLeftCapWidth:50 topCapHeight:25]; 
    
    
    [_btnAccount setBackgroundImage:[[UIImage imageNamed:@"AuthenticatePanelButtonBgOff.png"] 
                                     stretchableImageWithLeftCapWidth:10 
                                     topCapHeight:10] forState:UIControlStateNormal];
    
    [_btnAccount setBackgroundImage:[[UIImage imageNamed:@"AuthenticatePanelButtonBgOn.png"] 
                                     stretchableImageWithLeftCapWidth:10 
                                     topCapHeight:10] forState:UIControlStateSelected];

    
    [_btnServerList setBackgroundImage:[[UIImage imageNamed:@"AuthenticatePanelButtonBgOff.png"] 
                                        stretchableImageWithLeftCapWidth:10 
                                        topCapHeight:10] forState:UIControlStateNormal];
    
    [_btnServerList setBackgroundImage:[[UIImage imageNamed:@"AuthenticatePanelButtonBgOn.png"] 
                                        stretchableImageWithLeftCapWidth:10 
                                        topCapHeight:10] forState:UIControlStateSelected];
    
    [_txtfPassword setBackground:[[UIImage imageNamed:@"AuthenticateTextfield.png"] 
                                  stretchableImageWithLeftCapWidth:10 
                                  topCapHeight:10]];
    
    [_txtfUsername setBackground:[[UIImage imageNamed:@"AuthenticateTextfield.png"] 
                                  stretchableImageWithLeftCapWidth:10 
                                  topCapHeight:10]];

    
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
    
	_bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	_bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
    
	_strHost = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
    if (_strHost == nil) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:_intSelectedServer];
        _strHost = tmpServerObj._strServerUrl;
    }
    
	if(_bRememberMe || _bAutoLogin)
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
    
    //[_tbvlServerList setFrame:CGRectMake(42,194, 532, 209)];
    

    [self signInAnimation:_bAutoLogin];

    [super viewDidLoad];
    
    
}


- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) { 
        [_vLoginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]]];
        [_vContainer setFrame:CGRectMake(227, 230, 569, 460)];
	} else {
        [_vLoginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Portrait~ipad.png"]]];
        [_vContainer setFrame:CGRectMake(100, 400, 569, 460)];
	}
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    return YES;
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self changeOrientation:toInterfaceOrientation];
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
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)setPreferenceValues
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];

	NSString *strUsername = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]; 
	if(strUsername)
	{
		[_txtfUsername setText:strUsername];
		[_txtfUsername resignFirstResponder];
	}
	
	NSString* strPassword = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD]; 
	if(strPassword)
	{
		[_txtfPassword setText:strPassword];
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


- (IBAction)onSettingBtn:(id)sender
{
	if(_iPadSettingViewController == nil)
    {
        _iPadSettingViewController = [[SettingsViewController_iPad alloc] initWithStyle:UITableViewStyleGrouped];
        _iPadSettingViewController.settingsDelegate = self;
    }
    
    if (_modalNavigationSettingViewController == nil) 
    {
        _modalNavigationSettingViewController = [[UINavigationController alloc] initWithRootViewController:_iPadSettingViewController];
        _modalNavigationSettingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _modalNavigationSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
    }
    [self presentModalViewController:_modalNavigationSettingViewController animated:YES];
    
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
		[self doSignIn];
	}
}

 
- (IBAction)onBtnAccount:(id)sender
{
    [_btnAccount setImage:[UIImage imageNamed:@"AuthenticateCredentialsIconIpadOn.png"] forState:UIControlStateNormal];
    [_btnServerList setImage:[UIImage imageNamed:@"AuthenticateServersIconIpadOff.png"] forState:UIControlStateNormal];
    [_btnAccount setSelected:YES];
    [_btnServerList setSelected:NO];
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
    [_vLoginView bringSubviewToFront:_tbvlServerList];   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];
    [_tbvlServerList reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    CGRect frameToGo = _vContainer.frame;
    
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        frameToGo.origin.y = 330;
    }
    else    
    {	
        frameToGo.origin.y = 0;
    }
    
    [UIView animateWithDuration:0.3 
                     animations:^{
                         _vContainer.frame = frameToGo;
                     }
     ];

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
        
        CGRect frameToGo = _vContainer.frame;
        
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            frameToGo.origin.y = 400;
        }
        else    
        {	
            frameToGo.origin.y = 230;
        }
        
        [UIView animateWithDuration:0.3 
                         animations:^{
                             _vContainer.frame = frameToGo;
                         }
         ];

        
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
        
        CGRect frameToGo = _vContainer.frame;
        
        if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        {
            frameToGo.origin.y = 400;
        }
        else    
        {	
            frameToGo.origin.y = 230;
        }
        
        [UIView animateWithDuration:0.3 
                         animations:^{
                             _vContainer.frame = frameToGo;
                         }
         ];   
	}
}


- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial {
    
    [_hud completeWithTitle:@"Success..."];
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHome) withObject:nil afterDelay:1.0];
    
}



#pragma UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightForServerCell;
}

#pragma - SettingsDelegate methods

-(void)doneWithSettings {
    [_tbvlServerList reloadData];
    [_iPadSettingViewController dismissModalViewControllerAnimated:YES];
}

@end

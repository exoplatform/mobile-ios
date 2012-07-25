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
#import "SettingsViewController_iPad.h"
#import "SSHUDView.h"
#import "AppDelegate_iPad.h"
#import "LanguageHelper.h"
#import "AuthTabItem.h"

#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20
#define scrollHeight 80

@implementation AuthenticateViewController_iPad

//@synthesize _dictLocalize;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		_strBSuccessful = [[NSString alloc] init];
		_intSelectedLanguage = 0;        
	}
	return self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationItem setLeftBarButtonItem:nil];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self signInAnimation:_credViewController.bAutoLogin];

}

- (void)signInAnimation:(int)animationMode
{    
    if(animationMode == 1)//Auto signIn
    {
     //   _vContainer.alpha = 1;
        //[self onSignInBtn:nil];
    }
    else if(animationMode == 0)//Normal signIn
    {
        [UIView beginAnimations:nil context:nil];  
        [UIView setAnimationDuration:1.0];  
    //    _vContainer.alpha = 1;
        [UIView commitAnimations];   
    }
    else//just show signIn screen
    {
     //   _vContainer.alpha = 1;
    }
}

-(void) initTabsAndViews {
    // Creating the sub view controllers
    _credViewController = [[CredentialsViewController alloc] initWithNibName:@"CredentialsViewController_iPad" bundle:nil];
    _credViewController.authViewController = self;
    
    _servListViewController = [[ServerListViewController alloc] initWithNibName:@"ServerListViewController_iPad" bundle:nil];
    
    // Initializing the Tab items and adding them to the Tab view
    AuthTabItem * tabItemCredentials = [[AuthTabItem alloc] initWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateCredentialsIconIpadOff"]];
    tabItemCredentials.alternateIcon = [UIImage imageNamed:@"AuthenticateCredentialsIconIpadOn"];
    [self.tabView addTabItem:tabItemCredentials];
    
    AuthTabItem * tabItemServerList = [[AuthTabItem alloc] initWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateServersIconIpadOff"]];
    tabItemServerList.alternateIcon = [UIImage imageNamed:@"AuthenticateServersIconIpadOn"];
    [self.tabView addTabItem:tabItemServerList];
    
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Position the tabs just above the subviews
    [self.tabView setFrame:CGRectMake(180, 400, 100, 30)];
    // Position the views and allow them to be resized properly when the orientation changes
    [_credViewController.view setFrame:
     CGRectMake(self.view.center.x-_credViewController.view.bounds.size.width/2, 450, _credViewController.view.bounds.size.width, _credViewController.view.bounds.size.height)];
    [_credViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [_servListViewController.view setFrame:
     CGRectMake(self.view.center.x-_servListViewController.view.bounds.size.width/2, 450, _servListViewController.view.bounds.size.width, _servListViewController.view.bounds.size.height)];
    [_servListViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    // Position the settings btn at the bottom
    [_btnSettings setFrame:
     CGRectMake(274, 750, _btnSettings.bounds.size.width, _btnSettings.bounds.size.height)];
    [_btnSettings setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];

    [self changeOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

    //Stevan UI fixes
    _credViewController.panelBackground.image = 
        [[UIImage imageNamed:@"AuthenticatePanelBg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25]; 
    
    _servListViewController.panelBackground.image = 
         [[UIImage imageNamed:@"AuthenticatePanelBg.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:25];
    [_credViewController.txtfPassword setBackground:[[UIImage imageNamed:@"AuthenticateTextfield.png"] 
                                  stretchableImageWithLeftCapWidth:10 
                                  topCapHeight:10]];
    
    [_credViewController.txtfUsername setBackground:[[UIImage imageNamed:@"AuthenticateTextfield.png"] 
                                  stretchableImageWithLeftCapWidth:10 
                                  topCapHeight:10]];
}


- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    

    if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        // Landscape orientation
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Landscape.png"]]];
        [self.tabView setFrame:CGRectMake(340, 250, 100, 30)];
        [_credViewController.view setFrame:CGRectMake(_credViewController.view.frame.origin.x, 300, _credViewController.view.frame.size.width, _credViewController.view.frame.size.height)];
        [_servListViewController.view setFrame:CGRectMake(_servListViewController.view.frame.origin.x, 300, _servListViewController.view.frame.size.width, _servListViewController.view.frame.size.height)];
        [_btnSettings setFrame:
         CGRectMake(_btnSettings.frame.origin.x, 600, _btnSettings.bounds.size.width, _btnSettings.bounds.size.height)];
    } 
    else
    {
        // Portrait orientation
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Portrait.png"]]];
        [self.tabView setFrame:CGRectMake(180, 400, 100, 30)];
        [_credViewController.view setFrame:CGRectMake(_credViewController.view.frame.origin.x, 450, _credViewController.view.frame.size.width, _credViewController.view.frame.size.height)];
        [_servListViewController.view setFrame:CGRectMake(_servListViewController.view.frame.origin.x, 450, _servListViewController.view.frame.size.width, _servListViewController.view.frame.size.height)];
        [_btnSettings setFrame:
         CGRectMake(_btnSettings.frame.origin.x, 750, _btnSettings.bounds.size.width, _btnSettings.bounds.size.height)];
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


- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}


- (void)dealloc 
{
    if (_iPadSettingViewController) 
    {
        [_iPadSettingViewController release];
    }
    [_dictLocalize release];
    
    [super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (void)setPreferenceValues
{
	NSString *strUsername = [[ServerPreferencesManager sharedInstance] username];
	if(strUsername)
	{
		[_credViewController.txtfUsername setText:strUsername];
		[_credViewController.txtfUsername resignFirstResponder];
	}
	
	NSString* strPassword = [[ServerPreferencesManager sharedInstance] password]; 
	if(strPassword)
	{
		[_credViewController.txtfPassword setText:strPassword];
		[_credViewController.txtfPassword resignFirstResponder];
	}
}

- (void)localize
{
	_dictLocalize = [_delegate getLocalization];
	_intSelectedLanguage = [_delegate getSelectedLanguage];
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
    [_iPadSettingViewController startRetrieve];
   
    if (_modalNavigationSettingViewController == nil) 
    {
        _modalNavigationSettingViewController = [[UINavigationController alloc] initWithRootViewController:_iPadSettingViewController];
        _modalNavigationSettingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        _modalNavigationSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        _modalNavigationSettingViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        
    }
    [self presentModalViewController:_modalNavigationSettingViewController animated:YES];
    
    _modalNavigationSettingViewController.view.superview.autoresizingMask = 
    UIViewAutoresizingFlexibleTopMargin | 
    UIViewAutoresizingFlexibleBottomMargin;   
    
    
    _modalNavigationSettingViewController.view.superview.frame = CGRectMake(0,0,
                                                                            560.0f,
                                                                            640.0f
                                                                            );
    
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        _modalNavigationSettingViewController.view.superview.center = CGPointMake(768/2, 1024/2 + 10);        
    }
    else
        _modalNavigationSettingViewController.view.superview.center = CGPointMake(1024/2, 768/2 + 10);
    
}

#pragma mark - TextField delegate 

- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion{
    [super platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    //Setup Version Platfrom and Application
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if(platformServerVersion != nil){
        
        
        [userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:platformServerVersion.platformEdition forKey:EXO_PREFERENCE_EDITION_SERVER];
        if([platformServerVersion.isMobileCompliant boolValue]){
            [self.hud completeAndDismissWithTitle:Localize(@"Success")];
            AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
            appDelegate.isCompatibleWithSocial = compatibleWithSocial;
            [appDelegate performSelector:@selector(showHome) withObject:nil afterDelay:1.0];
        } else {
            [self.hud failAndDismissWithTitle:Localize(@"Error")];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                            message:Localize(@"NotCompliant") 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
	
    } else {
        [self.hud failAndDismissWithTitle:Localize(@"Error")];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Error") 
                                                        message:Localize(@"NotCompliant") 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [userDefaults synchronize];
}


#pragma - SettingsDelegate methods

-(void)doneWithSettings {
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    [_credViewController.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _credViewController.bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue]; 
    [self signInAnimation:_credViewController.bAutoLogin];
    [_servListViewController.tbvlServerList reloadData];
    [_iPadSettingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark Keyboard management
-(void)setViewMovedUp:(BOOL)movedUp
{
    if (movedUp)
    {
        CGPoint destPoint = CGPointMake(self.view.bounds.origin.x, self.view.bounds.origin.y+scrollHeight);
        [(UIScrollView*)self.view setContentOffset:destPoint animated:YES];
    }
    else
    {  
        CGPoint destPoint = CGPointMake(self.view.bounds.origin.x, self.view.bounds.origin.y-scrollHeight);
        [(UIScrollView*)self.view setContentOffset:destPoint animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
      [self setViewMovedUp:NO];
}


- (void)keyboardDidShow:(NSNotification *)notif{
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
     [self setViewMovedUp:YES];
}


@end

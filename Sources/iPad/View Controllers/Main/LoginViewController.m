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
#import "AuthenticateProxy.h"
#import "SupportViewController.h"
#import "Configuration.h"
#import "SettingsViewController.h"
#import "SSHUDView.h"

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
    
    //[_tbvlServerList setFrame:CGRectMake(42,194, 532, 209)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self signInAnimation:bAutoLogin];

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

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    
	if((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
	{
        //[_vLoginView setFrame:CGRectMake(226, 114, 609, 654)];
        [_vLoginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Portrait~ipad.png"]]];
        [_vContainer setFrame:CGRectMake(100, 400, 569, 460)];        
	}
	
	if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
	{	
        //[_vLoginView setFrame:CGRectMake(80, 200, 609, 654)];
        [_vLoginView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Landscape~ipad.png"]]];
        [_vContainer setFrame:CGRectMake(227, 230, 569, 460)];
	}
    
    //[self moveView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    return YES;
}

/*
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[stackScrollViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
*/
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


- (IBAction)onSettingBtn:(id)sender
{
	if(_iPadSettingViewController == nil)
    {
        _iPadSettingViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        //[_iPadSettingViewController setInterfaceOrientation:_interfaceOrientation];
        //[self.view addSubview:_iPadSettingViewController.view];
    }
    
    [_iPadSettingViewController viewWillAppear:YES];
    
    
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
	
	NSString* strResult = [[AuthenticateProxy sharedInstance] sendAuthenticateRequest:_strHost username:_strUsername password:_strPassword];
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
    
    PlatformVersionProxy* plfVersionProxy = [[PlatformVersionProxy alloc] initWithDelegate:self];
    [plfVersionProxy retrievePlatformInformations];

}

- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)isCompatibleWithSocial {
    
    [_delegate showHomeViewController:isCompatibleWithSocial];
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

- (void)moveUp:(BOOL)bUp
{
    CGRect frameToGo = _vContainer.frame;
    if((_interfaceOrientation == UIInterfaceOrientationPortrait) || (_interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
    {
        if (bUp) 
        {
            frameToGo.origin.y = 330;
        }
        else
        {
            frameToGo.origin.y = 400;
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
            frameToGo.origin.y = 230;
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
}


-(UIImageView *) makeCheckmarkOffAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPadOff.png"]] autorelease];
}

-(UIImageView *) makeCheckmarkOnAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPadOn.png"]] autorelease];
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


@end

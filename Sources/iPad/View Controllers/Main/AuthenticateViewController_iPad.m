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
#define scrollHeight 100 /* how much should we scroll up/down when the keyboard is displayed/hidden */
#define tabViewsTopMargin -4 /* the top margin of the views under the tabs */
#define settingsBtnTopMargin 50 /* the top margin of the settings button */
#define tabsHeightAndLeftMargin 76 /* the height and left margin of the tabs */
#define tabsWidth 180 /* defines the width of the clickable area */
#define tabsY 377 /* distance from the top of the screen to the top of the tabs */
#define tabsYInLandscape 240 /* same as tabsY but in landscape mode */

@implementation AuthenticateViewController_iPad

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
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_credViewController signInAnimation:(_credViewController.bAutoLogin && ![self autoLoginIsDisabled])];
}


-(void) initTabsAndViews {
    // Creating the sub view controllers
    _credViewController = [[CredentialsViewController alloc] initWithNibName:@"CredentialsViewController_iPad" bundle:nil];
    _credViewController.authViewController = self;
    _servListViewController = [[ServerListViewController alloc] initWithNibName:@"ServerListViewController_iPad" bundle:nil];
    
    // Initializing the Tab items and adding them to the Tab view
    AuthTabItem * tabItemCredentials = [AuthTabItem tabItemWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateCredentialsIconIpadOff"] alternateIcon:[UIImage imageNamed:@"AuthenticateCredentialsIconIpadOn"]];
    [self.tabView addTabItem:tabItemCredentials];
    
    AuthTabItem * tabItemServerList = [AuthTabItem tabItemWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateServersIconIpadOff"] alternateIcon:[UIImage imageNamed:@"AuthenticateServersIconIpadOn"]];
    [self.tabView addTabItem:tabItemServerList];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    // Allow the views to be resized properly when the orientation changes
    [_credViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [_servListViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
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
        // /!\ The coordinates x and y are inverted (e.g. x in landscape = y in portrait)
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Landscape.png"]]];
        // Position the tabs just above the subviews
        [self.tabView setFrame:
         CGRectMake((self.view.center.y-_credViewController.view.bounds.size.width/2)+tabsHeightAndLeftMargin,
                    tabsYInLandscape, /* reduced space between the tabs and the eXo logo */
                    tabsWidth,
                    tabsHeightAndLeftMargin)];
        // Calculate the origin point of the views
        // - at the center
        // - with a -4 margin to avoid a space between the tab and the frame
        CGPoint viewsOrigin = CGPointMake(self.view.center.y-_credViewController.view.bounds.size.width/2,
                                          self.tabView.frame.origin.y+self.tabView.frame.size.height+tabViewsTopMargin);
        // Position the views just below the tabs
        [_credViewController.view setFrame:
         CGRectMake(viewsOrigin.x, viewsOrigin.y,
                    _credViewController.view.bounds.size.width,
                    _credViewController.view.bounds.size.height)];
        
        [_servListViewController.view setFrame:
         CGRectMake(viewsOrigin.x, viewsOrigin.y,
                    _servListViewController.view.bounds.size.width,
                    _servListViewController.view.bounds.size.height)];
        // Position the settings button under the views
        // Calculate the origin of the _credViewController in the root view (i.e. absolute origin)
        CGPoint absPoint = [self.view convertPoint:_credViewController.view.frame.origin toView:self.view];
        [_btnSettings setFrame:
         CGRectMake(self.view.center.y-_btnSettings.bounds.size.width/2,      // at the center
                    absPoint.y+_credViewController.view.frame.size.height+settingsBtnTopMargin, // +50 margin
                    _btnSettings.bounds.size.width,
                    _btnSettings.bounds.size.height)];
    } 
    else
    {
        // Portrait orientation
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-Portrait.png"]]];
        
        // Position the tabs
        [self.tabView setFrame:
         CGRectMake((self.view.center.x-_credViewController.view.bounds.size.width/2)+tabsHeightAndLeftMargin,
                    tabsY,
                    tabsWidth,
                    tabsHeightAndLeftMargin)];
        // Calculate the origin point of the views
        // - at the center
        // - with a -4 margin to avoid a space between the tab and the frame
        CGPoint viewsOrigin = CGPointMake(self.view.center.x-_credViewController.view.bounds.size.width/2,
                                          self.tabView.frame.origin.y+self.tabView.frame.size.height+tabViewsTopMargin);
        // Position the views just below the tabs
        [_credViewController.view setFrame:
         CGRectMake(viewsOrigin.x, viewsOrigin.y,
                    _credViewController.view.bounds.size.width,
                    _credViewController.view.bounds.size.height)];

        [_servListViewController.view setFrame:
         CGRectMake(self.view.center.x-_servListViewController.view.bounds.size.width/2,
                    self.tabView.frame.origin.y+self.tabView.frame.size.height-4,
                    _servListViewController.view.bounds.size.width,
                    _servListViewController.view.bounds.size.height)];
        // Position the settings button under the views
        // Calculate the origin of the _credViewController in the root view (i.e. absolute origin)
        CGPoint absPoint = [self.view convertPoint:_credViewController.view.frame.origin toView:self.view];
        [_btnSettings setFrame:
         CGRectMake(self.view.center.x-_btnSettings.bounds.size.width/2,      // at the center
                    absPoint.y+_credViewController.view.frame.size.height+settingsBtnTopMargin, // +50 margin
                    _btnSettings.bounds.size.width,
                    _btnSettings.bounds.size.height)];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    return YES;
}

// An ugly hack:
// Disable the keyboard notifications before the orientation changes, and re-enable them
// after the orientation has changed.
// This way the KeyboardWillHide notification is not sent during the rotation, avoiding
// a gap at the top of the view.
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidHideNotification object:nil];
}
// End of the ugly hack

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
    [super doneWithSettings];
    [_iPadSettingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Keyboard management

- (void)manageKeyboard:(NSNotification *) notif {
        NSDictionary *info = [notif userInfo];
        // Get the size of the keyboard, before and after the animation
        CGFloat keyboardHeightBefore = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] toView:nil].size.height;
        CGFloat keyboardHeightAfter = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:nil].size.height;
        // Create a rectangle of the size of the entire frame
        CGRect aRect = [self.view convertRect:self.view.frame fromView:nil];
        // Create a point at the origin of the password text field component
        CGPoint fieldPoint = 
        CGPointMake(_credViewController.view.frame.origin.x + _credViewController.txtfPassword.frame.origin.x,
                    _credViewController.view.frame.origin.y + _credViewController.txtfPassword.frame.origin.y);
        
        if (notif.name == UIKeyboardDidShowNotification) {
            // Reduce the height of the rect to represent only the area not covered by the keyboard (after it has appeared)
            aRect.size.height -= keyboardHeightAfter;
            // If the point is not in the area, we move the view up so it becomes visible
            if (!CGRectContainsPoint(aRect, fieldPoint))
                [self moveUp];
        } else if (notif.name == UIKeyboardDidHideNotification) {
            // Reduce the height of the rect to represent only the area not covered by the keyboard (before it will disappear)
            aRect.size.height -= keyboardHeightBefore;
            // If the point is in the visible area, we move the view down before the keyboard
            if (CGRectContainsPoint(aRect, fieldPoint))
                [self moveDown];
        }
}

- (void)moveUp {
    CGPoint destPoint = CGPointMake(self.view.bounds.origin.x, self.view.bounds.origin.y+scrollHeight);
    [(UIScrollView*)self.view setContentOffset:destPoint animated:YES];
}

- (void)moveDown {
    [(UIScrollView*)self.view setContentOffset:CGPointZero animated:YES];
}


@end

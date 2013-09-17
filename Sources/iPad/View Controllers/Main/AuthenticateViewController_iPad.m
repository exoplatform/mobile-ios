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
#import "UserPreferencesManager.h"
#import "eXoNavigationController.h"

#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20
#define scrollTop 100 /* how much should we scroll up/down when the keyboard is displayed/hidden */
#define tabViewsTopMargin -4 /* the top margin of the views under the tabs */
#define settingsBtnTopMargin 50 /* the top margin of the settings button */
#define tabsHeightAndLeftMargin 76 /* the height and left margin of the tabs */
#define tabsWidth 180 /* defines the width of the clickable area */
#define tabsY 377 /* distance from the top of the screen to the top of the tabs */
#define tabsYInLandscape 240 /* same as tabsY but in landscape mode */

@interface AuthenticateViewController_iPad()
@end

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
- (void)viewWillLayoutSubviews
{
    //in iOS 6, willAnimateRotationToInterfaceOrientation is not called when the view is appeared
    //need to call changeOrientation manually in this method.
    [self changeOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)changeOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _interfaceOrientation = interfaceOrientation;
    
    UIImage *bgPattern = [UIImage imageNamed:@"Default-Portrait.png"];
    float screenWidth = SCR_WIDTH_PRTR_IPAD;
    //coordinate of container of the tab, credentials view
    float containerY = tabsY;
    float containerX;
    CGRect frame = CGRectZero;

    if(UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        bgPattern = [UIImage imageNamed:@"Default-Landscape.png"];
        screenWidth = SCR_WIDTH_LSCP_IPAD;
        containerY = tabsYInLandscape;
    }
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgPattern]];
    containerX = (screenWidth - _credViewController.view.bounds.size.width)/2;
    //position the tabs
    frame.origin.x =  containerX + tabsHeightAndLeftMargin;
    frame.origin.y = containerY;
    frame.size = CGSizeMake(tabsWidth, tabsHeightAndLeftMargin);
    self.tabView.frame = frame;
    
    //position the text fields (credentials view)
    frame.origin.x = containerX;
    frame.origin.y = containerY + tabsHeightAndLeftMargin + tabViewsTopMargin;
    frame.size = _credViewController.view.bounds.size;
    _credViewController.view.frame = frame;
    
    //position the servers list view
    frame.size = _servListViewController.view.bounds.size;
    _servListViewController.view.frame = frame;
    
    //position the setting button
    frame.origin.x = (screenWidth - _btnSettings.bounds.size.width)/2;
    frame.origin.y = _credViewController.view.frame.origin.y + _credViewController.view.frame.size.height + settingsBtnTopMargin;
    frame.size = _btnSettings.bounds.size;
    _btnSettings.frame = frame;
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
	NSString *strUsername = [[UserPreferencesManager sharedInstance] username];
	if(strUsername)
	{
		[_credViewController.txtfUsername setText:strUsername];
		[_credViewController.txtfUsername resignFirstResponder];
	}
	
	NSString* strPassword = [[UserPreferencesManager sharedInstance] password]; 
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
    if([ApplicationPreferencesManager sharedInstance].selectedDomain) {
        [_iPadSettingViewController startRetrieve];
    }
    
   
    if (_modalNavigationSettingViewController == nil) 
    {
     _modalNavigationSettingViewController = [[eXoNavigationController alloc] initWithRootViewController:_iPadSettingViewController];
        _modalNavigationSettingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _modalNavigationSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentModalViewController:_modalNavigationSettingViewController animated:YES];
}

#pragma mark - TextField delegate 

- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion{
    
    [super loginProxy:proxy platformVersionCompatibleWithSocialFeatures:compatibleWithSocial withServerInformation:platformServerVersion];
    
    [self.hud completeAndDismissWithTitle:Localize(@"Success")];
    
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    appDelegate.isCompatibleWithSocial = compatibleWithSocial;
    [appDelegate performSelector:@selector(showHome) withObject:nil afterDelay:1.0];
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
    CGPoint destPoint = CGPointMake(self.view.bounds.origin.x, self.view.bounds.origin.y+scrollTop);
    [(UIScrollView*)self.view setContentOffset:destPoint animated:YES];
}

- (void)moveDown {
    [(UIScrollView*)self.view setContentOffset:CGPointZero animated:YES];
}

@end

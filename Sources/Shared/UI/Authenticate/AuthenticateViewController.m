//
//  AuthenticateViewController_iPhone.m
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "AuthenticateViewController.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "CXMLDocument.h"
#import "DataProcess.h"
#import "NSString+HTML.h"
#import "SSHUDView.h"
#import "LanguageHelper.h"
#import "URLAnalyzer.h"

//Define for cells of the Server Selection Panel
/*#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20
*/
@interface AuthenticateViewController ()

@property (nonatomic, retain) LoginProxy *loginProxy;

@end

@implementation AuthenticateViewController

@synthesize loginProxy = _loginProxy;
//@synthesize scrollView = _scrollView;
//@synthesize activeField = _activeField;
@synthesize tabView = _tabView;

@synthesize hud = _hud;

- (void)dealloc 
{
    //[self unRegisterForKeyboardNotifications];
    [_loginProxy release];
    [_hud release];
    //  [_scrollView release];
    [super dealloc];	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
        _strBSuccessful = [[NSString alloc] init];
        
    }
    return self;
}

- (void)loadView 
{
	[super loadView];
}

-(void) initTabViews {
    // empty, must be overriden in _iPad and _iPhone children classes
    // - create the JMView
    // - create views for each tab, using the relevant NIB
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavbarBg.png"]]];
        
    }
     
    // Initializing the Tab view
    self.tabView = [[JMTabView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    self.tabView.delegate = self;
    [self.tabView setBackgroundLayer:nil];
    [self.tabView setSelectionView:[[[AuthSelectionView alloc] initWithFrame:CGRectZero] autorelease]];
    
    // Initializing the Tab items and adding them to the Tab view
    AuthTabItem * tabItemCredentials = [[AuthTabItem alloc] initWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateCredentialsIconIpadOff"]];
    tabItemCredentials.alternateIcon = [UIImage imageNamed:@"AuthenticateCredentialsIconIpadOn"];
    [self.tabView addTabItem:tabItemCredentials];
    AuthTabItem * tabItemServerList = [[AuthTabItem alloc] initWithTitle:nil icon:[UIImage imageNamed:@"AuthenticateServersIconIpadOff"]];
    tabItemServerList.alternateIcon = [UIImage imageNamed:@"AuthenticateServersIconIpadOn"];
    [self.tabView addTabItem:tabItemServerList];
    
    // Adding the Tab view to the main view
    [self.view addSubview:self.tabView];
    
    // Initializing and adding the sub views (one for each Tab item)
    [self initTabViews];
    [self.view insertSubview:_credViewController.view belowSubview:self.tabView];
    [self.view insertSubview:_servListViewController.view belowSubview:self.tabView];
    self.tabView.selectedIndex = AuthenticateTabItemCredentials;
    
    _servListViewController.view.hidden = YES;

    // Position the tabs just above the subviews
    NSInteger tabPosY = _credViewController.txtfUsername.superview.frame.origin.y - self.tabView.frame.size.height - 20;
    NSInteger tabPosX = _credViewController.txtfUsername.superview.frame.origin.x;
    [self.tabView setFrame:CGRectMake(tabPosX, tabPosY, self.view.bounds.size.width, 30)];
    
    
    
    //self.scrollView.contentSize = self.view.frame.size;
    
   // _vContainer.backgroundColor = [UIColor clearColor];
   // [_vContainer viewWithTag:1].backgroundColor = [UIColor clearColor];
    
    
    //Set Alpha for all subviews to make a small animation
   // _vContainer.alpha = 0;
    
//    _tbvlServerList.hidden = YES;
    
//    _vAccountView.backgroundColor = [UIColor clearColor];
//    _vServerListView.backgroundColor = [UIColor clearColor];
 //   _btnServerList.backgroundColor = [UIColor clearColor];
//    _btnAccount.backgroundColor = [UIColor clearColor];
    
    
    //Set the state of the first selected tab
//    [_btnAccount setSelected:YES];
    
    //Add the background image for the settings button
    [_btnSettings setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                      stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                            forState:UIControlStateNormal];
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    
    
    //Add the background image for the login button
   /* [_btnLogin setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                   stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                         forState:UIControlStateNormal];
    [_btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    */
    _strBSuccessful = @"NO";

    /* Add tap gesture to dismiss keyboard */
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Do not cancel touch processes on subviews
    [self.view addGestureRecognizer:tapGesure];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Hide the Navigation Bar
    self.navigationController.navigationBarHidden = YES;
    
	[[self navigationItem] setTitle:Localize(@"SignInPageTitle")];	
	
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
/*	_bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	_bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
	
	if(_bRememberMe || _bAutoLogin)
	{
		NSString* username = [[ServerPreferencesManager sharedInstance] username];
		NSString* password = [[ServerPreferencesManager sharedInstance] password];
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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:EXO_IS_USER_LOGGED];
	}
    */
   // [_tbvlServerList reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /* register keyboard notification */
   // [self registerForKeyboardNotifications]; TODO move to Cred view controller
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [self unRegisterForKeyboardNotifications]; TODO move to Cred view controller
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning 
{
    [_hud release];
    _hud = nil;
    [super didReceiveMemoryWarning];
}

- (IBAction)onHitViewBtn:(id)sender {

    [self hitAtView:self.view];
    
}

/*- (IBAction)onBtnAccount:(id)sender
{
    [_btnAccount setSelected:YES];
    [_btnServerList setSelected:NO];

    //UI Hack
    [_vContainer bringSubviewToFront:_btnAccount];
    [_vContainer sendSubviewToBack:_btnServerList];

    _vServerListView.hidden = YES;
    _vAccountView.hidden = NO;
}*/

/*- (IBAction)onBtnServerList:(id)sender
{
    
    [_btnAccount setSelected:NO];
    [_btnServerList setSelected:YES];

    //UI Hack
    [_vContainer bringSubviewToFront:_btnServerList];
    [_vContainer sendSubviewToBack:_btnAccount];

    _vServerListView.hidden = NO;
    _vAccountView.hidden = YES;
    [_tbvlServerList reloadData];
}*/


- (void)hitAtView:(UIView*) view
{
	if([view class] != [UITextField class])
	{
		//[_txtfUsername resignFirstResponder];
		//[_txtfPassword resignFirstResponder];
        
        //Replace the frame at the good position
        CGRect frameToGo = self.view.frame;
        frameToGo.origin.y = 0;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.view.frame = frameToGo;
                         }
         ];
	}
}

#pragma mark - Keyboard management

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unRegisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    // Get the size of the keyboard.
    CGSize keyboardSize = [self.view convertRect:[[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue] toView:nil].size;
    
    // Adjust the bottom content inset of your scroll view by the keyboard height.
    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
 //   self.scrollView.contentInset = contentInsets;
 //   self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = [self.view convertRect:self.view.frame fromView:nil];
    
    aRect.size.height -= keyboardSize.height;
    
//    CGPoint fieldPoint = CGPointMake(_vContainer.frame.origin.x + _txtfPassword.frame.origin.x + _vAccountView.frame.origin.x, _vContainer.frame.origin.y + _txtfPassword.frame.origin.y + _vAccountView.frame.origin.y);
    
    // Scroll the target text field into view.
//    if (!CGRectContainsPoint(aRect, fieldPoint)) {
//        CGPoint scrollPoint = CGPointMake(0.0, fieldPoint.y - keyboardSize.height);
  //      [self.scrollView setContentOffset:scrollPoint animated:YES];
        
   // }
}

- (void)keyboardWillHide:(NSNotification *)notification {
//    self.scrollView.contentInset = UIEdgeInsetsZero;
//    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
//    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)dismissKeyboard {
    [_credViewController.activeField resignFirstResponder];
}

#pragma mark - TextField delegate
/*
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}*/

#pragma mark - getters & setters
- (SSHUDView *)hud {
    if (!_hud) {
        _hud = [[SSHUDView alloc] initWithTitle:Localize(@"Loading")];
        _hud.completeImage = [UIImage imageNamed:@"19-check.png"];
        _hud.failImage = [UIImage imageNamed:@"11-x.png"];
    }
    return _hud;
}

#pragma mark - PlatformVersionProxyDelegate 
- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion {
    // Remake the screen interactions enabled
    self.view.userInteractionEnabled = YES;
    if (compatibleWithSocial) {
        [ServerPreferencesManager sharedInstance].username = _txtfUsername.text;
        [ServerPreferencesManager sharedInstance].password = _txtfPassword.text;
        [[ServerPreferencesManager sharedInstance] persistUsernameAndPasswod];
    }
}

- (void)authenticateFailedWithError:(NSError *)error {
    [self view].userInteractionEnabled = YES;
    [self.hud failAndDismissWithTitle:Localize(@"Error")];
    
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorUserCancelledAuthentication) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"WrongUserNamePassword") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];        
    } else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"NetworkConnection") message:Localize(@"NetworkConnectionFailed") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    }
}

#pragma mark - authentication process 
- (void)doSignIn
{
    [self hitAtView:nil];
    // active hud loading 
    self.hud.textLabel.text = Localize(@"Loading");
    [self.hud setLoading:YES];
    [self.hud show];
	[self view].userInteractionEnabled = NO;
    
	[_credViewController.txtfUsername resignFirstResponder];
	[_credViewController.txtfPassword resignFirstResponder];
	
    NSString* username = [_txtfUsername text];
	NSString* password = [_txtfPassword text];
    
    self.loginProxy = [[[LoginProxy alloc] initWithDelegate:self] autorelease];
    
    [self.loginProxy authenticateAndGetPlatformInfoWithUsername:username password:password];

}


#pragma mark JMTabView protocol implementation

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex {
    if (itemIndex == AuthenticateTabItemCredentials) {
        _credViewController.view.hidden = NO;
        _servListViewController.view.hidden = YES;
        NSLog(@"Displaying the Credentials view");
    } else if (itemIndex == AuthenticateTabItemServerList) {
        _credViewController.view.hidden = YES;
        _servListViewController.view.hidden = NO;
        NSLog(@"Displaying the Server List view");
    }
}

@end



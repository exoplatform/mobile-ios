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
#import "AuthSelectionView.h"

#pragma mark - Authenticate View Controller

@interface AuthenticateViewController ()

@property (nonatomic, retain) LoginProxy *loginProxy;

@end

@implementation AuthenticateViewController

@synthesize loginProxy = _loginProxy;
@synthesize tabView = _tabView;
@synthesize hud = _hud;

- (void)dealloc 
{
    _bAutoLoginIsDisabled = NO;
    [_loginProxy release];
    [_hud release];
    [super dealloc];	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
        _strBSuccessful = [[NSString alloc] init];
        // By defaut, Auto Login is not disabled, i.e
        // - if it is ON, user will be signed in automatically
        // - if it is OFF, user will stay on the Authenticate page
        _bAutoLoginIsDisabled = NO;
    }
    return self;
}

- (void)loadView 
{
	[super loadView];
}

-(void) initTabsAndViews {
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
    self.tabView = [[JMTabView alloc] initWithFrame:CGRectZero];
    self.tabView.delegate = self;
    [self.tabView setBackgroundLayer:nil];
    [self.tabView setSelectionView:[[[AuthSelectionView alloc] initWithFrame:CGRectZero] autorelease]];
    
    // Initializing the tabs and corresponding sub views
    [self initTabsAndViews];
    
    // Adding the views to the main view
    [self.view addSubview:self.tabView];    
    [self.view insertSubview:_credViewController.view belowSubview:self.tabView];
    [self.view insertSubview:_servListViewController.view belowSubview:self.tabView];
    self.tabView.selectedIndex = AuthenticateTabItemCredentials;
    _servListViewController.view.hidden = YES;
    
    //Add the background image for the settings button
    [_btnSettings setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                            stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                            forState:UIControlStateNormal];
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];

    _strBSuccessful = @"NO";

    //Add tap gesture to dismiss keyboard
    UITapGestureRecognizer *tapGesure = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)] autorelease];
    [tapGesure setCancelsTouchesInView:NO]; // Do not cancel touch processes on subviews
    [self.view addGestureRecognizer:tapGesure];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Hide the Navigation Bar
    self.navigationController.navigationBarHidden = YES;
    
	[[self navigationItem] setTitle:Localize(@"SignInPageTitle")];
	
    // Notifies when the keyboard is shown/hidden
    // Selector must be implemented in _iPhone and _iPad subclasses
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    // Handle user parameters
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_credViewController.bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	_credViewController.bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];

    // If Auto Login is disabled, we set the Auto Login variable to NO
    // but we don't save this value in the user settings
    if ([self autoLoginIsDisabled])
        _credViewController.bAutoLogin = NO;
    
    NSString* username = _credViewController.txtfUsername.text;
    NSString* password = _credViewController.txtfPassword.text;
    NSString* storedUsername = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME];
    NSString* storedPassword = [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD];
    // If the values in the username/password textfields has changed,
    // and the user has just signed out of the application
    // we keep the new value of the text fields
	if((![username isEqualToString:storedUsername] || ![password isEqualToString:storedPassword]) && _bAutoLoginIsDisabled)
	{
		[self setUsernamePassword:username :password];
	}
    // If we remember the username/password, and it's the first start of the application
    // we display the stored username and password
    if (_credViewController.bRememberMe && !_bAutoLoginIsDisabled)
	{
        [self setUsernamePassword:storedUsername :storedPassword];
        //[userDefaults setObject:@"NO" forKey:EXO_IS_USER_LOGGED];
	}
}

-(void) doneWithSettings {
    // Called when the Settings popup is closed
    // Updates the variables with the new values
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    [_credViewController.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    [_credViewController.txtfUsername setPlaceholder:Localize(@"UsernamePlaceholder")];
    [_credViewController.txtfPassword setPlaceholder:Localize(@"PasswordPlaceholder")];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _credViewController.bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
    [_servListViewController.tbvlServerList reloadData];
    
    _credViewController.bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
    [_credViewController signInAnimation:_credViewController.bAutoLogin];
}

-(void) setUsernamePassword:(NSString*)username :(NSString*)password {    
    if(username)
    {
        [_credViewController.txtfUsername setText:username];
    }
    
    if(password)
    {
        [_credViewController.txtfPassword setText:password];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) disableAutoLogin:(BOOL)autoLogin {
    _bAutoLoginIsDisabled = autoLogin;
}

-(BOOL) autoLoginIsDisabled {
    return _bAutoLoginIsDisabled;
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




#pragma mark - Keyboard management
- (void)dismissKeyboard {
    // Handled by the CredentialsViewController where the text fields are defined
    [_credViewController dismissKeyboard];
}


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
        [ServerPreferencesManager sharedInstance].username = _credViewController.txtfUsername.text;
        [ServerPreferencesManager sharedInstance].password = _credViewController.txtfPassword.text;
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
    // active hud loading 
    self.hud.textLabel.text = Localize(@"Loading");
    [self.hud setLoading:YES];
    [self.hud show];
	[self view].userInteractionEnabled = NO;
    
	[_credViewController.txtfUsername resignFirstResponder];
	[_credViewController.txtfPassword resignFirstResponder];
	
    NSString* username = [_credViewController.txtfUsername text];
	NSString* password = [_credViewController.txtfPassword text];
    
    self.loginProxy = [[[LoginProxy alloc] initWithDelegate:self] autorelease];
    
    [self.loginProxy authenticateAndGetPlatformInfoWithUsername:username password:password];
}

- (CredentialsViewController*) credentialsViewController {
    return _credViewController;
}

#pragma mark - JMTabView protocol implementation

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex {
    if (itemIndex == AuthenticateTabItemCredentials) {
        _credViewController.view.hidden = NO;
        _servListViewController.view.hidden = YES;
    } else if (itemIndex == AuthenticateTabItemServerList) {
        _credViewController.view.hidden = YES;
        _servListViewController.view.hidden = NO;
    }
}

@end



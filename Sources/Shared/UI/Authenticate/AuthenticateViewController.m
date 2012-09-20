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
#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"

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
    [_tabView release];
    [_loginProxy release];
    [_hud release];
    [_tempUsername release];
    [_tempPassword release];
    [super dealloc];	
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
        _strBSuccessful = [[NSString alloc] init];
        _selectedTabIndex = 0;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView 
{
	[super loadView];
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
    
    // Init username and password text fields
    [self initUsernameAndPassword];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    
	_credViewController.bRememberMe = [UserPreferencesManager sharedInstance].autoLogin;
	_credViewController.bAutoLogin = [UserPreferencesManager sharedInstance].autoLogin;
    // If Auto Login is disabled, we set the Auto Login variable to NO
    // but we don't save this value in the user settings
    // We also refresh the username and password
    if ([self autoLoginIsDisabled]) {
        _credViewController.bAutoLogin = NO;
        [self updateUsernameAndPasswordAfterLogout];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // This variable exists only to prevent from Auto Login
    // automatically after the user has signed out
    // If this method is called, it means the user is not signed in
    // so we can re-enable the Auto Login option
    _bAutoLoginIsDisabled = NO;
}


-(void) doneWithSettings {
    // Called when the Settings popup is closed when the user is signed out
    // Updates the variables with the new values
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    [_credViewController.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    [_credViewController.txtfUsername setPlaceholder:Localize(@"UsernamePlaceholder")];
    [_credViewController.txtfPassword setPlaceholder:Localize(@"PasswordPlaceholder")];
    [_servListViewController.tbvlServerList reloadData];
    _credViewController.bAutoLogin = [UserPreferencesManager sharedInstance].autoLogin;    
    _credViewController.bRememberMe = [UserPreferencesManager sharedInstance].rememberMe;
    [_credViewController signInAnimation:_credViewController.bAutoLogin];
    
    if (!_credViewController.bAutoLogin) {
        // Update the value of the text fields if we don't auto login
        [self updateUsernameAndPassordAfterSettings];
    }
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) initTabsAndViews {
    // empty, must be overriden in _iPad and _iPhone children classes
    // - create the JMView
    // - create views for each tab, using the relevant NIB
}

#pragma mark - Username Password textfields management

-(void) saveTempUsernamePassword {
    [_tempUsername release];
    _tempUsername = [_credViewController.txtfUsername.text copy];
    [_tempPassword release];
    _tempPassword = [_credViewController.txtfPassword.text copy];
}

// Called when the application starts
-(void) initUsernameAndPassword {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_credViewController.bRememberMe = [UserPreferencesManager sharedInstance].rememberMe;
    if (_credViewController.bRememberMe) {
        // Display the saved username and password if we have to
        [_credViewController.txtfUsername setText:[userDefaults objectForKey:EXO_PREFERENCE_USERNAME]];
        [_credViewController.txtfPassword setText:[userDefaults objectForKey:EXO_PREFERENCE_PASSWORD]];
    }
    // Save the original values to detect if they change later
    [self saveTempUsernamePassword];
}

// Refresh username and password values after settings are saved
-(void) updateUsernameAndPassordAfterSettings {
    NSString* currentUsername = _credViewController.txtfUsername.text;
    NSString* currentPassword = _credViewController.txtfPassword.text;
    // Only if the original values have not changed
    if ([currentUsername isEqualToString:_tempUsername] &&
        [currentPassword isEqualToString:_tempPassword]) {
        // Set the stored values only if Remember Me is ON
        if (_credViewController.bRememberMe) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [_credViewController.txtfUsername setText:
                [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]];
            [_credViewController.txtfPassword setText:
                [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD]];
        } else {
            [_credViewController.txtfUsername setText:@""];
            [_credViewController.txtfPassword setText:@""];
        }
        // Save the new values to detect if they change again later
        [self saveTempUsernamePassword];
    }
}

// Refresh username and password values after the user has signed out
-(void) updateUsernameAndPasswordAfterLogout {
    if (!_credViewController.bRememberMe) {
        [_credViewController.txtfUsername setText:@""];
        [_credViewController.txtfPassword setText:@""];
    }
    // Save the new values to detect if they change again later
    [self saveTempUsernamePassword];
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
// Called by LoginProxy when login is successful
- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion {
    // Remake the screen interactions enabled
    self.view.userInteractionEnabled = YES;
    if (compatibleWithSocial) {
        [UserPreferencesManager sharedInstance].username = _credViewController.txtfUsername.text;
        [UserPreferencesManager sharedInstance].password = _credViewController.txtfPassword.text;
        [[UserPreferencesManager sharedInstance] persistUsernameAndPasswod];
        [[ApplicationPreferencesManager sharedInstance] setJcrRepositoryName:platformServerVersion.currentRepoName defaultWorkspace:platformServerVersion.defaultWorkSpaceName userHomePath:platformServerVersion.userHomeNodePath];
    }
}
// Called by LoginProxy when login has failed
- (void)authenticateFailedWithError:(NSError *)error {
    [self view].userInteractionEnabled = YES;
    [self.hud dismiss];
    
    if ([error.domain isEqualToString:RKRestKitErrorDomain] && error.code == RKRequestBaseURLOfflineError) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"NetworkConnection") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    } else if ([error.domain isEqualToString:NSURLErrorDomain] && (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorCannotFindHost)) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"InvalidServer") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];
    }else if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorUserCancelledAuthentication) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(@"WrongUserNamePassword") delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert show];        
    } else {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
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
    if (itemIndex != _selectedTabIndex) {
        if (itemIndex == AuthenticateTabItemCredentials) {
            _credViewController.view.hidden = NO;
            _servListViewController.view.hidden = YES;
        } else if (itemIndex == AuthenticateTabItemServerList) {
            _credViewController.view.hidden = YES;
            _servListViewController.view.hidden = NO;
        }
        _selectedTabIndex = itemIndex;
    }
}

@end



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
#import "CloudUtils.h"

#pragma mark - Authenticate View Controller

@interface AuthenticateViewController ()

@property (nonatomic, retain) LoginProxy *loginProxy;

@end

@implementation AuthenticateViewController

@synthesize loginProxy = _loginProxy;
@synthesize tabView = _tabView;
@synthesize hud = _hud;
@synthesize credentialsViewController = _credViewController;
@synthesize accountListViewController = _servListViewController;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
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
    self.tabView = [[AuthenticateTabView alloc] initWithFrame:CGRectZero];
    self.tabView.delegate = self;
    [self.tabView setBackgroundLayer:nil];
    [self.tabView setSelectionView:[[AuthSelectionView alloc] initWithFrame:CGRectZero]];
    
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
    UITapGestureRecognizer *tapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tapGesure setCancelsTouchesInView:NO]; // Do not cancel touch processes on subviews
    [self.view addGestureRecognizer:tapGesure];
    
    // Init username and password text
    
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
    
	_credViewController.bAutoLogin = [UserPreferencesManager sharedInstance].autoLogin;
    // If Auto Login is disabled, we set the Auto Login variable to NO
    // but we don't save this value in the user settings
    // We also refresh the username and password
    if ([self autoLoginIsDisabled]) {
        _credViewController.bAutoLogin = NO;
        [self autoFillCredentials];
        [self saveTempUsernamePassword];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // This variable exists only to prevent from Auto Login
    // automatically after the user has signed out
    // If this method is called, it means the user is not signed in
    // so we can re-enable the Auto Login option
    _bAutoLoginIsDisabled = NO;
    
    //cloud sign-up, auto fill username and reload server list when the app is opened by an url
    [self autoFillReceivedUserName];
    [_servListViewController.tbvlServerList reloadData]; //reload the server list
}


-(void) doneWithSettings {
    // Called when the Settings popup is closed when the user is signed out
    // Updates the variables with the new values
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    [_credViewController.btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    [_credViewController.txtfUsername setPlaceholder:Localize(@"UsernamePlaceholder")];
    [_credViewController.txtfPassword setPlaceholder:Localize(@"PasswordPlaceholder")];
    _credViewController.bAutoLogin = [UserPreferencesManager sharedInstance].autoLogin;    
    [_credViewController signInAnimation:_credViewController.bAutoLogin];
    
    [_servListViewController.tbvlServerList reloadData];
    
    if (!_credViewController.bAutoLogin) {
        // Update the value of the text fields if we don't auto login
        [self updateUsernameAndPassordAfterSettings];
    }
    
    [self showHideSwitcherTab];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _hud = nil; // release here so it will be re-init next login to avoid orientation issue in MOB-1452
}

-(void) initTabsAndViews
{
    [self showHideSwitcherTab];
}

-(void)showHideSwitcherTab
{
    [self.tabView setShowSwitcherTab:[[ApplicationPreferencesManager sharedInstance] twoOrMoreAccountsExist]];
}
-(void) dealloc {
    _loginProxy.delegate = nil;
}
#pragma mark - Username Password textfields management

-(void) saveTempUsernamePassword {
    _tempUsername = [_credViewController.txtfUsername.text copy];
    _tempPassword = [_credViewController.txtfPassword.text copy];
}

// Called when the application starts
-(void) initUsernameAndPassword {
    [self autoFillCredentials];
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
        [self autoFillCredentials];
        // Save the new values to detect if they change again later
        [self saveTempUsernamePassword];
    }
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
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion {
    
    // Remake the screen interactions enabled
    self.view.userInteractionEnabled = YES;
}

// Called by LoginProxy when login has failed
- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error {
    [self view].userInteractionEnabled = YES;
    //MOB-1453: bug caused by https://github.com/soffes/sstoolkit/issues/147
    //workaround: dismiss hud after clicking OK in alert, in a delegate method
    [self.hud setHidden:YES];
    UIAlertView *alert = [LoginProxyAlert alertWithError:error andDelegate:self];
    [alert show];
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
    
    self.loginProxy = [[LoginProxy alloc] initWithDelegate:self username:username password:password];
    
	NSString *selectedServer = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    if([selectedServer rangeOfString:EXO_CLOUD_HOST].location != NSNotFound) {
        NSString *tenantName = [CloudUtils tenantFromServerUrl:selectedServer];
        //if the selected server is a cloud tenant, check the tenant status first
        if(tenantName) {
            ExoCloudProxy *cloudProxy = [[ExoCloudProxy alloc] init];
            cloudProxy.delegate = self;
            cloudProxy.tenantName = tenantName;
            [cloudProxy checkTenantStatus];
        } else {
            self.hud.hidden = YES;
            [self showAlert:@"NoTenantName"];
        }
    } else {
        [self.loginProxy authenticate];
    }
}

#pragma mark - JMTabView protocol implementation

-(void)tabView:(JMTabView *)tabView didSelectTabAtIndex:(NSUInteger)itemIndex {
    if (itemIndex != _selectedTabIndex) {
        if (itemIndex == AuthenticateTabItemCredentials) {
            _credViewController.view.hidden = NO;
            _servListViewController.view.hidden = YES;
            [self autoFillCredentials];
            [_credViewController setLoginButtonLabel];
        } else if (itemIndex == AuthenticateTabItemServerList) {
            _credViewController.view.hidden = YES;
            _servListViewController.view.hidden = NO;
        }
        _selectedTabIndex = (int)itemIndex;
    }
}
// fills username - password if there is remembered credentials
- (void)autoFillCredentials
{
    if ([self rememberLastUser]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [_credViewController.txtfUsername setText:
         [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]];
        [_credViewController.txtfPassword setText:
         [userDefaults objectForKey:EXO_PREFERENCE_PASSWORD]];
    } else {
        [_credViewController.txtfUsername setText:@""];
        [_credViewController.txtfPassword setText:@""];
    }
}

- (BOOL)rememberLastUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUser = [userDefaults stringForKey:EXO_LAST_LOGGED_USER];
    NSString *tmpKey = [NSString stringWithFormat:@"%@_%@_remember_me",SELECTED_DOMAIN,lastUser];
    NSString *value = [userDefaults objectForKey:tmpKey];
    return value ? [value boolValue] : NO;
}
#pragma mark - Update labels and tabs after logging out
- (void) updateAfterLogOut
{
    [self showHideSwitcherTab];
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
}

#pragma mark UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.hud dismiss];
    [self.hud setHidden:NO];
    [self view].userInteractionEnabled = YES;

}

// auto fill the username when the app receives a request from the browser
- (void)autoFillReceivedUserName
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:EXO_CLOUD_USER_NAME_FROM_URL];
    if(username != NULL && [username length] > 0) {
        _credViewController.txtfUsername.text = username;
        _credViewController.txtfPassword.text = @"";
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:EXO_CLOUD_USER_NAME_FROM_URL];//just fill the first time receiving username
    }
}

#pragma mark ExoCloudProxyDelegate methods
- (void)cloudProxy:(ExoCloudProxy *)cloudProxy handleCloudResponse:(CloudResponse)response forEmail:(NSString *)email
{
    switch (response) {
        case SERVICE_UNAVAILABLE: {
            self.hud.hidden = YES;
            [self showAlert:@"ServiceUnavailable"];
            break;
        }
        case TENANT_CREATION: {
            self.hud.hidden = YES;
            [self showAlert:@"TenantCreation"];
            break;
        }
        case TENANT_ONLINE:
            //if the tenant is online, request the LoginProxy to login
            [self.loginProxy authenticate];
            break;
        case TENANT_RESUMING: {
            self.hud.hidden = YES;
            [self showAlert:@"TenantResuming"];
            break;
        }
        case TENANT_NOT_EXIST: {
            self.hud.hidden = YES;
            [self showAlert:@"ServerNotAvailable"];
            break;
        }
        default:
            break;
    }
}

- (void)cloudProxy:(ExoCloudProxy *)cloudProxy handleError:(NSError *)error
{
    self.hud.hidden = YES;
    [self showAlert:@"NetworkConnectionFailed"];
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Authorization") message:Localize(message) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
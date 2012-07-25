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

#pragma mark Authenticate View Controller


@interface AuthenticateViewController ()

@property (nonatomic, retain) LoginProxy *loginProxy;

@end

@implementation AuthenticateViewController

@synthesize loginProxy = _loginProxy;
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
    // Selectors must be implemented in _iPhone and _iPad subclasses
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
   // [self hitAtView:nil];
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



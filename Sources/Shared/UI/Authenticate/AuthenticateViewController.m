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
#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20

@interface AuthenticateViewController ()

@property (nonatomic, retain) LoginProxy *loginProxy;

@end

@implementation AuthenticateViewController
@synthesize scrollView = _scrollView;
@synthesize activeField = _activeField;
@synthesize loginProxy = _loginProxy;

@synthesize hud = _hud;

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

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavbarBg.png"]]];
        
    }
    
    self.scrollView.contentSize = self.view.frame.size;
    
    _vContainer.backgroundColor = [UIColor clearColor];
    [_vContainer viewWithTag:1].backgroundColor = [UIColor clearColor];
    
    
    //Set Alpha for all subviews to make a small animation
    _vContainer.alpha = 0;
    
    _tbvlServerList.hidden = YES;
    
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
    [_btnSettings setTitle:Localize(@"Settings") forState:UIControlStateNormal];
    
    
    //Add the background image for the login button
    [_btnLogin setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                   stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                         forState:UIControlStateNormal];
    [_btnLogin setTitle:Localize(@"SignInButton") forState:UIControlStateNormal];
    
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
	
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	_bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
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
        [ServerPreferencesManager sharedInstance].isUserLogged = NO;
	}
    
    [_tbvlServerList reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /* register keyboard notification */
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unRegisterForKeyboardNotifications];
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

- (void)viewDidUnload 
{
    [self setScrollView:nil];
	
	NSString* username = [[ServerPreferencesManager sharedInstance] username];
	if(username)
	{
		[_txtfUsername setText:username];
	}
	
	if (_txtfUsername.text.length == 0 && _txtfPassword.text.length == 0) 
	{
		[_txtfUsername becomeFirstResponder];
	}
	
	if (_txtfUsername.text.length > 0)
	{
		[_txtfPassword becomeFirstResponder];
	}
}

- (IBAction)onHitViewBtn:(id)sender {

    [self hitAtView:self.view];
    
}

- (IBAction)onBtnAccount:(id)sender
{
    [_btnAccount setSelected:YES];
    [_btnServerList setSelected:NO];

    //UI Hack
    [_vContainer bringSubviewToFront:_btnAccount];
    [_vContainer sendSubviewToBack:_btnServerList];

    _vServerListView.hidden = YES;
    _vAccountView.hidden = NO;
}

- (IBAction)onBtnServerList:(id)sender
{
    
    [_btnAccount setSelected:NO];
    [_btnServerList setSelected:YES];

    //UI Hack
    [_vContainer bringSubviewToFront:_btnServerList];
    [_vContainer sendSubviewToBack:_btnAccount];

    _vServerListView.hidden = NO;
    _vAccountView.hidden = YES;
    [_tbvlServerList reloadData];
}


- (void)hitAtView:(UIView*) view
{
	if([view class] != [UITextField class])
	{
		[_txtfUsername resignFirstResponder];
		[_txtfPassword resignFirstResponder];
        
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = [self.view convertRect:self.view.frame fromView:nil];
    
    aRect.size.height -= keyboardSize.height;
    
    CGPoint fieldPoint = CGPointMake(_vContainer.frame.origin.x + _txtfPassword.frame.origin.x + _vAccountView.frame.origin.x, _vContainer.frame.origin.y + _txtfPassword.frame.origin.y + _vAccountView.frame.origin.y);
    
    // Scroll the target text field into view.
    if (!CGRectContainsPoint(aRect, fieldPoint)) {
        CGPoint scrollPoint = CGPointMake(0.0, fieldPoint.y - keyboardSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)dismissKeyboard {
    [self.activeField resignFirstResponder];
}

#pragma mark - TextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
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
        [ServerPreferencesManager sharedInstance].username = _txtfUsername.text;
        [ServerPreferencesManager sharedInstance].password = _txtfPassword.text;
        [[ServerPreferencesManager sharedInstance] persistUsernameAndPasswod];
        [[ServerPreferencesManager sharedInstance] setJcrRepositoryName:platformServerVersion.currentRepoName defaultWorkspace:platformServerVersion.defaultWorkSpaceName userHomePath:platformServerVersion.userHomeNodePath];
    }
}

- (void)authenticateFailedWithError:(NSError *)error {
    [self view].userInteractionEnabled = YES;
    [self.hud failAndDismissWithTitle:Localize(@"Error")];
    
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


#pragma mark - UITableView Utils
-(UIImageView *) makeCheckmarkOffAccessoryView
{
    // Uses the same image for iPhone and iPad
        return [[[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOff.png"]] autorelease];
}

-(UIImageView *) makeCheckmarkOnAccessoryView
{
    // Uses the same image for iPhone and iPad
        return [[[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOn.png"]] autorelease];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
    return [[ServerPreferencesManager sharedInstance].serverList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    return kHeightForServerCell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"AuthenticateServerCellIdentifier";
    static NSString *CellNib = @"AuthenticateServerCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellNib];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellNib] autorelease];
        
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
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
    }
    
    
    if (indexPath.row == [ServerPreferencesManager sharedInstance].selectedServerIndex) 
    {
        cell.accessoryView = [self makeCheckmarkOnAccessoryView];
    }
    else
    {
        cell.accessoryView = [self makeCheckmarkOffAccessoryView];
    }
    
	ServerObj* tmpServerObj = [[ServerPreferencesManager sharedInstance].serverList objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpServerObj._strServerName;
    cell.detailTextLabel.text = tmpServerObj._strServerUrl;
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ServerPreferencesManager sharedInstance].selectedServerIndex = indexPath.row;
    
    //Invalidate server informations
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
    [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
    
    // Reload the tableview
    [_tbvlServerList reloadData];
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
    
	[_txtfUsername resignFirstResponder];
	[_txtfPassword resignFirstResponder];
	
    NSString* username = [_txtfUsername text];
	NSString* password = [_txtfPassword text];
    
    self.loginProxy = [[[LoginProxy alloc] initWithDelegate:self] autorelease];
    
    [self.loginProxy authenticateAndGetPlatformInfoWithUsername:username password:password];

}

- (IBAction)onSignInBtn:(id)sender
{
	if([_txtfUsername.text isEqualToString:@""])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
														message:Localize(@"UserNameEmpty")
													   delegate:self 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
        
        [self hitAtView:self.view];
	}
	else
	{		
		[self doSignIn];
	}
}

- (IBAction)onSettingBtn
{
    
}

- (void)dealloc 
{
    [self unRegisterForKeyboardNotifications];
    [_loginProxy release];
	[_txtfUsername release];
	[_txtfPassword release];
    [_hud release];
    [_scrollView release];
    [super dealloc];	
}

@end



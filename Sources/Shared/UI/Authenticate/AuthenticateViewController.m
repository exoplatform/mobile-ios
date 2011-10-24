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
#import "AuthenticateProxy.h"
#import "LanguageHelper.h"
#import "URLAnalyzer.h"


#define kHeigthNeededToGoUpSubviewsWhenEditingUsername -85
#define kHeigthNeededToGoUpSubviewsWhenEditingPassword -150


//Define for cells of the Server Selection Panel
#define kHeightForServerCell 44
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20

@implementation AuthenticateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
	{
		//[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
        _strBSuccessful = [[NSString alloc] init];
        _intSelectedServer = -1;
        _arrServerList = [[NSMutableArray alloc] init];
        
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
        [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBarIphone.png"]]];
        
    }
    
    _vContainer.backgroundColor = [UIColor clearColor];
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    //Hide the Navigation Bar
    self.navigationController.navigationBarHidden = YES;
    
    ServerPreferencesManager* configuration = [ServerPreferencesManager sharedInstance];
    _arrServerList = [configuration getServerList];
    
	[[self navigationItem] setTitle:Localize(@"SignInPageTitle")];	
	
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];
    
	_bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
	_bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
    
	_strHost = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
    if (_strHost == nil) 
    {
        ServerObj* tmpServerObj = [_arrServerList objectAtIndex:_intSelectedServer];
        _strHost = tmpServerObj._strServerUrl;
        [userDefaults setObject:_strHost forKey:EXO_PREFERENCE_DOMAIN];
    }
	
	if(_bRememberMe || _bAutoLogin)
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
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"NO" forKey:EXO_IS_USER_LOGGED];
	}
    
    [_tbvlServerList reloadData];
    
//    if(_bAutoLogin)
//    {
//        _vContainer.alpha = 1;
//        [self onSignInBtn:nil];
//    }
//    else
//    {
//        //Start the animation to display the loginView
//        [UIView animateWithDuration:1.0 
//                         animations:^{
//                             _vContainer.alpha = 1;
//                         }
//         ];
//    }    
    
}

- (void)viewWillDisappear:(BOOL)animated {
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	_strHost = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN];
	
	NSString* username = [userDefaults objectForKey:EXO_PREFERENCE_USERNAME]; 
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

- (IBAction)onBtnAccount:(id)sender
{
    [_btnAccount setSelected:YES];
    [_btnServerList setSelected:NO];
    _vServerListView.hidden = YES;
    _vAccountView.hidden = NO;
}

- (IBAction)onBtnServerList:(id)sender
{
    
    [_btnAccount setSelected:NO];
    [_btnServerList setSelected:YES];
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

#pragma mark PlatformServer
- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion{
    
}

#pragma UITableView Utils
-(UIImageView *) makeCheckmarkOffAccessoryView
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"])
        return [[[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOff.png"]] autorelease];
    
    
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPadOff.png"]] autorelease];
}

-(UIImageView *) makeCheckmarkOnAccessoryView
{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"])
        return [[[UIImageView alloc] initWithImage:
                 [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOn.png"]] autorelease];
    
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
    
    //Invalidate server informations
    [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
    [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
}


- (void)doSignIn
{
    [self hitAtView:nil];
    
    _hud = [[SSHUDView alloc] initWithTitle:Localize(@"Loading")];
    [_hud show];
    
	[self view].userInteractionEnabled = NO;
    
	[_txtfUsername resignFirstResponder];
	[_txtfPassword resignFirstResponder];
	
    [NSThread detachNewThreadSelector:@selector(startSignInProgress) toTarget:self withObject:nil];
    
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
		
	}
	else
	{		
		[self doSignIn];
	}
}

- (void)signInSuccesfully
{    
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
	[userDefaults setObject:_strHost forKey:EXO_PREFERENCE_DOMAIN];
	[userDefaults setObject:_txtfUsername.text forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:_txtfPassword.text forKey:EXO_PREFERENCE_PASSWORD];
    
    //The login has successed we need to check the version of Platform
    PlatformVersionProxy* plfVersionProxy = [[PlatformVersionProxy alloc] initWithDelegate:self];
    [plfVersionProxy retrievePlatformInformations];
    
}

- (void)signInFailed
{
	[self view].userInteractionEnabled = YES;
    [_hud dismiss];
    
}


- (void)startSignInProgress
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	NSString* username = [_txtfUsername text];
	NSString* password = [_txtfPassword text];
    
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:username forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:password forKey:EXO_PREFERENCE_PASSWORD];	
	
	_strBSuccessful = [[AuthenticateProxy sharedInstance] sendAuthenticateRequest:_strHost username:username password:password];
    
    //SLM : Remake the screen interactions enabled
    self.view.userInteractionEnabled = YES;
    
    
	
	if(_strBSuccessful == @"YES")
	{
        //Todo need to be localized
		[self performSelectorOnMainThread:@selector(signInSuccesfully) withObject:nil waitUntilDone:NO];
	}
	else if(_strBSuccessful == @"NO")
	{
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"Authorization")
                                                        message:Localize(@"WrongUserNamePassword")
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(signInFailed) withObject:nil waitUntilDone:NO];		
	}
	else if(_strBSuccessful == @"ERROR")
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"NetworkConnection")
                                                        message:Localize(@"NetworkConnectionFailed")
                                                       delegate:self 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(signInFailed) withObject:nil waitUntilDone:NO];
	}
	
    
	[pool release];
    
}

- (IBAction)onSettingBtn
{
    
}

- (void)dealloc 
{
	[_txtfUsername release];
	[_txtfPassword release];
	[_arrServerList release];
    //[_hud release];
    [super dealloc];	
}

@end



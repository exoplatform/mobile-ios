//
//  AuthenticateViewController.m
//  Authenticate Screen
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright EXO-Platform 2009. All rights reserved.
//

#import "AuthenticateViewController.h"
#import "AppDelegate_iPhone.h"
#import "defines.h"
#import "CXMLDocument.h"
#import "eXoSettingViewController.h"
#import "eXoApplicationsViewController.h"
#import "Connection.h"
#import "DataProcess.h"
#import "NSString+HTML.h"
#import "Configuration.h"
#import "SSHUDView.h"


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
		_selectedLanguage = 0;
        _intSelectedServer = -1;
        _arrServerList = [[NSMutableArray alloc] init];
		isFirstTimeLogin = YES;

        
        
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
    
    _contentView.backgroundColor = [UIColor clearColor];
    
    //Set Alpha for all subviews to make a small animation
    _contentView.alpha = 0;
    
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
    
    
    //Add the background image for the login button
    [_btnLogin setBackgroundImage:[[UIImage imageNamed:@"AuthenticateButtonBgStrechable.png"]
                                      stretchableImageWithLeftCapWidth:10 topCapHeight:10]
                            forState:UIControlStateNormal];
    
    
    _strBSuccessful = @"NO";
}

- (void)viewWillAppear:(BOOL)animated
{
    //Hide the Navigation Bar
    self.navigationController.navigationBarHidden = YES;

    
    
    Configuration* configuration = [Configuration sharedInstance];
    _arrServerList = [configuration getServerList];
    
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	_selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
	NSString* filePath;
	if(_selectedLanguage == 0)
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
    [_tbvlServerList reloadData];
    
    
    //Start the animation to display the loginView
    [UIView animateWithDuration:1.0 
                     animations:^{
                         _contentView.alpha = 1;
                     }
     ];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [_hud dismiss];
    [_hud release];
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

- (void)viewDidDisappear:(BOOL)animated
{
	isFirstTimeLogin = NO;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    //Check the textfield to go up the content of the view
    CGRect frameToGo = self.view.frame;
    
    if (textField == _txtfUsername) {
        frameToGo.origin.y = kHeigthNeededToGoUpSubviewsWhenEditingUsername;
    } else {
        frameToGo.origin.y = kHeigthNeededToGoUpSubviewsWhenEditingPassword;
    }
    
    [UIView animateWithDuration:0.5 
                     animations:^{
                         self.view.frame = frameToGo;
                     }
     ];
     
    
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
        
        //Replace the frame at the good position
        CGRect frameToGo = self.view.frame;
        frameToGo.origin.y = 0;
        
        [UIView animateWithDuration:0.5 
                         animations:^{
                             self.view.frame = frameToGo;
                         }
         ];
        
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
        
        //Replace the frame at the good position
        CGRect frameToGo = self.view.frame;
        frameToGo.origin.y = 0;
        
        [UIView animateWithDuration:0.5 
                         animations:^{
                             self.view.frame = frameToGo;
                         }
         ];
	}
}


#pragma UITableView Utils
-(UIImageView *) makeCheckmarkOffAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOff.png"]] autorelease];
}

-(UIImageView *) makeCheckmarkOnAccessoryView
{
    return [[[UIImageView alloc] initWithImage:
             [UIImage imageNamed:@"AuthenticateCheckmarkiPhoneOn.png"]] autorelease];
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
    /*float fWidth = 150;
    float fHeight = 44.0;
    ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
    NSString* text = tmpServerObj._strServerUrl; 
    CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    fHeight = 44*((int)theSize.height/44 + 1);
    return fHeight;*/
    
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
    
    //[[UILabel alloc] initWithFrame:CGRectMake(2, 5, 150, 30)];
    lbServerName.text = tmpServerObj._strServerName;
    //lbServerName.textColor = [UIColor brownColor];
    //[cell addSubview:lbServerName];
    //[lbServerName release];

//    UILabel* lbServerUrl = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 120, 30)];
//    lbServerUrl.text = tmpServerObj._strServerUrl;
//    [cell addSubview:lbServerUrl];
//    [lbServerUrl release];
//    float fWidth = 150;
    
    
    UILabel* lbServerUrl = (UILabel*)[cell viewWithTag:kTagInCellForServerURLLabel];
    //NSString* text = tmpServerObj._strServerUrl; 
    /*CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    float fHeight = 44*((int)theSize.height/44 + 1) - 10;
    [lbServerUrl setFrame:CGRectMake(140, 5, fWidth, fHeight)];
    [lbServerUrl setNumberOfLines:(int)theSize.height/44 + 1];*/
    lbServerUrl.text = tmpServerObj._strServerUrl;
    //[cell addSubview:lbServerUrl];
    //[lbServerUrl release];

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
	

- (void)login
{
    //TODO: Localize the label
    _hud = [[SSHUDView alloc] initWithTitle:@"Loading..."];
    [_hud show];
    
	[[self navigationItem] setRightBarButtonItem:nil];
	[self view].userInteractionEnabled = NO;

	[_txtfUsername resignFirstResponder];
	[_txtfPassword resignFirstResponder];
	
	
	NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	[startThread start];
	
	endThread = [[NSThread alloc] initWithTarget:self selector:@selector(signInProgress) object:nil];
	[endThread start];
	
	[startThread release];
	
}

- (IBAction)onSettingBtn
{
	eXoApplicationsViewController *apps = [[eXoApplicationsViewController alloc] init];
    apps._dictLocalize = _dictLocalize;
    
    eXoSettingViewController *setting = [[eXoSettingViewController alloc] initWithStyle:UITableViewStyleGrouped delegate:apps];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:setting];
    [setting release];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentModalViewController:navController animated:YES];
    
    
    
    //SettingsViewController_iPhone *setting = [[SettingsViewController_iPhone alloc] initWithNibName:@"SettingsViewController_iPhone"
                                                                                      //     delegate:apps];
    //[setting initWithStyle:UITableViewStyleGrouped delegate:apps];
    
	//[self.navigationController presentModalViewController:setting animated:YES];
}

- (IBAction)onSignInBtn:(id)sender
{
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
		NSRange httpRange = [_strHost rangeOfString:@"http://"];
		if(httpRange.length == 0)
        {
			_strHost = [NSString stringWithFormat:@"http://%@", _strHost];
		}
		[self login];
	}
}

- (void)loginSuccess
{
	AppDelegate_iPhone *appDelegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	//[appDelegate changeToActivityStreamsViewController:_dictLocalize];
    [appDelegate performSelector:@selector(showHomeViewController) withObject:nil afterDelay:1.0];
    //[appDelegate showHomeViewController];
	
	endThread = nil;
    [_indicator stopAnimating];
	[endThread release];
}

- (void)loginFailed
{
	endThread = nil;
	[endThread release];
    [_indicator stopAnimating];
	[self view].userInteractionEnabled = YES;
}

- (void)startInProgress 
{	 
    

	/*NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem* progressBtn = [[UIBarButtonItem alloc] initWithCustomView:_indicator];
	[[self navigationItem] setRightBarButtonItem:progressBtn];
	[pool release];
     */
}

- (void)signInProgress
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	Connection* conn = [[Connection alloc] init];
	
	NSString* username = [_txtfUsername text];
	NSString* password = [_txtfPassword text];
		
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:username forKey:EXO_PREFERENCE_USERNAME];
	[userDefaults setObject:password forKey:EXO_PREFERENCE_PASSWORD];	
	
	_strBSuccessful = [conn sendAuthenticateRequest:_strHost username:username password:password];
    
    //SLM : Remake the screen interactions enabled
    self.view.userInteractionEnabled = YES;
	
	if(_strBSuccessful == @"YES")
	{
        //Todo need to be localized
        [_hud completeAndDismissWithTitle:@"Success..."];
		[self performSelectorOnMainThread:@selector(loginSuccess) withObject:nil waitUntilDone:NO];
	}
	else if(_strBSuccessful == @"NO")
	{
        [_hud dismiss];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"Authorization"]
														 message:[_dictLocalize objectForKey:@"WrongUserNamePassword"]
														delegate:self 
											   cancelButtonTitle:@"OK"
											   otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(loginFailed) withObject:nil waitUntilDone:NO];		
	}
	else if(_strBSuccessful == @"ERROR")
	{
        [_hud dismiss];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[_dictLocalize objectForKey:@"NetworkConnection"]
														 message:[_dictLocalize objectForKey:@"NetworkConnectionFailed"]
														delegate:self 
											   cancelButtonTitle:@"OK"
											   otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		[self performSelectorOnMainThread:@selector(loginFailed) withObject:nil waitUntilDone:NO];
		//[[self navigationItem] setRightBarButtonItem:signInBtn];				
	}
	
	[pool release];

	
}
	
- (void)dealloc 
{
	[_txtfUsername release];
	[_txtfPassword release];
	[_arrServerList release];
    [super dealloc];	
}

@end



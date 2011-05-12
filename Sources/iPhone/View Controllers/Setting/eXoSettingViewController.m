//
//  eXoSetting.m
//  eXoApp
//
//  Created by exo on 9/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "eXoSettingViewController.h"
#import "defines.h"
#import "eXoWebViewController.h"
#import "eXoApplicationsViewController.h"
#import "Configuration.h"
#import "ServerManagerViewController.h"
#import "ContainerCell.h"
#import "CustomBackgroundForCell_iPhone.h"

static NSString *CellIdentifierLogin = @"CellIdentifierLogin";
static NSString *CellIdentifierLanguage = @"CellIdentifierLanguage";
static NSString *CellIdentifierGuide = @"CellIdentifierGuide";
static NSString *CellIdentifierServer = @"AuthenticateServerCellIdentifier";
static NSString *CellNibServer = @"AuthenticateServerCell";

//Define tags for Language cells
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


//Define tag for UISwitch in Login cells
#define kTagForSwitchRememberMe 87
#define kTagForSwitchAutologin 78


//Define tags for Server cells
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20


@implementation eXoSettingViewController

@synthesize _dictLocalize;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
	{
        int a = 1;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) 
	{
		edit = NO;
		
		rememberMe = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
		[rememberMe addTarget:self action:@selector(rememberMeAction) forControlEvents:UIControlEventValueChanged];
        rememberMe.tag = kTagForSwitchRememberMe;
        
		autoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
		[autoLogin addTarget:self action:@selector(autoLoginAction) forControlEvents:UIControlEventValueChanged];
        autoLogin.tag = kTagForSwitchAutologin;
		
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		_selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
		bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
		bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
		
		serverNameStr = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN]; 
		
		_delegate = delegate;
		_dictLocalize = delegate._dictLocalize;
        
        _arrServerList = [[NSMutableArray alloc] init];
        _intSelectedServer = -1;
        
        self.title = @"Settings";
        
        // set up the navigation item and done button
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self action:@selector(done)];
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"done"];
        navigationItem.rightBarButtonItem = buttonItem;
        [self.navigationController.navigationBar pushNavigationItem:navigationItem animated:NO];
        [navigationItem release];
        [buttonItem release];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	self.title = [_dictLocalize objectForKey:@"Settings"];
	[self.tableView reloadData];
    
    //Add the Done button for exit Settings
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self action:@selector(dismissSettings)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"done"];
    self.navigationItem.rightBarButtonItem = buttonItem;
    //[self.navigationController.navigationBar. pushNavigationItem:navigationItem animated:NO];
    [navigationItem release];
    [buttonItem release];
    
    
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[NSString stringWithFormat:@"%d", rememberMe.on] forKey:EXO_REMEMBER_ME];
	[userDefaults setObject:[NSString stringWithFormat:@"%d", autoLogin.on] forKey:EXO_AUTO_LOGIN];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    //Set the background Color of the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0./255 
                                                                          green:106./255 
                                                                           blue:175./255 
                                                                          alpha:1.]];
    
   /* //Customize the Navigation Bar appaerance
    CGRect frameForCustomNavBar = self.navigationController.navigationBar.frame;
    frameForCustomNavBar.origin.y -= 20;
    UIImageView* imageView = [[[UIImageView alloc] initWithFrame:frameForCustomNavBar] autorelease];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.image = [UIImage imageNamed:@"NavBariPhone.png"];
    [self.navigationController.navigationBar insertSubview:imageView atIndex:0];
    */
    //Add the shadow at the bottom of the navigationBar
    UIImageView *navigationBarShadowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GlobalNavigationBarShadowIphone.png"]];
    navigationBarShadowImgV.frame = CGRectMake(0,self.navigationController.navigationBar.frame.size.height,navigationBarShadowImgV.frame.size.width,navigationBarShadowImgV.frame.size.height);
    [self.navigationController.navigationBar addSubview:navigationBarShadowImgV];
    [navigationBarShadowImgV release];
    
     
    _arrServerList = [[Configuration sharedInstance] getServerList];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];
    
    
}

//Method to dismiss settings
- (void)dismissSettings {
    [self. navigationController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)save 
{
	edit = !edit;
	if(edit) 
	{
		rememberMe.enabled = YES;
		autoLogin.enabled = YES;
		self.navigationItem.rightBarButtonItem.title = [_dictLocalize objectForKey:@"Save"];
	}
	else
	{
		rememberMe.enabled = NO;
		autoLogin.enabled = NO;
		self.navigationItem.rightBarButtonItem.title = [_dictLocalize objectForKey:@"Edit"];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:[NSString stringWithFormat:@"%d", _selectedLanguage] forKey:EXO_PREFERENCE_LANGUAGE];		
	}
	[self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}

- (void)rememberMeAction 
{
	NSString *str = @"NO";
	bRememberMe = rememberMe.on;
	if(bRememberMe)
    {
		str = @"YES";
    }
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:str forKey:EXO_REMEMBER_ME];
}

- (void)autoLoginAction 
{
	NSString *str = @"NO";
	bAutoLogin = autoLogin.on;
	if(bAutoLogin)
    {
		str = @"YES";
    }
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:str forKey:EXO_AUTO_LOGIN];
}



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



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 4;
}


#pragma Header methods

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor colorWithRed:54./255 green:54./255 blue:54./255 alpha:1.];
	headerLabel.shadowColor = [UIColor whiteColor];
    headerLabel.shadowOffset = CGSizeMake(1, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:17];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    
    switch (section) 
	{
		case 0:
		{
			headerLabel.text = [_dictLocalize objectForKey:@"SignInButton"];
			break;
		}
			
		case 1:
		{
			headerLabel.text = [_dictLocalize objectForKey:@"Language"];
			break;
		}
			
		case 2:
		{
			headerLabel.text = [_dictLocalize objectForKey:@"ServerList"];
			break;
		}
            
		case 3:
		{
			headerLabel.text = [_dictLocalize objectForKey:@"UserGuide"];
			break;
		}
			
		default:
			break;
	}
	    
	[customView addSubview:headerLabel];
    [headerLabel release];
    
	return customView;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString* tmpStr = @"";
	switch (section) 
	{
		case 0:
		{
			tmpStr = [_dictLocalize objectForKey:@"SignInButton"];
			break;
		}
			
		case 1:
		{
			tmpStr = [_dictLocalize objectForKey:@"Language"];
			break;
		}
			
		case 2:
		{
			tmpStr = [_dictLocalize objectForKey:@"ServerList"];
			break;
		}
            
		case 3:
		{
			tmpStr = [_dictLocalize objectForKey:@"UserGuide"];
			break;
		}
			
		default:
			break;
	}
	
	return tmpStr;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int numofRows = 0;
	if(section == 0)
	{
		numofRows = 2;
	}	
	if(section == 1)
	{	
		numofRows = 2;
	}	
	if(section == 2)
	{	
		numofRows = [_arrServerList count] + 1;
	}
    if(section == 3)
	{	
		numofRows = 1;
	}
    
	return numofRows;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fHeight = 44.0;
    /*if(indexPath.section == 2)
	{
        if (indexPath.row < [_arrServerList count]) 
        {
            float fWidth = 150;
            float fHeight = 44.0;
            ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
            NSString* text = tmpServerObj._strServerUrl; 
            CGSize theSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:18.0f] constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            fHeight = 44*((int)theSize.height/44 + 1);
            return fHeight;
        }
    }*/
    return fHeight;
}





// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CustomBackgroundForCell_iPhone *cell;
    
    
    switch (indexPath.section) 
    {
        case 0:
        {
            
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierLogin];
            if(cell == nil) 
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierLogin] autorelease];
                
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            //Remove previous UISwith
            [[cell viewWithTag:kTagForSwitchRememberMe] removeFromSuperview];
            [[cell viewWithTag:kTagForSwitchRememberMe] removeFromSuperview];
            
            
            if(indexPath.row == 0)
            {
                cell.textLabel.text = [_dictLocalize objectForKey:@"RememberMe"];
                rememberMe.on = bRememberMe;
                [cell addSubview:rememberMe];
            }
            else 
            {
                cell.textLabel.text = [_dictLocalize objectForKey:@"AutoLogin"];
                autoLogin.on = bAutoLogin;
                [cell addSubview:autoLogin];
            }
            break;
            
        }
            
        case 1: 
        {
            
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierLanguage];
            if(cell == nil) 
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierLanguage] autorelease];
                
                UIImageView* imgV;
                UILabel* titleLabel;
                
                imgV = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 14.0, 27, 17)];
                imgV.tag = kTagForCellSubviewImageView;
                [cell addSubview:imgV];
                [imgV release];
                
                titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 250.0, 20.0)];
                titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                titleLabel.textColor = [UIColor darkGrayColor];
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.tag = kTagForCellSubviewTitleLabel;
                [cell addSubview:titleLabel];
                [titleLabel release];
                
            }
            
            if(indexPath.row == 0)
            {
                UIImageView *imgV = (UIImageView *) [cell viewWithTag:kTagForCellSubviewImageView];
                imgV.image = [UIImage imageNamed:@"EN.gif"];
                
                UILabel *titleLabel = (UILabel *) [cell viewWithTag:kTagForCellSubviewTitleLabel];
                titleLabel.text = [_dictLocalize objectForKey:@"English"];
            }
            else
            {
                UIImageView *imgV = (UIImageView *) [cell viewWithTag:kTagForCellSubviewImageView];
                imgV.image = [UIImage imageNamed:@"FR.gif"];
                
                UILabel *titleLabel = (UILabel *) [cell viewWithTag:kTagForCellSubviewTitleLabel];
                titleLabel.text = [_dictLocalize objectForKey:@"French"];
            }
            
            //Put the checkmark
            
            if (indexPath.row == _selectedLanguage) 
            {
                cell.accessoryView = [self makeCheckmarkOnAccessoryView];
            }
            else
            {
                cell.accessoryView = [self makeCheckmarkOffAccessoryView];
            }
            break;
        }
            
        case 2:
        {
            
            
            
            cell = (CustomBackgroundForCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierServer];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellNibServer owner:self options:nil];
                cell = (CustomBackgroundForCell_iPhone *)[nib objectAtIndex:0];
                
                UILabel* lbServerName = (UILabel*)[cell viewWithTag:kTagInCellForServerNameLabel];
                lbServerName.textColor = [UIColor darkGrayColor];
                
                UILabel* lbServerUrl = (UILabel*)[cell viewWithTag:kTagInCellForServerURLLabel];
                lbServerUrl.textColor = [UIColor darkGrayColor];
                
            }
            
            if (indexPath.row < [_arrServerList count]) 
            {
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
                
                
            }
            else
            {
                
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModifyList"] autorelease];
                UILabel* lbModify = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
                [lbModify setTextAlignment:UITextAlignmentCenter];
                lbModify.textColor = [UIColor darkGrayColor];
                lbModify.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                [lbModify setText:[_dictLocalize objectForKey:@"ServerModify"]];
                lbModify.backgroundColor = [UIColor clearColor];
                [cell addSubview:lbModify];
                [lbModify release];
            }
            break;
            
            
            
        }
            
        case 3:
        {
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierGuide];
            if(cell == nil) 
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGuide] autorelease];
             
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textColor = [UIColor darkGrayColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
             
            cell.textLabel.text = [_dictLocalize objectForKey:@"UserGuide"];
            break;
        }
            
        default:
            break;
    }
    
    
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    
	
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.section == 1)
	{
		_selectedLanguage = indexPath.row;
		[_delegate setSelectedLanguage:_selectedLanguage];
		_dictLocalize = _delegate._dictLocalize;
		[[self.navigationController.tabBarController.viewControllers objectAtIndex:0] 
         setTitle:[_dictLocalize objectForKey:@"ApplicationsTitle"]];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:[NSString stringWithFormat:@"%d", rememberMe.on] forKey:EXO_REMEMBER_ME];
		[userDefaults setObject:[NSString stringWithFormat:@"%d", autoLogin.on] forKey:EXO_AUTO_LOGIN];
		[userDefaults setObject:[NSString stringWithFormat:@"%d", _selectedLanguage] forKey:EXO_PREFERENCE_LANGUAGE];
		
		[self viewWillAppear:YES];
	}
	else if(indexPath.section == 2)
	{
        if (indexPath.row < [_arrServerList count]) 
        {
            ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
            _intSelectedServer = indexPath.row;
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:tmpServerObj._strServerUrl forKey:EXO_PREFERENCE_DOMAIN];
            [userDefaults setObject:[NSString stringWithFormat:@"%d",_intSelectedServer] forKey:EXO_PREFERENCE_SELECTED_SEVER];
            [tableView reloadData];
        }
        else
        {
            if (_serverManagerViewController == nil) 
            {
                _serverManagerViewController = [[ServerManagerViewController alloc] initWithNibName:@"ServerManagerViewController" bundle:nil];
            }
            /*if([self.navigationController.viewControllers containsObject: _serverManagerViewController])
            {
                [self.navigationController popToViewController:_serverManagerViewController animated:YES];
            }
            else
            {*/
                [self.navigationController pushViewController:_serverManagerViewController animated:YES];		
            //}
        }
	}
	else if(indexPath.section == 3)
    {
		eXoWebViewController *userGuideController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController" bundle:nil url:nil];
		userGuideController._delegate = _delegate;
		[self.navigationController pushViewController:userGuideController animated:YES];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:txtfDomainName.text forKey:EXO_PREFERENCE_DOMAIN];
	[textField resignFirstResponder];
	return YES;
}


@end


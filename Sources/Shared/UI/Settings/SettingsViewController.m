//
//  SettingsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "defines.h"
//#import "eXoWebViewController.h"
#import "ServerPreferencesManager.h"
#import "ServerManagerViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPhone.h"
#import "JTNavigationView.h"
#import "JTRevealSidebarView.h"


static NSString *CellIdentifierLogin = @"CellIdentifierLogin";
static NSString *CellIdentifierLanguage = @"CellIdentifierLanguage";
static NSString *CellIdentifierServer = @"AuthenticateServerCellIdentifier";
static NSString *CellIdentifierServerInformation = @"AuthenticateServerInformationCellIdentifier";

//Define tags for Language cells
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


//Define tag for UISwitch in Login cells
#define kTagForSwitchRememberMe 87
#define kTagForSwitchAutologin 78


//Define tags for Server cells
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20


#define kTagInCellForServerVersion 400

@interface SettingsViewController (PrivateMethods)
-(void)setNavigationBarLabels;
@end




@implementation SettingsViewController

@synthesize settingsDelegate = _settingsDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) 
	{
		
		rememberMe = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        rememberMe.tag = kTagForSwitchRememberMe;
        
		autoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        autoLogin.tag = kTagForSwitchAutologin;
        
    }
    return self;
}


- (void)dealloc
{
    [rememberMe release];
    [autoLogin release];
    [super dealloc];
}


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    [self reloadSettingsWithUpdate];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[self saveSettingsInformations];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Unselect the selected row if any
    NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
    if (selection)
        [self.tableView deselectRowAtIndexPath:selection animated:YES];   
}

-(void)startRetrieve {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if(![[userDefaults objectForKey:EXO_IS_USER_LOGGED] boolValue]){
        bVersionServer = NO;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(retrievePlatformVersion)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(retrievePlatformVersion)];
        [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
    } else {
        bVersionServer = YES;
    }
    
}

-(void)retrievePlatformVersion{
    PlatformVersionProxy* plfVersionProxy = [[PlatformVersionProxy alloc] initWithDelegate:self];
    [plfVersionProxy retrievePlatformInformations];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [autoLogin addTarget:self action:@selector(autoLoginChange) forControlEvents:UIControlEventValueChanged];
    
    
    //if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBarIphone.png"] forBarMetrics:UIBarMetricsDefault];
    //}
    
    
    [self loadSettingsInformations];
    
    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    //backgroundView.frame = self.view.frame;
    //self.tableView.backgroundView = backgroundView;
    //[backgroundView release];
    
    
    
    //self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
    
    self.tableView.backgroundColor = EXO_BACKGROUND_COLOR;
    
    //Add the Done button for exit Settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"DoneButton") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    
    self.title = Localize(@"Settings");
}

- (void)platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion {
     NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if(platformServerVersion){
        //Setup Version Platfrom and Application
        [userDefaults setObject:platformServerVersion.platformVersion forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:platformServerVersion.platformEdition forKey:EXO_PREFERENCE_EDITION_SERVER];
        [userDefaults synchronize];
    } else {
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_VERSION_SERVER];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_EDITION_SERVER];
        [userDefaults synchronize];
    }
    bVersionServer = YES;
    [self.tableView reloadData];
}


#pragma - UI Customizations for cells

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



#pragma - Settings Methods

- (void)setNavigationBarLabels {
    self.title = Localize(@"Settings");
    self.navigationItem.rightBarButtonItem.title = Localize(@"DoneButton");
}


-(void)reloadSettingsWithUpdate {
    [self loadSettingsInformations];
    [self setNavigationBarLabels];
    [self.tableView reloadData];
}

-(void)autoLoginChange {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d", autoLogin.on] forKey:EXO_AUTO_LOGIN];
    [userDefaults synchronize];
}


-(void)loadSettingsInformations {
    //Load Settings informations
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] boolValue];
    bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] boolValue];
}


- (void)saveSettingsInformations {
    //Save settings informations
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[NSString stringWithFormat:@"%d", rememberMe.on] forKey:EXO_REMEMBER_ME];
	[userDefaults setObject:[NSString stringWithFormat:@"%d", autoLogin.on] forKey:EXO_AUTO_LOGIN];
}



#pragma - Actions Methods 

//Method to done clicked settings
- (void)doneAction {
    [_settingsDelegate doneWithSettings];    
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
	headerLabel.textColor = [UIColor darkGrayColor];
	headerLabel.shadowColor = [UIColor whiteColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:17];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    
    switch (section) 
	{
		case 0:
		{
			headerLabel.text = Localize(@"SignInButton");
			break;
		}
			
		case 1:
		{
			headerLabel.text = Localize(@"Language");
			break;
		}
			
		case 2:
		{
			headerLabel.text = Localize(@"ServerList");
			break;
		}
            
        case 3:
		{
			headerLabel.text = Localize(@"ApplicationsInformation");
			break;
		}   
			
		default:
			break;
            
	}
    
	[customView addSubview:headerLabel];
    [headerLabel release];
    
	return customView;
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
		numofRows = [[ServerPreferencesManager sharedInstance].serverList count] + 1;
	}
    if(section == 3)
	{	
		numofRows = 3;
	}
    
	return numofRows;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float fHeight = 44.0;
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
            }
            
            //Remove previous UISwith
            [[cell viewWithTag:kTagForSwitchRememberMe] removeFromSuperview];
            [[cell viewWithTag:kTagForSwitchRememberMe] removeFromSuperview];
            
            
            if(indexPath.row == 0)
            {
                cell.textLabel.text = Localize(@"RememberMe");
                rememberMe.on = bRememberMe;
                cell.accessoryView = rememberMe;
            }
            else 
            {
                cell.textLabel.text = Localize(@"AutoLogin");
                autoLogin.on = bAutoLogin;
                cell.accessoryView = autoLogin;
            }
            break;
            
        }
            
        case 1: 
        {
            
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierLanguage];
            if(cell == nil) 
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierLanguage] autorelease];
                
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                
            }
            
            if(indexPath.row == 0)
            {
                cell.imageView.image = [UIImage imageNamed:@"EN.gif"];                
                cell.textLabel.text = Localize(@"English");
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"FR.gif"];
                cell.textLabel.text = Localize(@"French");
            }
            
            //Put the checkmark
            int selectedLanguage = [[LanguageHelper sharedInstance] getSelectedLanguage];
            if (indexPath.row == selectedLanguage) 
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
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierServer] autorelease];
                
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
                cell.detailTextLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.backgroundColor = [UIColor clearColor]; 
            }
            
            if (indexPath.row < [[ServerPreferencesManager sharedInstance].serverList count]) 
            {
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
                
                //Unable selection of the server from Settings
                [cell setUserInteractionEnabled:NO];
            }
            else
            {
                
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModifyList"] autorelease];
                
                [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.text = Localize(@"ServerModify");
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            }
            
            
            
            break;
        }
            
            
        case 3:
        {
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierServerInformation];
            if(cell == nil) {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifierServerInformation] autorelease];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
                cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
                cell.detailTextLabel.textColor = [UIColor grayColor];
                
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.detailTextLabel.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }   
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
               
            //Create an image streachable images for background
            if(indexPath.row == 0){
                cell.textLabel.text = Localize(@"ServerVersion");
                cell.detailTextLabel.text = [userDefaults objectForKey:EXO_PREFERENCE_VERSION_SERVER];
            }
            if(indexPath.row == 1){
                cell.textLabel.text = Localize(@"ApplicationEdition");
                cell.detailTextLabel.text = [userDefaults objectForKey:EXO_PREFERENCE_EDITION_SERVER];
            }
            if(indexPath.row == 2){
                cell.textLabel.text = Localize(@"ApplicationVersion");
                cell.detailTextLabel.text = [userDefaults objectForKey:EXO_PREFERENCE_VERSION_APPLICATION];
            }
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
		int selectedLanguage = indexPath.row;
        
        //Save the language
        [[LanguageHelper sharedInstance] changeToLanguage:selectedLanguage];
        
        //Save other settings (autologin, rememberme)
        [self saveSettingsInformations];
        
        //Finally reload the content of the screen
        [self reloadSettingsWithUpdate];
	}
    
	else if(indexPath.section == 2)
	{
        if (indexPath.row == [[ServerPreferencesManager sharedInstance].serverList count]) 
        {
            _serverManagerViewController = [[ServerManagerViewController alloc] initWithNibName:@"ServerManagerViewController" bundle:nil];
            
            [self.navigationController pushViewController:_serverManagerViewController animated:YES];
        }
	}
	else if(indexPath.section == 3)
    {
        //		eXoWebViewController *userGuideController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController" bundle:nil url:nil];
        //		[self.navigationController pushViewController:userGuideController animated:YES];
	}
    
}





@end

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
static NSString *CellIdentifierSocial = @"CellIdentifierSocial";
static NSString *CellIdentifierDocuments = @"CellIdentifierDocuments";
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

@interface SettingsViewController ()

@property (nonatomic, retain) LoginProxy* plfVersionProxy;

-(void)setNavigationBarLabels;
- (void)doInit;
- (void)rememberStreamChanged:(id)sender;

@end


static NSString *settingViewSectionIdKey = @"section id";
static NSString *settingViewSectionTitleKey = @"section title";
static NSString *settingViewRowsKey = @"row title";

typedef enum {
  SettingViewControllerSectionLogin = 1,
  SettingViewControllerSectionSocial = 2,
  SettingViewControllerSectionDocument = 3,
  SettingViewControllerSectionLanguage = 4,
  SettingViewControllerSectionServerList = 5,
  SettingViewControllerSectionAppsInfo = 6
} SettingViewControllerSection;

@implementation SettingsViewController

@synthesize settingsDelegate = _settingsDelegate;
@synthesize plfVersionProxy = _plfVersionProxy;

- (void)doInit {
    if ([ServerPreferencesManager sharedInstance].isUserLogged) {
        _listOfSections = [[NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionLogin],
                             settingViewSectionTitleKey, @"SignInButton", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"RememberMe", @"AutoLogin", nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionSocial],
                             settingViewSectionTitleKey, @"Social", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"KeepSelectedStream", nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionDocument],
                             settingViewSectionTitleKey, @"Documents", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"ShowPrivateDrive", nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionLanguage],
                             settingViewSectionTitleKey, @"Language", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"English", @"French", nil],
                             nil], 
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionServerList],
                             settingViewSectionTitleKey, @"ServerList", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"ServerModify", nil],
                             nil], 
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionAppsInfo],
                             settingViewSectionTitleKey, @"ApplicationsInformation", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"ServerVersion", @"ApplicationEdition", @"ApplicationVersion",nil],
                             nil], 
                            nil] retain];
    } else {        
        _listOfSections = [[NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionLanguage],
                             settingViewSectionTitleKey, @"Language", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"English", @"French", nil],
                             nil], 
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d",SettingViewControllerSectionServerList],
                             settingViewSectionTitleKey, @"ServerList", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"ServerModify", nil],
                             nil], 
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionAppsInfo],
                             settingViewSectionTitleKey, @"ApplicationsInformation", 
                             settingViewRowsKey, [NSArray arrayWithObjects:@"ServerVersion", @"ApplicationEdition", @"ApplicationVersion",nil],
                             nil], 
                            nil] retain];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) 
	{
		
        [self doInit];
		rememberMe = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        rememberMe.tag = kTagForSwitchRememberMe;
        
		autoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        autoLogin.tag = kTagForSwitchAutologin;
        [autoLogin addTarget:self action:@selector(autoLoginChange) forControlEvents:UIControlEventValueChanged];
        
        _rememberSelectedStream = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        [_rememberSelectedStream addTarget:self action:@selector(rememberStreamChanged:) forControlEvents:UIControlEventValueChanged];
        
        _showPrivateDrive = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        [_showPrivateDrive addTarget:self action:@selector(showPrivateDriveDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}


- (void)dealloc
{
    [_plfVersionProxy release];
    [rememberMe release];
    [autoLogin release];
    [_rememberSelectedStream release];
    [_showPrivateDrive release];
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
    if(![ServerPreferencesManager sharedInstance].isUserLogged){
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
    self.plfVersionProxy = [[[LoginProxy alloc] initWithDelegate:self] autorelease];
    [self.plfVersionProxy retrievePlatformInformations];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
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

#pragma mark - PlatformVersionProxyDelegate

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

- (void)authenticateFailedWithError:(NSError *)error {
    
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
    [ServerPreferencesManager sharedInstance].autoLogin = autoLogin.on;
}


-(void)loadSettingsInformations {
    //Load Settings informations
    bRememberMe = [ServerPreferencesManager sharedInstance].rememberMe;
    rememberMe.on = bRememberMe;
    bAutoLogin = [ServerPreferencesManager sharedInstance].autoLogin;
    autoLogin.on = bAutoLogin;
    _showPrivateDrive.on = [ServerPreferencesManager sharedInstance].showPrivateDrive;
}


- (void)saveSettingsInformations {
    //Save settings informations
    [ServerPreferencesManager sharedInstance].rememberMe = rememberMe.on;
    [ServerPreferencesManager sharedInstance].autoLogin = autoLogin.on;
}



#pragma - Actions Methods 

//Method to done clicked settings
- (void)doneAction {
    [_settingsDelegate doneWithSettings];    
}

- (void)rememberStreamChanged:(id)sender {
    [ServerPreferencesManager sharedInstance].rememberSelectedSocialStream = _rememberSelectedStream.on;
}

- (void)showPrivateDriveDidChange:(id)sender {
    [ServerPreferencesManager sharedInstance].showPrivateDrive = _showPrivateDrive.on;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return [_listOfSections count];
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
    headerLabel.text = Localize([[_listOfSections objectAtIndex:section] objectForKey:settingViewSectionTitleKey]);
    
	[customView addSubview:headerLabel];
    [headerLabel release];
    
	return customView;
}




// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int numofRows = 0;
	if([[[_listOfSections objectAtIndex:section] objectForKey:settingViewSectionIdKey] intValue] == SettingViewControllerSectionServerList)
	{	
		numofRows = [[ServerPreferencesManager sharedInstance].serverList count] + 1;
	} else {
        numofRows = [[[_listOfSections objectAtIndex:section] objectForKey:settingViewRowsKey] count];
    }
    
	return numofRows;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}





// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomBackgroundForCell_iPhone *cell;
    SettingViewControllerSection sectionId = [[[_listOfSections objectAtIndex:indexPath.section] objectForKey:settingViewSectionIdKey] intValue];
    switch (sectionId) 
    {
        case SettingViewControllerSectionLogin:
        {
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierLogin];
            if(cell == nil) 
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierLogin] autorelease];
                
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            // No need to set the value of the switch, it is done in loadSettingsInformation
            // Only set the correct switch in the accessoryView of the cell
            if(indexPath.row == 0)
            {
                cell.accessoryView = rememberMe;
            }
            else 
            {
                cell.accessoryView = autoLogin;
            }
            break;
        }
        case SettingViewControllerSectionSocial: 
        {
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierSocial];
            if(cell == nil) 
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierLogin] autorelease];
                
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            _rememberSelectedStream.on = [ServerPreferencesManager sharedInstance].rememberSelectedSocialStream;
            cell.accessoryView = _rememberSelectedStream;
            break;
        }
        case SettingViewControllerSectionDocument:
        {
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierDocuments];
            if (cell == nil) {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierDocuments]
                        autorelease];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            // No need to set the value of the switch, it is done in loadSettingsInformation                
            // Only set the correct switch in the accessoryView of the cell
            cell.accessoryView = _showPrivateDrive;
            break;
        }
        case SettingViewControllerSectionLanguage: 
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
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"FR.gif"];
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
        case SettingViewControllerSectionServerList:
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
                cell.textLabel.text = Localize([[[_listOfSections objectAtIndex:indexPath.section] objectForKey:settingViewRowsKey] objectAtIndex:0]);
                [cell.textLabel setTextAlignment:UITextAlignmentCenter];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
            }
            
            
            
            break;
        }
        case SettingViewControllerSectionAppsInfo:
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
                cell.detailTextLabel.text = [userDefaults objectForKey:EXO_PREFERENCE_VERSION_SERVER];
            }
            if(indexPath.row == 1){
                cell.detailTextLabel.text = [userDefaults objectForKey:EXO_PREFERENCE_EDITION_SERVER];
            }
            if(indexPath.row == 2){
                cell.detailTextLabel.text = [userDefaults objectForKey:EXO_PREFERENCE_VERSION_APPLICATION];
            }
            break;
        }
            
        default:
            break;
    }
    if (sectionId != SettingViewControllerSectionServerList) {
        cell.textLabel.text = Localize([[[_listOfSections objectAtIndex:indexPath.section] objectForKey:settingViewRowsKey] objectAtIndex:indexPath.row]);
    
    }
    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SettingViewControllerSection sectionId = [[[_listOfSections objectAtIndex:indexPath.section] objectForKey:settingViewSectionIdKey] intValue];
	if (sectionId == SettingViewControllerSectionLanguage)
	{
		int selectedLanguage = indexPath.row;
        
        //Save the language
        [[LanguageHelper sharedInstance] changeToLanguage:selectedLanguage];
        
        //Save other settings (autologin, rememberme)
        [self saveSettingsInformations];
        
        //Finally reload the content of the screen
        [self reloadSettingsWithUpdate];
        
        //Notify the language change
        [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_CHANGE_LANGUAGE object:self];
	}
    
	else if (sectionId == SettingViewControllerSectionServerList)
	{
        if (indexPath.row == [[ServerPreferencesManager sharedInstance].serverList count]) 
        {
                ServerManagerViewController *_serverManagerViewController = [[[ServerManagerViewController alloc] initWithNibName:@"ServerManagerViewController" bundle:nil] autorelease];
            [self.navigationController pushViewController:_serverManagerViewController animated:YES];
        }
	}
    
}





@end

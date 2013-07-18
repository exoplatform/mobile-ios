//
//  SettingsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "defines.h"
#import "UserPreferencesManager.h"
#import "ApplicationPreferencesManager.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPhone.h"
#import "JTNavigationView.h"
#import "JTRevealSidebarView.h"
#import "URLAnalyzer.h"
#import "ServerEditingViewController.h"
#import "ServerAddingViewController.h"
#import "SignUpViewController_iPhone.h"
#import "WelcomeViewController_iPhone.h"
#import "WelcomeViewController_iPad.h"
#import "AppDelegate_iPad.h"
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
- (void) rememberMeDidChange:(id)sender;
- (void) showPrivateDriveDidChange:(id)sender;
- (void) rememberStreamDidChange:(id)sender;
- (void) autoLoginDidChange;

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
    SettingViewControllerSectionAppsInfo = 6,
    SettingViewControllerCloudAssistant = 7
} SettingViewControllerSection;

@implementation SettingsViewController

@synthesize settingsDelegate = _settingsDelegate;
@synthesize plfVersionProxy = _plfVersionProxy;

- (void)doInit {
    if ([UserPreferencesManager sharedInstance].isUserLogged) {
        _listOfSections = [[NSMutableArray arrayWithObjects:
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
                             settingViewRowsKey, [NSArray arrayWithObjects:@"NewServer", nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionAppsInfo],
                             settingViewSectionTitleKey, @"ApplicationsInformation",
                             settingViewRowsKey, [NSArray arrayWithObjects:@"ServerVersion", @"ApplicationEdition", @"ApplicationVersion",nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:settingViewSectionIdKey,[NSString stringWithFormat:@"%d",SettingViewControllerCloudAssistant],settingViewSectionTitleKey,@"eXoCloudConfigurationAssistant", settingViewRowsKey, [NSArray arrayWithObjects:@"StartTheConfigurationAssistant", nil],nil],
                            nil] retain];
        
        
        float plfVersion = [[[NSUserDefaults standardUserDefaults] stringForKey:EXO_PREFERENCE_VERSION_SERVER] floatValue];
        
        //PLF 4: dont show 'Show my private drive' in settings, cf: MOB-1425
        if(plfVersion >= 4.0) {
            [_listOfSections removeObjectAtIndex:2];
        }
    } else {
        _listOfSections = [[NSMutableArray arrayWithObjects:
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionLanguage],
                             settingViewSectionTitleKey, @"Language",
                             settingViewRowsKey, [NSArray arrayWithObjects:@"English", @"French", nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d",SettingViewControllerSectionServerList],
                             settingViewSectionTitleKey, @"ServerList",
                             settingViewRowsKey, [NSArray arrayWithObjects:@"NewServer", nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:
                             settingViewSectionIdKey, [NSString stringWithFormat:@"%d", SettingViewControllerSectionAppsInfo],
                             settingViewSectionTitleKey, @"ApplicationsInformation",
                             settingViewRowsKey, [NSArray arrayWithObjects:@"ServerVersion", @"ApplicationEdition", @"ApplicationVersion",nil],
                             nil],
                            [NSDictionary dictionaryWithKeysAndObjects:settingViewSectionIdKey,[NSString stringWithFormat:@"%d",SettingViewControllerCloudAssistant],settingViewSectionTitleKey,@"eXoCloudConfigurationAssistant", settingViewRowsKey, [NSArray arrayWithObjects:@"StartTheConfigurationAssistant", nil], nil],
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
        // Create the Remember Me switch component
		rememberMe = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        rememberMe.tag = kTagForSwitchRememberMe;
        // Call the method enableDisableAutoLogin when the value of the switch changes
        [rememberMe addTarget:self action:@selector(rememberMeDidChange:) forControlEvents:UIControlEventValueChanged];
        // Create the Auto Login switch component
		autoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        autoLogin.tag = kTagForSwitchAutologin;
        [autoLogin addTarget:self action:@selector(autoLoginDidChange) forControlEvents:UIControlEventValueChanged];
        // Observe notifications when a server is added or deleted, and call enableDisableAutoLogin
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableDisableAutoLogin:) name:EXO_NOTIFICATION_SERVER_ADDED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableDisableAutoLogin:) name:EXO_NOTIFICATION_SERVER_DELETED object:nil];
        
        _rememberSelectedStream = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        [_rememberSelectedStream addTarget:self action:@selector(rememberStreamDidChange:) forControlEvents:UIControlEventValueChanged];
        
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXO_NOTIFICATION_SERVER_ADDED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EXO_NOTIFICATION_SERVER_DELETED object:nil];
    [super dealloc];
}


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {

    [self setNavigationBarLabels];
    [self.tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated
{
    // Unselect the selected row if any
    NSIndexPath*	selection = [self.tableView indexPathForSelectedRow];
    if (selection)
        [self.tableView deselectRowAtIndexPath:selection animated:YES];   
}

// enables autoLogin switch if and only if rememberMe switch
// is on and server is selected.
-(void)enableDisableAutoLogin:(id)sender {
    NSString* selDomain = [[ApplicationPreferencesManager sharedInstance] selectedDomain];
    if (rememberMe.on && selDomain != nil) {
        autoLogin.enabled = YES;
    } else {
        autoLogin.enabled = NO;
        autoLogin.on = NO;
    }
}
-(void)startRetrieve {
    if(![UserPreferencesManager sharedInstance].isUserLogged){
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
    
    self.tableView.backgroundColor = EXO_BACKGROUND_COLOR;
    
    //Add the Done button for exit Settings
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:Localize(@"DoneButton") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    
    self.title = Localize(@"Settings");
}

#pragma mark - PlatformVersionProxyDelegate
- (void)loginProxy:(LoginProxy *)proxy platformVersionCompatibleWithSocialFeatures:(BOOL)compatibleWithSocial withServerInformation:(PlatformServerVersion *)platformServerVersion
{
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

- (void)loginProxy:(LoginProxy *)proxy authenticateFailedWithError:(NSError *)error
{
    
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

#pragma - Actions Methods 

//Method to done clicked settings
- (void)doneAction {
    [_settingsDelegate doneWithSettings];    
}

#pragma mark - Listeners for switches
- (void)rememberStreamDidChange:(id)sender {
    [UserPreferencesManager sharedInstance].rememberSelectedSocialStream = _rememberSelectedStream.on;
}

- (void)showPrivateDriveDidChange:(id)sender {
    [UserPreferencesManager sharedInstance].showPrivateDrive = _showPrivateDrive.on;
}

- (void)rememberMeDidChange:(id)sender {
    [self enableDisableAutoLogin:self];
    [UserPreferencesManager sharedInstance].rememberMe = rememberMe.on;
    if (!rememberMe.on) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_USERNAME];
        [userDefaults setObject:@"" forKey:EXO_PREFERENCE_PASSWORD];
        [userDefaults synchronize];
    } else {
        [[UserPreferencesManager sharedInstance] persistUsernameAndPasswod];
    }

}

-(void)autoLoginDidChange {
    [UserPreferencesManager sharedInstance].autoLogin = autoLogin.on;
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
		numofRows = [[ApplicationPreferencesManager sharedInstance].serverList count] + 1;
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
        case SettingViewControllerCloudAssistant:
        {
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if(cell == nil)
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
                
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            break;
        }
        
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
                rememberMe.on = [UserPreferencesManager sharedInstance].rememberMe;
                cell.accessoryView = rememberMe;
            }
            else 
            {
                if ([UserPreferencesManager sharedInstance].rememberMe) {
                    autoLogin.enabled = YES;
                    autoLogin.on = [UserPreferencesManager sharedInstance].autoLogin;
                } else {
                    autoLogin.enabled = NO;
                }
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
            _rememberSelectedStream.on = [UserPreferencesManager sharedInstance].rememberSelectedSocialStream;
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
            _showPrivateDrive.on = [UserPreferencesManager sharedInstance].showPrivateDrive;
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
            
            if (indexPath.row < [[ApplicationPreferencesManager sharedInstance].serverList count]) 
            {
                if (indexPath.row == [ApplicationPreferencesManager sharedInstance].selectedServerIndex) 
                {
                    cell.accessoryView = [self makeCheckmarkOnAccessoryView];
                }
                else
                {
                    cell.accessoryView = [self makeCheckmarkOffAccessoryView];
                }
                
                ServerObj* tmpServerObj = [[ApplicationPreferencesManager sharedInstance].serverList objectAtIndex:indexPath.row];
                
                cell.textLabel.text = tmpServerObj._strServerName;
                cell.detailTextLabel.text = tmpServerObj._strServerUrl;
                
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
    
    if(sectionId == SettingViewControllerCloudAssistant) {
        WelcomeViewController *welcomeVC;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            welcomeVC = [[WelcomeViewController_iPad alloc] initWithNibName:@"WelcomeViewController_iPad" bundle:nil];
            welcomeVC.shouldBackToSetting = YES;
            [self presentModalViewController:welcomeVC animated:YES];
        } else {
            
            welcomeVC = [[[WelcomeViewController_iPhone alloc] initWithNibName:@"WelcomeViewController_iPhone" bundle:nil] autorelease];
            welcomeVC.shouldBackToSetting = YES;
            welcomeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentModalViewController:welcomeVC animated:YES];
            
        }
    }
    
	else if (sectionId == SettingViewControllerSectionLanguage)
	{
		int selectedLanguage = indexPath.row;
        
        //Save the language
        [[LanguageHelper sharedInstance] changeToLanguage:selectedLanguage];
        
        
        //Finally reload the content of the screen
        [self setNavigationBarLabels];
        [self.tableView reloadData];
        
        //Notify the language change
        [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_CHANGE_LANGUAGE object:self];
	}
    
	else if (sectionId == SettingViewControllerSectionServerList)
	{
        if (indexPath.row == [[ApplicationPreferencesManager sharedInstance].serverList count]) 
        {
            ServerAddingViewController* serverAddingViewController = [[ServerAddingViewController alloc] initWithNibName:@"ServerAddingViewController" bundle:nil];
            [serverAddingViewController setDelegate:self];
            [self.navigationController pushViewController:serverAddingViewController animated:YES];
            [serverAddingViewController release];
        } else {
            ApplicationPreferencesManager *appPrefManager = [ApplicationPreferencesManager sharedInstance];
            if(![UserPreferencesManager sharedInstance].isUserLogged || appPrefManager.selectedServerIndex != indexPath.row) {
                ServerObj* tmpServerObj = [appPrefManager.serverList objectAtIndex:indexPath.row];
                
                ServerEditingViewController* serverEditingViewController = [[ServerEditingViewController alloc] initWithNibName:@"ServerEditingViewController" bundle:nil];
                [serverEditingViewController setDelegate:self];
                [serverEditingViewController setServerObj:tmpServerObj andIndex:indexPath.row];
                
                [self.navigationController pushViewController:serverEditingViewController animated:YES];
                [serverEditingViewController release];
            }
        }
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewControllerSection sectionId = [[[_listOfSections objectAtIndex:indexPath.section] objectForKey:settingViewSectionIdKey] intValue];
    if (sectionId == SettingViewControllerSectionServerList) {
        ApplicationPreferencesManager *appPrefManager = [ApplicationPreferencesManager sharedInstance];
        return !([UserPreferencesManager sharedInstance].isUserLogged && appPrefManager.selectedServerIndex == indexPath.row) && indexPath.row < [appPrefManager.serverList count];        
    } else {
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewControllerSection sectionId = [[[_listOfSections objectAtIndex:indexPath.section] objectForKey:settingViewSectionIdKey] intValue];
    if (sectionId == SettingViewControllerSectionServerList) {
        return UITableViewCellEditingStyleDelete;        
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self deleteServerObjAtIndex:indexPath.row]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_SERVER_DELETED object:self];
    }
}

#pragma mark - ServerManagerProtocol

- (BOOL)nameContainSpecialCharacter:(NSString*)str inSet:(NSString *)chars {
    
    NSCharacterSet *invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:chars];
    NSRange range = [str rangeOfCharacterFromSet:invalidCharSet];
    return (range.length > 0);
    
}

- (BOOL)checkServerInfo:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl {
    
    //Check if the server name is null or empty
    if (strServerName == nil || [strServerName length] == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorServer") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    // Check if the name contains some forbidden characters: & < > " '
    if ([self nameContainSpecialCharacter:strServerName inSet:@"&<>\"'"]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"SpecialCharacters") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    }
    // Check if the server URL is null
    if(strServerUrl == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorServer") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return NO;
    } else {
        // Check if the server URL is valid :
        // - characters & < > " ' ! ; \ | ( ) { } [ ] , * % are forbidden
        // - URL must start with http or https
        // - scheme and host must not be null or empty
        NSURL* tmpUrl = [NSURL URLWithString:strServerUrl];
        if ([self nameContainSpecialCharacter:strServerUrl inSet:@"&<>\"'!;\\|(){}[],*%"] ||
            tmpUrl == nil || tmpUrl.scheme == nil || tmpUrl.host == nil ||
            (![[tmpUrl.scheme lowercaseString] isEqualToString:@"http"] &&
             ![[tmpUrl.scheme lowercaseString] isEqualToString:@"https"]
             ) || tmpUrl.host.length == 0) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"InvalidUrl") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return NO;
            }
    }
    
    return YES;
}

// Unique private method to add/edit a server, avoids duplicating common code
- (BOOL) addEditServerWithServerName:(NSString*) strServerName andServerUrl:(NSString*) strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password  atIndex:(int)index {
    
    if (![[strServerUrl lowercaseString] hasPrefix:@"http://"] && 
        ![[strServerUrl lowercaseString] hasPrefix:@"https://"]) {
        strServerUrl = [NSString stringWithFormat:@"http://%@", strServerUrl];
    }   
    // Check whether the name and URL are correctly formed
    if(![self checkServerInfo:strServerName andServerUrl:strServerUrl])
        return NO;
    
    // If the name and URL are well formed, we remove some unnecessary characters
    NSString* cleanServerName = [strServerName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* cleanServerUrl = [URLAnalyzer parserURL:[strServerUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    ApplicationPreferencesManager *appPrefManager = [ApplicationPreferencesManager sharedInstance];
    if(index == -1) {
        // Check whether the name and URL already exists, ignoring case
        if ([appPrefManager checkServerAlreadyExistsWithName:cleanServerName andURL:cleanServerUrl ignoringIndex:index] > -1) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"MessageErrorExist") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    
    username = [username length] > 0 ? username : @"";
    password = [password length] > 0 ? password : @"";
    
    [appPrefManager addEditServerWithServerName:cleanServerName andServerUrl:cleanServerUrl withUsername:username andPassword:password atIndex:index];
    
    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password
{
    return [self addEditServerWithServerName:strServerName andServerUrl:strServerUrl withUsername:username andPassword:password atIndex:-1];
}

- (BOOL)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password
{
    return [self addEditServerWithServerName:strServerName andServerUrl:strServerUrl withUsername:username andPassword:password atIndex:index];
}

- (BOOL)deleteServerObjAtIndex:(int)index;
{
    ApplicationPreferencesManager *appPrefManager = [ApplicationPreferencesManager sharedInstance];
    [appPrefManager deleteServerObjAtIndex:index];
    [self.tableView reloadData];
    return YES;
}

@end

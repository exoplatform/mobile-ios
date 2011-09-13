//
//  SettingsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 13/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "defines.h"
#import "eXoWebViewController.h"
#import "Configuration.h"
#import "ServerManagerViewController.h"
#import "ContainerCell.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "LanguageHelper.h"


static NSString *CellIdentifierLogin = @"CellIdentifierLogin";
static NSString *CellIdentifierLanguage = @"CellIdentifierLanguage";
static NSString *CellIdentifierGuide = @"CellIdentifierGuide";
static NSString *CellIdentifierServer = @"AuthenticateServerCellIdentifier";

//Define tags for Language cells
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


//Define tag for UISwitch in Login cells
#define kTagForSwitchRememberMe 87
#define kTagForSwitchAutologin 78


//Define tags for Server cells
#define kTagInCellForServerNameLabel 10
#define kTagInCellForServerURLLabel 20




@interface SettingsViewController (PrivateMethods)
-(void)setNavigationBarLabels;
@end




@implementation SettingsViewController

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
		
        _arrServerList = [[NSMutableArray alloc] init];
        _intSelectedServer = -1;
        
        self.title = @"Settings";
        
            }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated {
    
}


- (void)viewWillDisappear:(BOOL)animated
{
	[self saveSettingsInformations];
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self loadSettingsInformations];

    //Set the background Color of the view
    //SLM note : to optimize the appearance, we can initialize the background in the dedicated controller (iPhone or iPad)
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]];
    backgroundView.frame = self.view.frame;
    self.tableView.backgroundView = backgroundView;
    [backgroundView release];
    
    //Customize the navigation bar appearance
    UIImageView *navigationBarShadowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GlobalNavigationBarShadowIphone.png"]];
    navigationBarShadowImgV.frame = CGRectMake(0,self.navigationController.navigationBar.frame.size.height,navigationBarShadowImgV.frame.size.width,navigationBarShadowImgV.frame.size.height);
    [self.navigationController.navigationBar addSubview:navigationBarShadowImgV];
    [navigationBarShadowImgV release];
    

    //Add the Done button for exit Settings
    _doneBarButtonItem = [[UIBarButtonItem alloc]
                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                          target:self action:@selector(dismissSettings)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Done"];
    self.navigationItem.rightBarButtonItem = _doneBarButtonItem;
    [navigationItem release];

    
    [self setNavigationBarLabels];
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
    _doneBarButtonItem.title = Localize(@"Done");
}


-(void)reloadSettingsWithUpdate {
    [self loadSettingsInformations];
    [self setNavigationBarLabels];
    [self.tableView reloadData];
}


-(void)loadSettingsInformations {
    //Load Settings informations
    _arrServerList = [[Configuration sharedInstance] getServerList];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];
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

//Method to dismiss settings
- (void)dismissSettings {
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(1, 1);
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
			headerLabel.text = Localize(@"UserGuide");
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
			tmpStr = Localize(@"SignInButton");
			break;
		}
			
		case 1:
		{
			tmpStr = Localize(@"Language");
			break;
		}
			
		case 2:
		{
			tmpStr = Localize(@"ServerList");
			break;
		}
            
		case 3:
		{
			tmpStr = Localize(@"UserGuide");
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
            cell = (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierGuide];
            if(cell == nil) 
            {
                cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierGuide] autorelease];
                
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = Localize(@"UserGuide");
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
        if (indexPath.row == [_arrServerList count]) 
        {
            _serverManagerViewController = [[ServerManagerViewController alloc] initWithNibName:@"ServerManagerViewController" bundle:nil];
            [self.navigationController pushViewController:_serverManagerViewController animated:YES];		
            
        }
	}
	else if(indexPath.section == 3)
    {
		eXoWebViewController *userGuideController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController" bundle:nil url:nil];
		[self.navigationController pushViewController:userGuideController animated:YES];
	}
}






@end

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

static NSString *CellIdentifier = @"MyIdentifier";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333
#define kTagForCellSubviewServerNameLabel 444
#define kTagForCellSubviewServerUrlLabel 555
#define kTagForCellSubviewTitleLabel111 666


@implementation eXoSettingViewController

@synthesize _dictLocalize;

- (id)initWithStyle:(UITableViewStyle)style delegate:(eXoApplicationsViewController *)delegate
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) 
	{
		edit = NO;
		
		rememberMe = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
		[rememberMe addTarget:self action:@selector(rememberMeAction) forControlEvents:UIControlEventValueChanged];
		autoLogin = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
		[autoLogin addTarget:self action:@selector(autoLoginAction) forControlEvents:UIControlEventValueChanged];
		
		NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
		_selectedLanguage = [[userDefaults objectForKey:EXO_PREFERENCE_LANGUAGE] intValue];
		bRememberMe = [[userDefaults objectForKey:EXO_REMEMBER_ME] intValue];
		bAutoLogin = [[userDefaults objectForKey:EXO_AUTO_LOGIN] intValue];
		
		serverNameStr = [userDefaults objectForKey:EXO_PREFERENCE_DOMAIN]; 
		
		_delegate = delegate;
		_dictLocalize = delegate._dictLocalize;
        
        _arrServerList = [[NSMutableArray alloc] init];
        _intSelectedServer = -1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	self.title = [_dictLocalize objectForKey:@"Settings"];
	[self.tableView reloadData];
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
    _arrServerList = [[Configuration sharedInstance] getServerList];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _intSelectedServer = [[userDefaults objectForKey:EXO_PREFERENCE_SELECTED_SEVER] intValue];
}

- (void)dealloc 
{
    [_arrServerList release];
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
	if(bAutoLogin)
		str = @"YES";
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:@"NO" forKey:EXO_REMEMBER_ME];
}

- (void)autoLoginAction 
{
	NSString *str = @"NO";
	bAutoLogin = autoLogin.on;
	if(bAutoLogin)
		str = @"YES";
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:str forKey:EXO_AUTO_LOGIN];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 4;
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


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int section = indexPath.section;
    int row = indexPath.row;
    
    if(cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        
        switch (section) 
        {
            case 0:
            {
                UILabel* lbTitleName = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 150, 30)];
                lbTitleName.tag = kTagForCellSubviewTitleLabel;
                lbTitleName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                [cell addSubview:lbTitleName];
                [lbTitleName release];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if(row == 0)
                {
                    [cell addSubview:rememberMe];
                    [rememberMe release];
                }
                else 
                {
                    [cell addSubview:autoLogin];
                    [autoLogin release];
                }
                break;
            }
                
            case 1: 
            {
                UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 14.0, 27, 17)];
                imgV.tag = kTagForCellSubviewImageView;
                [cell addSubview:imgV];
                
                UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 250.0, 20.0)];
                titleLabel.tag = kTagForCellSubviewTitleLabel;
                titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                [cell addSubview:titleLabel];
                
                [imgV release];
                [titleLabel release];
                
                
                break;
            }
                
            case 2:
            {
                if (row < [_arrServerList count]) 
                {   
                    UILabel* lbServerName = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 150, 30)];
                    lbServerName.tag = kTagForCellSubviewServerNameLabel;
                    lbServerName.textColor = [UIColor brownColor];
                    [cell addSubview:lbServerName];
                    [lbServerName release];
                    
                    UILabel* lbServerUrl = [[UILabel alloc] initWithFrame:CGRectMake(170, 5, 100, 30)];
                    lbServerUrl.tag = kTagForCellSubviewServerUrlLabel;
                    [cell addSubview:lbServerUrl];
                    [lbServerUrl release];
                }
                else
                {
                    UILabel* lbModify = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
                    lbModify.tag = kTagForCellSubviewTitleLabel;
                    [lbModify setTextAlignment:UITextAlignmentCenter];
                    lbModify.textColor = [UIColor redColor];
                    [cell addSubview:lbModify];
                    [lbModify release];
                }
                break;
            }
                
            case 3:
            {
                UILabel* lbTitleName = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 150, 30)];
                lbTitleName.tag = kTagForCellSubviewTitleLabel111;
                lbTitleName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                [cell addSubview:lbTitleName];
                [lbTitleName release];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                break;
            }
                
            default:
                break;
        }
    }
    
    switch (indexPath.section) 
    {
        case 0:
        {
            UILabel* titleLabel = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel];
            cell.accessoryType = UITableViewCellAccessoryNone;
            if(row == 0)
            {
                titleLabel.text = [_dictLocalize objectForKey:@"RememberMe"];
                rememberMe.hidden = NO;
                rememberMe.on = bRememberMe;
            }
            else 
            {
                titleLabel.text = [_dictLocalize objectForKey:@"AutoLogin"];
                autoLogin.hidden = NO;
                autoLogin.on = bAutoLogin;
            }
            break;
        }
            
        case 1: 
        {
            UIImageView* imgV = (UIImageView *)[cell viewWithTag:kTagForCellSubviewImageView];
            UILabel* titleLabel = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel];
            if(row == 0)
            {
                imgV.image = [UIImage imageNamed:@"EN.gif"];
                titleLabel.text = [_dictLocalize objectForKey:@"English"];
            }
            else
            {
                imgV.image = [UIImage imageNamed:@"FR.gif"];
                titleLabel.text = [_dictLocalize objectForKey:@"French"];
            }
            
            if(indexPath.row == _selectedLanguage)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } 
            else
            {            
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        }
            
        case 2:
        {
            if (row < [_arrServerList count]) 
            {
                ServerObj* tmpServerObj = [_arrServerList objectAtIndex:indexPath.row];
                
                UILabel* lbServerName = (UILabel *)[cell viewWithTag:kTagForCellSubviewServerNameLabel];
                lbServerName.text = tmpServerObj._strServerName;
                
                UILabel* lbServerUrl = (UILabel *)[cell viewWithTag:kTagForCellSubviewServerUrlLabel];
                lbServerUrl.text = tmpServerObj._strServerUrl;
                
                if (indexPath.row == _intSelectedServer) 
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                else
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
            else
            {
                UILabel* lbModify = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel];
                [lbModify setText:[_dictLocalize objectForKey:@"ServerModify"]];
            }
            break;
        }
            
        case 3:
        {
            
            NSArray *arr = [cell subviews];
            for (int i = 0; i < [arr count]; i++) {
                if([[arr objectAtIndex:i] isEqual:rememberMe] || [[arr objectAtIndex:i] isEqual:autoLogin])
                {
                    [[arr objectAtIndex:i] setHidden:YES];
                    break;
                }
            }
            
            UILabel* titleLabel = (UILabel *)[cell viewWithTag:kTagForCellSubviewTitleLabel111];
            if(titleLabel == nil)
            {
                titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 150, 30)];
                titleLabel.tag = kTagForCellSubviewTitleLabel111;
                titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                [cell addSubview:titleLabel];
                [titleLabel release];
            }
            
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            titleLabel.text = [_dictLocalize objectForKey:@"UserGuide"];	
			
            break;
        }
            
        default:
            break;
    }
	
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
            if([self.navigationController.viewControllers containsObject: _serverManagerViewController])
            {
                [self.navigationController popToViewController:_serverManagerViewController animated:YES];
            }
            else
            {
                [self.navigationController pushViewController:_serverManagerViewController animated:YES];		
            }
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


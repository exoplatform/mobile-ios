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

static NSString *CellIdentifier = @"MyIdentifier";
#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


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
}

-(void)save 
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


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
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
		numofRows = 3;
	}	
	if(section == 1)
	{	
		numofRows = 2;
	}	
	if(section == 2)
	{	
		numofRows = 1;
	}
	return numofRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
        switch (indexPath.section) 
        {
            case 0:
            {
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if(indexPath.row == 0) {
                    
                    cell.textLabel.text = [_dictLocalize objectForKey:@"DomainCellTitle"];
                    
                    txtfDomainName = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 200, 30)];
                    txtfDomainName.delegate = self;
                    txtfDomainName.keyboardType = UIKeyboardTypeASCIICapable;
                    txtfDomainName.returnKeyType = UIReturnKeyDone;
                    txtfDomainName.autocorrectionType = UITextAutocorrectionTypeNo;
                    txtfDomainName.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    txtfDomainName.clearButtonMode = UITextFieldViewModeWhileEditing;
                    
                    txtfDomainName.text = serverNameStr;
                    
                    [cell addSubview:txtfDomainName];
                    
                }
                else if(indexPath.row == 1)
                {
                    cell.textLabel.text = [_dictLocalize objectForKey:@"RememberMe"];
                    rememberMe.on = bRememberMe;
                    [cell addSubview:rememberMe];
                }
                else {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.text = [_dictLocalize objectForKey:@"AutoLogin"];
                    autoLogin.on = bAutoLogin;
                    
                    [cell addSubview:autoLogin];
                }
                
            }
                break;
                
            case 1: 
            {
                
                if(indexPath.row == 0)
                {
                    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 14.0, 27, 17)];
                    imgV.image = [UIImage imageNamed:@"EN.gif"];
                    [cell addSubview:imgV];
                    [imgV release];
                    
                    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 250.0, 20.0)];
                    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                    titleLabel.text = [_dictLocalize objectForKey:@"English"];
                    [cell addSubview:titleLabel];
                    [titleLabel release];
                    
                }
                else
                {
                    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(17.0, 14.0, 27, 17)];
                    imgV.image = [UIImage imageNamed:@"FR.gif"];
                    [cell addSubview:imgV];	
                    [imgV release];
                    
                    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 250.0, 20.0)];
                    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
                    titleLabel.text = [_dictLocalize objectForKey:@"French"];
                    [cell addSubview:titleLabel];	
                    [titleLabel release];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
                
            case 2:
            {
                cell.textLabel.text = [_dictLocalize objectForKey:@"UserGuide"];				
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];			
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            }
                break;
                
            default:
                break;
        }

    }
	
    // Set up the cell...
    if(indexPath.section == 1) {
        if(indexPath.row == _selectedLanguage)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)rememberMeAction 
{
	NSString *str = @"NO";
	bRememberMe = rememberMe.on;
	if(bAutoLogin)
		str = @"YES";
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:@"NO" forKey:EXO_REMEMBER_ME];
}

-(void)autoLoginAction 
{
	NSString *str = @"NO";
	bAutoLogin = autoLogin.on;
	if(bAutoLogin)
		str = @"YES";
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:str forKey:EXO_AUTO_LOGIN];
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
		eXoWebViewController *userGuideController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController"
																							 bundle:nil url:nil];
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

- (void)dealloc {
    [super dealloc];
}


@end


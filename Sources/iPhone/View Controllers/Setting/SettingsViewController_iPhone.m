//
//  eXoSetting.m
//  eXoApp
//
//  Created by exo on 9/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController_iPhone.h"
#import "eXoWebViewController.h"
#import "Configuration.h"
#import "ServerManagerViewController.h"
#import "LanguageHelper.h"



@implementation SettingsViewController_iPhone


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


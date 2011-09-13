//
//  iPadSettingViewController.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import "SettingsViewController_iPad.h"


@implementation SettingsViewController_iPad



/*
- (void)onBtnDone
{
    [self dismissModalViewControllerAnimated:YES];
    
	if(_delegate && [_delegate respondsToSelector:@selector(signInAnimation:)])
    {
        if(bAutoLogin)
            [_delegate signInAnimation:1];
        else
            [_delegate signInAnimation:2];
    }
    
}
*/

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(indexPath.section == 1)
	{
		int selectedLanguage = indexPath.row;
		[[self.navigationController.tabBarController.viewControllers objectAtIndex:0] 
         setTitle:Localize(@"ApplicationsTitle")];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setObject:[NSString stringWithFormat:@"%d", rememberMe.on] forKey:EXO_REMEMBER_ME];
		[userDefaults setObject:[NSString stringWithFormat:@"%d", autoLogin.on] forKey:EXO_AUTO_LOGIN];
		[[LanguageHelper sharedInstance] changeToLanguage:selectedLanguage];
		
		[_delegate setSelectedLanguage:selectedLanguage];
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
            //Show _iPadServerManagerViewController
            if (_iPadServerManagerViewController == nil) 
            {
                _iPadServerManagerViewController = [[iPadServerManagerViewController alloc] initWithNibName:@"iPadServerManagerViewController" bundle:nil];
                [_iPadServerManagerViewController setDelegate:_delegate];
                [_iPadServerManagerViewController setInterfaceOrientation:_interfaceOrientation];
            }
            
            [self.navigationController pushViewController:_iPadServerManagerViewController animated:YES];
            
            [tblView deselectRowAtIndexPath:indexPath animated:YES];
        }
	}
	else if(indexPath.section == 3)
    {
        
		eXoWebViewController *userGuideController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController" bundle:nil url:nil];
		userGuideController._delegate = _delegate;
		[self.navigationController pushViewController:userGuideController animated:YES];
        
	}
}
*/



@end


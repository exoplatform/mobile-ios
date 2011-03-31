//
//  iPadSettingViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class eXoApplicationsViewController;
@class ServerManagerViewController;

@interface iPadSettingViewController : UITableViewController <UITextFieldDelegate> {
	BOOL bRememberMe;
	BOOL bAutoLogin;
	NSString *languageStr;
	NSString *serverNameStr;
	
	UISwitch *rememberMe;
	UISwitch *autoLogin;
	UITextField *txtfDomainName;
	NSString*	_localizeStr;
	int			_selectedLanguage;
	NSDictionary*	_dictLocalize;
	BOOL edit;
	
    NSMutableArray*                 _arrServerList;
    int                             _intSelectedServer;
    ServerManagerViewController*    _serverManagerViewController;
}

@property(nonatomic, retain) NSDictionary*	_dictLocalize;


@end


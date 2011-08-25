//
//  eXoSetting.h
//  eXoApp
//
//  Created by exo on 9/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@class ServerManagerViewController;

@interface eXoSettingViewController : UITableViewController <UITextFieldDelegate> {
	BOOL bRememberMe;
	BOOL bAutoLogin;
	NSString *languageStr;
	NSString *serverNameStr;
	
	UISwitch *rememberMe;
	UISwitch *autoLogin;
	UITextField *txtfDomainName;
	NSString*	_localizeStr;
	BOOL edit;
	
    NSMutableArray*                 _arrServerList;
    int                             _intSelectedServer;
    ServerManagerViewController*    _serverManagerViewController;
}


- (id)initWithStyle:(UITableViewStyle)style;

@end

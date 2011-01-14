//
//  SettingViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{	
	id										_delegate;
	IBOutlet UITableView*					_tblLanguage;
	NSDictionary*							_dictLocalize;
	int										_intSelectedLanguage;
}

- (void)setDelegate:(id)delegate;
- (void)localize;
@end

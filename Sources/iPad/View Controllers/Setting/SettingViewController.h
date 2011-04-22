//
//  SettingViewController.h
//  eXoMobile
//
//  Created by Tran Hoai Son on 5/31/10.
//  Copyright 2010 home. All rights reserved.
//

#import <Foundation/Foundation.h>

//Change language
@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{	
	id										_delegate;	//The delegate
	IBOutlet UITableView*					_tblLanguage;	//Language list
	NSDictionary*							_dictLocalize;	//Language dictionary
	int										_intSelectedLanguage;	//Language index
}

- (void)setDelegate:(id)delegate;	//Set delegate
- (void)localize;	//Set language dictionary
@end

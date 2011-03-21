//
//  MoreLiveChat.h
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;

//Display all current chats
@interface MoreLiveChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

	IBOutlet UITableView *_tblLiveChat;	//Current chat list
	IBOutlet UIButton *_btnCloseAllLiveChat;	//Close button
	
	NSArray *arrLiveChat;	//List of current chat
	MainViewController* _delegate;	//The delegate
	UIPopoverController *_popViewController;	//View for show current chat list
	NSDictionary*		_dictLocalize;	//Language dictionary
}

@property(nonatomic, retain) NSArray *arrLiveChat;
@property(nonatomic, retain) MainViewController* _delegate;
@property(nonatomic, retain) UIPopoverController *_popViewController;

//Constructor
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil liveChat:(NSArray *)arr delegate:(MainViewController *)delegate;
//Close action
-(IBAction)closeAllLiveChat;

@end

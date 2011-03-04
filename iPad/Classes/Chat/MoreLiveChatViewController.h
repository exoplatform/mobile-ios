//
//  MoreLiveChat.h
//  eXoMobile
//
//  Created by Mai Thanh Xuyen on 9/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainViewController;

@interface MoreLiveChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

	IBOutlet UITableView *_tblLiveChat;
	IBOutlet UIButton *_btnCloseAllLiveChat;
	
	NSArray *arrLiveChat;
	MainViewController* _delegate;
	UIPopoverController *_popViewController;
	NSDictionary*		_dictLocalize;
}

@property(nonatomic, retain) NSArray *arrLiveChat;
@property(nonatomic, retain) MainViewController* _delegate;
@property(nonatomic, retain) UIPopoverController *_popViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil liveChat:(NSArray *)arr delegate:(MainViewController *)delegate;
-(IBAction)closeAllLiveChat;

@end

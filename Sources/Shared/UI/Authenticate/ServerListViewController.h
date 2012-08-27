//
//  ServerListViewController.h
//  eXo Platform
//
//  Created by exoplatform on 7/18/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerPreferencesManager.h"


@interface ServerListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView*  tbvlServerList;
@property (nonatomic, retain) IBOutlet UIImageView*  panelBackground;

@end

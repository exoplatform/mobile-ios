//
//  ServerManagerViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerAddingViewController;
@class ServerEditingViewController;

@interface ServerManagerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView*           _tbvlServerList;
    NSMutableArray*                 _arrServerList;
    ServerAddingViewController*     _serverAddingViewController;
    ServerEditingViewController*    _serverEditingViewController;
}

- (void)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (void)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (void)deleteServerObjAtIndex:(int)index;
@end

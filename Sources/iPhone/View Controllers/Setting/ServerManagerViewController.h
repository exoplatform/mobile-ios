//
//  ServerManagerViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 3/28/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eXoViewController.h"

@protocol ServerManagerProtocol <NSObject>
- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (BOOL)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl;
- (BOOL)deleteServerObjAtIndex:(int)index;
@end



@interface ServerManagerViewController : eXoViewController <UITableViewDelegate, UITableViewDataSource, ServerManagerProtocol>
{
    IBOutlet UITableView*           _tbvlServerList;
}


@end

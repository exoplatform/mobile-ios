//
//  HomeViewController_iPhone.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@class Connection;

@interface HomeViewController_iPhone : TTViewController <TTLauncherViewDelegate> {
    id                  _delegate;
    TTLauncherView*     _launcherView;
    
    Connection*			_conn;
}

- (void)setDelegate:(id)delegate;
@end

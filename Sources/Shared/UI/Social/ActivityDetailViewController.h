//
//  ActivityDetailViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@class ActivityDetailMessageTableViewCell;
@class ActivityDetailLikeTableViewCell;

@interface ActivityDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView*                   _tblvActivityDetail;
    Activity*                               _activity;
    
    //Cell for the content of the message
    ActivityDetailMessageTableViewCell*     _cellForMessage;
    
    //Cell for the like part of the screen
    ActivityDetailLikeTableViewCell*        _cellForLikes;
    
}

- (void)setActivity:(Activity*)activity;
@end

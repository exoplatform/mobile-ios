//
//  ActivityDetailViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface ActivityDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView*           _tblvActivityDetail;
    Activity*                       _activity;
}

- (void)setActivity:(Activity*)activity;
@end

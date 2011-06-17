//
//  ActivityStreamBrowseViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]

@class MockSocial_Activity;
@class ActivityDetailViewController;

@interface ActivityStreamBrowseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView*           _tblvActivityStream;
    MockSocial_Activity*            _mockSocial_Activity;
    
    NSMutableArray*                 _arrayOfSectionsTitle;
    NSMutableDictionary*            _sortedActivities;
    ActivityDetailViewController*   _activityDetailViewController;
}

@end

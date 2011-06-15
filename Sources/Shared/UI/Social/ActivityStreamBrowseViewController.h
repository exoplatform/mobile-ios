//
//  ActivityStreamBrowseViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MockSocial_Activity;

@interface ActivityStreamBrowseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView*           _tblvActivityStream;
    MockSocial_Activity*            _mockSocial_Activity;
}

@end

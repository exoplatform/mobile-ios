//
//  ActivityStreamViewController_iPhone.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"

@class MockSocial_Activity;

@interface ActivityStreamViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView*           _tblvActivityStream;
    MockSocial_Activity*            _mockSocial_Activity;
}

@end

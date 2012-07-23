//
//  ActivityStreamTabbar.h
//  eXo Platform
//
//  Created by Le Thanh Quang on 7/20/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMTabView.h"

enum {
  ActivityStreamTabItemAllUpdate = 0,
  ActivityStreamTabItemMyConnections = 1,
  ActivityStreamTabItemMySpaces = 2,
  ActivityStreamTabItemMyStatus = 3
} ActivityStreamTabItem;

@interface ActivityStreamTabbar : UIView {
    NSMutableArray *_listOfItems;
}

@property (nonatomic, retain) JMTabView *tabView;
// enable or diable translucent effect
- (void)translucentView:(BOOL)translucent;

@end

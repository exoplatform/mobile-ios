//
//  ActivityDetailAdvancedInfoCell.h
//  eXo Platform
//
//  Created by exoplatform on 6/5/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMTabView.h"

@class SocialActivity;

@interface ActivityDetailAdvancedInfoCell_iPad : UITableViewCell <JMTabViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) JMTabView *tabView;
@property (nonatomic, retain) UITableView *infoView;
@property (nonatomic, retain) SocialActivity *socialActivity;

@end

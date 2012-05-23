//
//  ActivityLikersViewController.h
//  eXo Platform
//
//  Created by exo on 5/23/12.
//  Copyright (c) 2012 eXoPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class SocialActivity;

@interface ActivityLikersViewController : UIViewController 

@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, retain) UILabel *likersHeader;

@end

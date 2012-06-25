//
//  ActivityLikersViewController.h
//  eXo Platform
//
//  Created by Le Thanh Quang on 5/23/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SocialProxy.h"

@class SocialActivity;

@interface ActivityLikersViewController : UIViewController <SocialProxyDelegate>

@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, retain) UILabel *likersHeader;

- (void)updateLikerViews;
- (void)updateListOfLikers;

@end

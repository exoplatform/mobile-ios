//
//  ActivityDetailViewController.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialProxy.h"
#import "EGORefreshTableHeaderView.h"
#import "MessageComposerViewController.h"
#import "ATMHud.h"
#import "ATMHudDelegate.h"

@class Activity;
@class ActivityDetail;
@class ActivityDetailMessageTableViewCell;
@class ActivityDetailLikeTableViewCell;
@class SocialActivityStream;
@class SocialActivityDetails;
@class SocialUserProfile;

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]

@interface ActivityDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SocialProxyDelegate, EGORefreshTableHeaderDelegate, SocialMessageComposerDelegate>{
    
    IBOutlet UITableView*                   _tblvActivityDetail;
    IBOutlet UINavigationBar*               _navigationBar;
            
    Activity*                               _activity;
    SocialActivityStream*                   _socialActivityStream;
    
    //Cell for the content of the message
    ActivityDetailMessageTableViewCell*     _cellForMessage;
    
    //Cell for the like part of the screen
    ActivityDetailLikeTableViewCell*        _cellForLikes;
    
    ActivityDetail*                         _activityDetail;
    
    SocialActivityDetails*                  _socialActivityDetails;
    SocialUserProfile*                      _socialUserProfile;
    SocialUserProfile*                      _currentUserProfile;
    
    BOOL                                    _currentUserLikeThisActivity;
    
    UITextView*                             _txtvMsgComposer;
    IBOutlet UIButton*                      _btnMsgComposer;    
    
    //Refresh Management
    EGORefreshTableHeaderView*              _refreshHeaderView;
    BOOL                                    _reloading;
    NSDate*                                 _dateOfLastUpdate;
    
    //Loader
    ATMHud*                                 _hudActivityDetails;//Heads up display
}

//- (void)setActivity:(Activity*)activity andActivityDetail:(ActivityDetail*)activityDetail;
- (void)setSocialActivityStream:(SocialActivityStream*)socialActivityStream andActivityDetail:(ActivityDetail*)activityDetail andActivityUserProfile:(SocialUserProfile*)socialUserProfile andCurrentUserProfile:(SocialUserProfile*)currentUserProfile;
- (void)likeDislikeActivity:(NSString *)activity;
@end

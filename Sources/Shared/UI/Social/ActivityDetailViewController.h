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
#import "eXoViewController.h"

@class ActivityDetailMessageTableViewCell;
@class SocialActivity;
@class SocialUserProfile;

#define kFontForName [UIFont fontWithName:@"Helvetica-Bold" size:13]
#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]


@interface ActivityDetailViewController : eXoViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SocialProxyDelegate, EGORefreshTableHeaderDelegate, SocialMessageComposerDelegate, UIAlertViewDelegate, UIWebViewDelegate>{
    
    IBOutlet UITableView*                   _tblvActivityDetail;
//    IBOutlet UINavigationBar*               _navigationBar;
        
    BOOL                                    _currentUserLikeThisActivity;
    
    UITextView*                             _txtvMsgComposer;
    IBOutlet UIButton*                      _btnMsgComposer;    
    
    //Refresh Management
    EGORefreshTableHeaderView*              _refreshHeaderView;
    BOOL                                    _reloading;
    NSDate*                                 _dateOfLastUpdate;
    
    int                                     _activityAction;//0: getting, 1: updating, 2: like, 3: dislike
    
    CGRect originRect;
    BOOL zoomOutOrZoomIn;
    //UITapGestureRecognizer *tapGesture;
    
    UIView *maskView;
    
    NSString *_iconType; // icon for type of activity detail
    BOOL isPostComment;
}
@property (retain) NSString *iconType;
@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, retain) ActivityDetailMessageTableViewCell *activityDetailCell;
@property (nonatomic, retain) UITableView *tblvActivityDetail;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

- (void)setSocialActivityStream:(SocialActivity *)socialActivityStream andCurrentUserProfile:(SocialUserProfile*)currentUserProfile;
- (void)likeDislikeActivity:(NSString *)activity;

- (void)finishLoadingAllComments;
- (void)finishLoadingAllLikers;
/* 
 Methods for managing the like/unlike actions
 The derived classs can override these method for particular behavior
 */
- (void)didFinishedLikeAction;
- (void)didFailedLikeAction;

@end

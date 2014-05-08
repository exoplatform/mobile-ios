//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
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

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
#import "SocialActivity.h"
#import "EGORefreshTableHeaderView.h"
#import "MessageComposerViewController.h"
#import "EGOImageView.h"
#import "SocialPictureAttach.h"
#import "eXoViewController.h"
#import "ActivityStreamTabbar.h"

typedef NS_ENUM(NSInteger, ActivityAction) {
    ActivityActionLoad       = 0, // Load activities
    ActivityActionUpdate     = 1, // Update activities, e.g. with pull to refresh gesture
    ActivityActionLike       = 2,
    ActivityActionUnlike     = 3,
    ActivityActionLoadMore   = 4, // Load 100 more activities after the displayed ones
    ActivityActionUpdateAfterError = 5 // if LoadMore fails, reload the activity stream
} ;

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]

@class ActivityDetailViewController;
@class SocialUserProfile;

@interface ActivityStreamBrowseViewController : eXoViewController <EGORefreshTableHeaderDelegate, SocialProxyDelegate, SocialMessageComposerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate, JMTabViewDelegate>
{
    IBOutlet UITableView*                   _tblvActivityStream;
    
    NSMutableArray*                         _arrayOfSectionsTitle;
    NSMutableDictionary*                    _sortedActivities;
    ActivityDetailViewController*           _activityDetailViewController;
    UIBarButtonItem*                        _bbtnPost;
    
    NSMutableArray*                         _arrActivityStreams;
    
    BOOL                                    _bIsPostClicked;
    
    //Refresh Management
    EGORefreshTableHeaderView*              _refreshHeaderView;
    BOOL                                    _reloading;
    NSDate*                                 _dateOfLastUpdate;
    
    NSIndexPath*                            _indexpathSelectedActivity;
    int                                     _activityAction;
    ActivityStreamTabItem                   _selectedTabItem;
    UIActivityIndicatorView*                _loadingMoreActivitiesIndicator;
    SocialActivity*                         _lastActivity;
}

@property (nonatomic, retain) ActivityStreamTabbar *filterTabbar;
@property (nonatomic, retain) SocialUserProfile *userProfile;

- (NSString *)getIconForType:(NSString *)type;
- (void)emptyState;
- (void)startLoadingActivityStream;
- (void)likeDislikeActivity:(NSString *)activity like:(BOOL)isLike;
- (void)postACommentOnActivity:(NSString *)activity;
- (void)sortActivities;
- (void)clearActivityData;
- (SocialActivity *)getSocialActivityStreamForIndexPath:(NSIndexPath *)indexPath;
- (void)showHudForUpload;
@property (nonatomic, readonly, strong) UITableView *tblvActivityStream;
//- (float)getHeightForText:(NSString *)text width:(float)width;
@end

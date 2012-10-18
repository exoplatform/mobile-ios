//
//  ActivityStreamBrowseViewController.h
//  eXo Platform
//
//  Created by Stévan Le Meur on 14/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

typedef enum {
    ActivityActionLoad       = 0, // Load activities
    ActivityActionUpdate     = 1, // Update activities, e.g. with pull to refresh gesture
    ActivityActionLike       = 2,
    ActivityActionUnlike     = 3,
    ActivityActionLoadMore   = 4, // Load 100 more activities after the displayed ones
    ActivityActionUpdateAfterError = 5 // if LoadMore fails, reload the activity stream
} ActivityAction;

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
- (UITableView*) tblvActivityStream;
//- (float)getHeightForText:(NSString *)text width:(float)width;
@end

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

#define kFontForMessage [UIFont fontWithName:@"Helvetica" size:13]

@class ActivityDetailViewController;
@class SocialUserProfile;
@class ActivityStreamTabbar;

@interface ActivityStreamBrowseViewController : eXoViewController <EGORefreshTableHeaderDelegate, SocialProxyDelegate, SocialMessageComposerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UITableView*                   _tblvActivityStream;
    
    NSMutableArray*                         _arrayOfSectionsTitle;
    NSMutableDictionary*                    _sortedActivities;
    ActivityDetailViewController*           _activityDetailViewController;
    UIBarButtonItem*                        _bbtnPost;
    
    NSMutableArray*                         _arrActivityStreams;
    
    BOOL                                    _bIsPostClicked;
    SocialUserProfile*                      _socialUserProfile;
    
    //Refresh Management
    EGORefreshTableHeaderView*              _refreshHeaderView;
    BOOL                                    _reloading;
    NSDate*                                 _dateOfLastUpdate;
    
    NSIndexPath*                            _indexpathSelectedActivity;
    BOOL                                    _activityAction;
    
        
}

@property (nonatomic, retain) ActivityStreamTabbar *filterTabbar;

- (NSString *)getIconForType:(NSString *)type;
- (void)emptyState;
- (void)startLoadingActivityStream;
- (void)likeDislikeActivity:(NSString *)activity like:(BOOL)isLike;
- (void)postACommentOnActivity:(NSString *)activity;
- (void)sortActivities;
- (void)clearActivityData;
- (SocialActivity *)getSocialActivityStreamForIndexPath:(NSIndexPath *)indexPath;
-(void)showHudForUpload;
//- (float)getHeightForText:(NSString *)text width:(float)width;
@end

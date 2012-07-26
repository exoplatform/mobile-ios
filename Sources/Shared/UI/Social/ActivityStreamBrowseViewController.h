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
    BOOL                                    _activityAction;
    ActivityStreamTabItem                   _selectedTabItem;
        
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
-(void)showHudForUpload;
//- (float)getHeightForText:(NSString *)text width:(float)width;
@end

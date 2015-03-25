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
#import "JMTabView.h"

@class SocialActivity;
@class ActivityLikersViewController;
@class EmptyView;

typedef NS_ENUM(NSInteger, ActivityAdvancedInfoCellTab) {
    ActivityAdvancedInfoCellTabComment = 0,
    ActivityAdvancedInfoCellTabLike = 1
} ;

@interface ActivityDetailAdvancedInfoController_iPad : UIViewController <JMTabViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) JMTabView *tabView;
@property (nonatomic, retain) UITableView *infoView;
@property (nonatomic, retain) SocialActivity *socialActivity;
@property (nonatomic, retain) ActivityLikersViewController *likersViewController;
@property (nonatomic, retain) EmptyView *emptyView;
@property (nonatomic, retain) UIButton *commentButton;
@property (nonatomic, retain) UIView *infoContainer;
@property (nonatomic, assign) id<UIWebViewDelegate> delegateToProcessClickAction;

// this method is used to update value for subviews
- (void)updateSubViews;
- (void)updateTabLabels;
- (void)selectTab:(ActivityAdvancedInfoCellTab)selectedTab;
- (void)jumpToLastCommentIfExist;
- (void)reloadInfoContainerWithAnimated:(BOOL)animated;
- (void)updateLabelsWithNewLanguage;

@end

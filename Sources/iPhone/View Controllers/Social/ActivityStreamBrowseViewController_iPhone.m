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

#import "ActivityStreamBrowseViewController_iPhone.h"
#import "MessageComposerViewController_iPhone.h"
#import "ActivityDetailViewController_iPhone.h"
#import "SocialUserProfileCache.h"
#import "EGOImageView.h"
#import "SocialPictureAttach.h"
#import "DocumentDisplayViewController_iPhone.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "AppDelegate_iPhone.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "UIImage+BlankImage.h"


@implementation ActivityStreamBrowseViewController_iPhone



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:NO animated:YES];
    //Set the back indicator image to blank image with transparent color(Using custom function from Category UIImage(Blank))
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.backIndicatorImage = [UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(21, 41)];
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.backIndicatorTransitionMaskImage = [UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(21, 41)];
        
}

- (void)viewDidAppear:(BOOL)animated {    
    // Unselect the selected row if any
    NSIndexPath*	selection = [_tblvActivityStream indexPathForSelectedRow];
    if (selection)
        [_tblvActivityStream deselectRowAtIndexPath:selection animated:YES];
    

}


- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.title = self.title;
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTopNotificationHandle) name:EXO_NOTIFICATION_SCROLL_TO_TOP object:nil];
}


-(void) dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EXO_NOTIFICATION_SCROLL_TO_TOP object:nil];
    [super dealloc];
}

- (void)postACommentOnActivity:(NSString *)activity {
    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = activity;
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:messageComposerViewController] autorelease];
    [messageComposerViewController release];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:YES animated:YES];
    
    [self presentModalViewController:navController animated:YES];


}




- (void)onBbtnPost
{
    
    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = YES;
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:messageComposerViewController] autorelease];
    [messageComposerViewController release];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:YES animated:YES];

    
    [self presentModalViewController:navController animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
 
    _indexpathSelectedActivity = [indexPath copy];
    
    if (_activityDetailViewController != nil) 
    {
        [_activityDetailViewController release];
    }
    _activityDetailViewController = [[ActivityDetailViewController_iPhone alloc] initWithNibName:@"ActivityDetailViewController_iPhone" bundle:nil];
    _activityDetailViewController.iconType = [self getIconForType:socialActivityStream.type];
    [_activityDetailViewController setSocialActivityStream:socialActivityStream 
                                     andCurrentUserProfile:self.userProfile];
    
    //[self.navigationController pushViewController:_activityDetailViewController animated:YES];
    
    //[_revealView.contentView setRootView:_activityStreamBrowseViewController_iPhone.view];
    //[_revealView revealSidebar:NO];
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:_activityDetailViewController animated:YES];

}

-(void) scrollToTopNotificationHandle {
    if (self.view.window)
        [self.tblvActivityStream setContentOffset:CGPointZero animated:YES];
}

@end

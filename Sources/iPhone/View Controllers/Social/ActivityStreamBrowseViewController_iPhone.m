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
#import "ActivityPictureTableViewCell.h"

@interface ActivityStreamBrowseViewController_iPhone (){
    ASMediaFocusManager * mediaFocusManager;
}

@end
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
    [super viewDidAppear:animated];
    // Unselect the selected row if any
    NSIndexPath*	selection = [_tblvActivityStream indexPathForSelectedRow];
    if (selection)
        [_tblvActivityStream deselectRowAtIndexPath:selection animated:YES];
    
}


- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.view.title = self.title;
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //Init media focus
    mediaFocusManager = [[ASMediaFocusManager alloc] init];
    mediaFocusManager.delegate = self;

}




- (void)postACommentOnActivity:(NSString *)activity {
    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = activity;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:YES animated:YES];
    
    [self presentViewController:navController animated:YES completion:nil];
}




- (void)onBbtnPost
{
    
    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = YES;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:YES animated:YES];

    [self presentViewController:navController animated:YES completion:nil];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[ActivityPictureTableViewCell class]] ) {
        // remove the Tap to focus gesture
        for (UIGestureRecognizer * gesture in ((ActivityPictureTableViewCell*)cell).imgvAttach.gestureRecognizers ){
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]]){
                [((ActivityPictureTableViewCell*)cell).imgvAttach removeGestureRecognizer:gesture];
            }
        }
        // if this a picture cell & the file attachment is a picture, add top to focus gesture
        SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
        if (socialActivityStream.activityType == ACTIVITY_DOC || socialActivityStream.activityType == ACTIVITY_CONTENTS_SPACE) {
            NSString * mimeType = [socialActivityStream.templateParams valueForKey:@"mimeType"];
            if (mimeType && [mimeType rangeOfString:@"image"].location != NSNotFound){
                [mediaFocusManager installOnView:((ActivityPictureTableViewCell*)cell).imgvAttach];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SocialActivity *socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
 
    _indexpathSelectedActivity = [indexPath copy];
    
    _activityDetailViewController = [[ActivityDetailViewController_iPhone alloc] initWithNibName:@"ActivityDetailViewController_iPhone" bundle:nil];
    _activityDetailViewController.iconType = [self getIconForType:socialActivityStream.type];
    [_activityDetailViewController setSocialActivityStream:socialActivityStream 
                                     andCurrentUserProfile:self.userProfile];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:_activityDetailViewController animated:YES];

}


#pragma mark - ASMediaFocusDelegate
- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
    return [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.view.bounds;
}

- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view
{
    UITableViewCell * cell = [self cellContainerForView:view];
    if ([cell isKindOfClass:[ActivityPictureTableViewCell class]]){
        NSString * stringURL = ((ActivityPictureTableViewCell *) cell).urlForAttachment.absoluteString;
        stringURL = [stringURL stringByReplacingOccurrencesOfString:@"/thumbnailImage/large" withString:@"/jcr"];
        return [NSURL URLWithString:stringURL];
    }
    return nil;
    
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return [AppDelegate_iPhone instance].homeSidebarViewController_iPhone;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;
{
    UITableViewCell * cell = [self cellContainerForView:view];
    if ([cell isKindOfClass:[ActivityPictureTableViewCell class]]){
        return ((ActivityPictureTableViewCell *) cell).activityMessage.text;
    }
    return @"";
}

- (void)mediaFocusManagerDidDismiss:(ASMediaFocusManager *)mediaFocusManager
{

}

/*
 */
-(UITableViewCell *) cellContainerForView:(UIView *) view {
    while (view !=nil) {
        if ([view isKindOfClass:[UITableViewCell class]]){
            return (UITableViewCell*)view;
        }
        view = view.superview;
    }
    return nil;
}

@end

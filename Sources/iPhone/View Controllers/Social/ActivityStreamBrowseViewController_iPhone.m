//
//  ActivityStreamBrowseViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
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

@implementation ActivityStreamBrowseViewController_iPhone


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath*	selection = [_tblvActivityStream indexPathForSelectedRow];
    if (selection)
        [_tblvActivityStream deselectRowAtIndexPath:selection animated:YES];
}





- (void)postACommentOnActivity:(NSString *)activity {
    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = activity;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [messageComposerViewController release];
}




- (void)onBbtnPost
{
    
    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    
    messageComposerViewController.delegate = self;
    messageComposerViewController.isPostMessage = YES;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
    [self.navigationController presentModalViewController:navController animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SocialActivityStream* socialActivityStream = [self getSocialActivityStreamForIndexPath:indexPath];
 
    _indexpathSelectedActivity = [indexPath copy];
    
    if (_activityDetailViewController != nil) 
    {
        [_activityDetailViewController release];
    }
    _activityDetailViewController = [[ActivityDetailViewController_iPhone alloc] initWithNibName:@"ActivityDetailViewController_iPhone" bundle:nil];
    _activityDetailViewController.iconType = [self getIconForType:socialActivityStream.type];
    [_activityDetailViewController setSocialActivityStream:socialActivityStream 
                                     andCurrentUserProfile:_socialUserProfile];
    
    [self.navigationController pushViewController:_activityDetailViewController animated:YES];
}


@end

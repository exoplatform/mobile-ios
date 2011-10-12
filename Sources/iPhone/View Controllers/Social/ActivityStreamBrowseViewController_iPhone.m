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

@implementation ActivityStreamBrowseViewController_iPhone


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Unselect the selected row if any
    NSIndexPath*	selection = [_tblvActivityStream indexPathForSelectedRow];
    if (selection)
        [_tblvActivityStream deselectRowAtIndexPath:selection animated:YES];
}


// Specific method to retrieve the height of the cell
// This method override the inherited one.
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text picture:(BOOL)isPicture
{
    CGRect rectTableView = tableView.frame;
    float fWidth = 0;
    float fHeight = 0;
    
    if (rectTableView.size.width > 320) 
    {
        fWidth = rectTableView.size.width - 85; //fmargin = 85 will be defined as a constant.
    }
    else
    {
        fWidth = rectTableView.size.width - 70;
    }
    
    CGSize theSize = [text sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) 
                          lineBreakMode:UILineBreakModeWordWrap];
    if (theSize.height < 30) 
    {
        fHeight = 100;
    }
    else
    {
        fHeight = 75 + theSize.height;
    }
    
    if (fHeight > 200) {
        fHeight = 200;
    }
    return fHeight;
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
 
    _indexpathSelectedActivity = indexPath;
    
    if (_activityDetailViewController == nil) 
    {
        
        ActivityDetailViewController_iPhone *activityDetailViewController = [[ActivityDetailViewController_iPhone alloc] initWithNibName:@"ActivityDetailViewController_iPhone" bundle:nil];
        _activityDetailViewController = activityDetailViewController;
        
    }
    
    [_activityDetailViewController setSocialActivityStream:socialActivityStream 
                                     andCurrentUserProfile:_socialUserProfile];
    
    [self.navigationController pushViewController:_activityDetailViewController animated:YES];
}


@end

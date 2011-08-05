//
//  ActivityDetailViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController_iPhone.h"
#import "MessageComposerViewController_iPhone.h"
#import "ActivityDetailViewController.h"
#import "SocialActivityStream.h"
#import "ActivityStreamBrowseViewController.h"
#import "MessageComposerViewController.h"

@implementation ActivityDetailViewController_iPhone

@synthesize _delegate;


- (void)onBtnMessageComposer
{

    if(_messageComposerViewController == nil)
    {
        _messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    } 
    _messageComposerViewController._delegate = _delegate;
    _messageComposerViewController._tblvActivityDetail = _tblvActivityDetail;
    _messageComposerViewController._isPostMessage = NO;
    _messageComposerViewController._strActivityID = _socialActivityStream.activityId;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_messageComposerViewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [_messageComposerViewController release];
}

@end

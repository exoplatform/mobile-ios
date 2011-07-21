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

@implementation ActivityDetailViewController_iPhone

@synthesize _delegate;

- (void)onBtnMessageComposer
{
    MessageComposerViewController_iPhone*  messageComposerViewController;
    
    messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    
    messageComposerViewController._delegate = _delegate;
    messageComposerViewController._tblvActivityDetail = _tblvActivityDetail;
    messageComposerViewController._isPostMessage = NO;
    messageComposerViewController._strActivityID = _socialActivityStream.identify;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
    [self.navigationController presentModalViewController:navController animated:YES];
}

@end

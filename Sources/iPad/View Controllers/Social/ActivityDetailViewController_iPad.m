//
//  ActivityDetailViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController_iPad.h"
#import "MessageComposerViewController_iPad.h"
#import "SocialActivityStream.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"

@implementation ActivityDetailViewController_iPad

@synthesize _delegate;

- (void)onBtnMessageComposer
{
    if(_messageComposerViewController == nil)
    {
        _messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
    } 
    _messageComposerViewController._delegate = _delegate;    
    _messageComposerViewController._tblvActivityDetail = _tblvActivityDetail;
    _messageComposerViewController._isPostMessage = NO;
    _messageComposerViewController._strActivityID = _socialActivityStream.activityId;
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_messageComposerViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[AppDelegate_iPad instance].rootViewController.menuViewController presentModalViewController:navController animated:YES];
    
    int x, y;
    
    if( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || 
       [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {
        x = 114;
        y = 300;
    }
    else 
    {
        x = 242;
        y = 70;
    }
    
    navController.view.superview.autoresizingMask = UIViewAutoresizingNone;
    navController.view.superview.frame = CGRectMake(x,y, 540.0f, 265.0f);
    
    [_messageComposerViewController release];
}

@end

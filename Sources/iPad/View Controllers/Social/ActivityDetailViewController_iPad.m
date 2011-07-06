//
//  ActivityDetailViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController_iPad.h"
#import "MessageComposerViewController_iPad.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"

@implementation ActivityDetailViewController_iPad

- (void)onBtnMessageComposer
{
    MessageComposerViewController*  messageComposerViewController;
    
    messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [[AppDelegate_iPad instance].rootViewController.menuViewController presentModalViewController:navController animated:YES];
}

@end

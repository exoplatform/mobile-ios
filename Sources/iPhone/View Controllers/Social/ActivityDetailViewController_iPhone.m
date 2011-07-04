//
//  ActivityDetailViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController_iPhone.h"
#import "MessageComposerViewController.h"
#import "ActivityDetailViewController.h"

@implementation ActivityDetailViewController_iPhone


- (void)onBtnMessageComposer
{
    MessageComposerViewController*  messageComposerViewController;
    
    messageComposerViewController = [[MessageComposerViewController alloc] initWithNibName:@"MessageComposerViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
    [self.navigationController presentModalViewController:navController animated:YES];
}

@end

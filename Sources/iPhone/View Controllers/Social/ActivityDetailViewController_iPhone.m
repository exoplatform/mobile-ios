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
#import "defines.h"
#import "ActivityLinkDisplayViewController_iPhone.h"

@implementation ActivityDetailViewController_iPhone


- (void)onBtnMessageComposer
{

    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    messageComposerViewController.delegate = self;
    messageComposerViewController.tblvActivityDetail = _tblvActivityDetail;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = _socialActivityStream.activityId;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];
    
    [messageComposerViewController release];
}



#pragma mark - UIWebViewDelegateMethod 
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //CAPTURE USER LINK-CLICK.
    NSURL *url = [request URL];
    
    
    if (!([[url absoluteString] isEqualToString:[NSString stringWithFormat:@"%@/",[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN]]])) {
        
		ActivityLinkDisplayViewController_iPhone* linkWebViewController = [[ActivityLinkDisplayViewController_iPhone alloc] 
                                                                       initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPhone"
                                                                       bundle:nil 
                                                                       url:url];
		[self.navigationController pushViewController:linkWebViewController animated:YES];    
        
        [linkWebViewController release];
        
        return NO;
    }
    
    
    return YES;   
}


@end

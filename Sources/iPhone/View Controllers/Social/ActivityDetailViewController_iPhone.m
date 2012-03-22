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
#import "AppDelegate_iPhone.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "ActivityHelper.h"

@implementation ActivityDetailViewController_iPhone


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView setNavigationBarHidden:NO animated:YES];


    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.title = self.title;

}


- (void)onBtnMessageComposer
{

    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    messageComposerViewController.delegate = self;
    messageComposerViewController.tblvActivityDetail = _tblvActivityDetail;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = _socialActivityStream.activityId;
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:messageComposerViewController] autorelease];
    [messageComposerViewController release];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView setNavigationBarHidden:YES animated:YES];
    
    [self presentModalViewController:navController animated:YES];

    
    
}
#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
    self.hudLoadWaiting.center = self.view.center;
}

-(void)showContent:(UITapGestureRecognizer *)gesture{
    NSURL *url;
    switch (_socialActivityStream.activityType) {
        case ACTIVITY_DOC:{
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN], [_socialActivityStream.templateParams valueForKey:@"DOCLINK"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN], [NSString stringWithFormat:@"/portal/rest/jcr/%@", [_socialActivityStream.templateParams valueForKey:@"contenLink"]]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
            break;
    }
    
    ActivityLinkDisplayViewController_iPhone* linkWebViewController = [[ActivityLinkDisplayViewController_iPhone alloc] 
                                                                       initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPhone"
                                                                       bundle:nil 
                                                                       url:url];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView pushView:linkWebViewController.view animated:YES];
    
}

#pragma mark - UIWebViewDelegateMethod 
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //CAPTURE USER LINK-CLICK.
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		ActivityLinkDisplayViewController_iPhone* linkWebViewController = [[ActivityLinkDisplayViewController_iPhone alloc] 
                                                                       initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPhone"
                                                                       bundle:nil 
                                                                       url:[request URL]];
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView pushView:linkWebViewController.view animated:YES]; 
        return NO;
    }
    return YES;   
}


@end

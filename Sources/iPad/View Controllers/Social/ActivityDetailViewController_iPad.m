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
#import "ActivityLinkDisplayViewController_iPad.h"
#import "defines.h"
#import "StackScrollViewController.h"
#import "LanguageHelper.h"
#import "EmptyView.h"
#import "ActivityHelper.h"
#import "ActivityDetailExtraActionsCell.h"
#import "ActivityDetailAdvancedInfoController_iPad.h"
#import "CustomBackgroundView.h"

#define kMinimumAdvancedInfoCellHeight 400.0

@implementation ActivityDetailViewController_iPad

@synthesize extraActionsCell = _extraActionsCell;
@synthesize advancedInfoController = _advancedInfoController;

- (void)dealloc {
    [_extraActionsCell release];
    [_advancedInfoController release];
    [super dealloc];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.tblvActivityDetail.backgroundView = [[[CustomBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
    _navigation.topItem.title = Localize(@"Details");
}

#pragma mark - like/dislike management
- (void)likeDislike:(id)sender {
    [self.extraActionsCell likeButtonToActivityIndicator];
    [self likeDislikeActivity:self.socialActivity.activityId];
}

- (void)didFinishedLikeAction {
    [self.extraActionsCell activityIndicatorToLikeButton];
    [self.extraActionsCell updateSubViews];
    [self.advancedInfoController updateTabLabels];
}

- (void)didFailedLikeAction {
    [self.extraActionsCell activityIndicatorToLikeButton];
}

- (void)onBtnMessageComposer
{
    
    MessageComposerViewController_iPad* messageComposerViewController = [[MessageComposerViewController_iPad alloc] initWithNibName:@"MessageComposerViewController_iPad" bundle:nil];
     
    messageComposerViewController.delegate = self;    
    messageComposerViewController.tblvActivityDetail = _tblvActivityDetail;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = self.socialActivity.activityId;
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messageComposerViewController];
    [messageComposerViewController release];
    
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
}


- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height/2)-70);
}

#pragma mark - overriden 
- (void)setSocialActivityStream:(SocialActivity *)socialActivityStream andCurrentUserProfile:(SocialUserProfile *)currentUserProfile {
    self.extraActionsCell.socialActivity = socialActivityStream;
    self.advancedInfoController.socialActivity = socialActivityStream;
    [super setSocialActivityStream:socialActivityStream andCurrentUserProfile:currentUserProfile];
}

- (void)finishLoadingAllComments {
    [super finishLoadingAllComments];
    [self.advancedInfoController updateTabLabels];
    if (self.advancedInfoController.tabView.selectedIndex == ActivityAdvancedInfoCellTabComment) {
        //if comment tableview scroll at bottom
        [self.advancedInfoController reloadInfoContainerWithAnimated:NO];
        if(isPostComment) {
            [self.advancedInfoController jumpToLastCommentIfExist];
            isPostComment = NO;
        }
        
    }
}

- (void)finishLoadingAllLikers {
    [super finishLoadingAllLikers];
    [self.advancedInfoController updateTabLabels];
    if (self.advancedInfoController.tabView.selectedIndex == ActivityAdvancedInfoCellTabLike) {
        [self.advancedInfoController reloadInfoContainerWithAnimated:NO];
    }
}


#pragma mark - UIWebViewDelegateMethod 
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //CAPTURE USER LINK-CLICK.
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
   
        ActivityLinkDisplayViewController_iPad* linkWebViewController = [[ActivityLinkDisplayViewController_iPad alloc] 
                                                                         initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPad"
                                                                         bundle:nil 
                                                                         url:[request URL]];
		
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:linkWebViewController invokeByController:self isStackStartView:FALSE];
        
        [linkWebViewController release];
        return NO;
    }
    
    return YES;   
}


-(void)showContent:(UITapGestureRecognizer *)gesture{
    NSURL *url;
    switch (self.socialActivity.activityType) {
        case ACTIVITY_DOC:{
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN], [self.socialActivity.templateParams valueForKey:@"DOCLINK"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
            break;
        case ACTIVITY_CONTENTS_SPACE:{
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:EXO_PREFERENCE_DOMAIN], [NSString stringWithFormat:@"/portal/rest/jcr/%@", [self.socialActivity.templateParams valueForKey:@"contenLink"]]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
            break;
    }
    ActivityLinkDisplayViewController_iPad* linkWebViewController = [[ActivityLinkDisplayViewController_iPad alloc] 
                                                                     initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPad"
                                                                     bundle:nil 
                                                                     url:url];
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:linkWebViewController invokeByController:self isStackStartView:FALSE];   
    
    [linkWebViewController release];
}



//Test for rotation management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    //if the empty is, change rotaion it
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview changeOrientation];
    }
}

#pragma mark - UITableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self.extraActionsCell updateSubViews];
    } else if (indexPath.section == 2) {
        float height = self.tblvActivityDetail.bounds.size.height - self.extraActionsCell.frame.origin.y - self.extraActionsCell.frame.size.height;
        CGRect frame = CGRectZero;
        frame.size.height = height > kMinimumAdvancedInfoCellHeight ? height : kMinimumAdvancedInfoCellHeight;
        frame.size.width = self.tblvActivityDetail.bounds.size.width;
        self.advancedInfoController.view.frame = frame;
        [self.advancedInfoController updateSubViews];
    } else {
        [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifierActivityDetailAdvancedInfoTableViewCell = @"ActivityDetailAdvancedInfoTableViewCell";
    if (indexPath.section == 1) {
        return self.extraActionsCell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailAdvancedInfoTableViewCell];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdentifierActivityDetailAdvancedInfoTableViewCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.advancedInfoController.view];
        }
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return self.extraActionsCell.frame.size.height;
    } else if (indexPath.section == 2) {
        return self.advancedInfoController.view.frame.size.height;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - cell initialization

- (ActivityDetailExtraActionsCell *)extraActionsCell {
    if (!_extraActionsCell) {
        _extraActionsCell = [[ActivityDetailExtraActionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"extra actions cell"];
        [_extraActionsCell.likeButton addTarget:self action:@selector(likeDislike:) forControlEvents:UIControlEventTouchUpInside];
        [_extraActionsCell.commentButton addTarget:self action:@selector(onBtnMessageComposer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extraActionsCell;
}

- (ActivityDetailAdvancedInfoController_iPad *)advancedInfoController {
    if (!_advancedInfoController) {
        _advancedInfoController = [[ActivityDetailAdvancedInfoController_iPad alloc] init];
        [_advancedInfoController.commentButton addTarget:self action:@selector(onBtnMessageComposer) forControlEvents:UIControlEventTouchUpInside];
        _advancedInfoController.delegateToProcessClickAction = self;
    }
    return _advancedInfoController;
}

#pragma mark - change language management

- (void) updateLabelsWithNewLanguage{
    [super updateLabelsWithNewLanguage];
    _navigation.topItem.title = Localize(@"Details");
    [self.advancedInfoController updateLabelsWithNewLanguage];
    [_tblvActivityDetail reloadData];
    [self.view setNeedsDisplay];
}

@end




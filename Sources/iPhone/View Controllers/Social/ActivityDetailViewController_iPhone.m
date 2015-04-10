//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "ActivityDetailViewController_iPhone.h"
#import "MessageComposerViewController_iPhone.h"
#import "ActivityDetailViewController.h"
#import "ActivityStreamBrowseViewController.h"
#import "MessageComposerViewController.h"
#import "defines.h"
#import "ActivityLinkDisplayViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"
#import "ActivityHelper.h"
#import "ActivityLikersViewController.h"
#import "ActivityDetailLikeTableViewCell.h"
#import "ActivityDetailCommentTableViewCell.h"
#import "EmptyView.h"

#define kLikeCellHeight (self.socialActivity.totalNumberOfLikes > 0 ? 70.0 : 50.0)
#define kNoCommentCellHeight 200.0

@implementation ActivityDetailViewController_iPhone

@synthesize noCommentCell = _noCommentCell;
@synthesize likeViewCell = _likeViewCell;

- (void)dealloc {
    [_noCommentCell release];
    [_likeViewCell release];
    [super dealloc];
}

- (UITableViewCell *)noCommentCell {
    if (!_noCommentCell) {
        CGRect cellBounds = CGRectMake(0, 0, _tblvActivityDetail.bounds.size.width, kNoCommentCellHeight);
        _noCommentCell = [[UITableViewCell alloc] init];
        _noCommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _noCommentCell.bounds = cellBounds;
        EmptyView *emptyView = [[[EmptyView alloc] initWithFrame:_noCommentCell.bounds withImageName:@"IconForNoActivities" andContent:Localize(@"NoComment")] autorelease];
        emptyView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
        [_noCommentCell.contentView addSubview:emptyView];
    }
    return _noCommentCell;
}

- (ActivityDetailLikeTableViewCell *)likeViewCell {
    if (!_likeViewCell) {
        _likeViewCell = [[ActivityDetailLikeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];    
        _likeViewCell.selectionStyle = UITableViewCellSelectionStyleGray;
        _likeViewCell.delegate = self;
    }
    return _likeViewCell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.title = self.title;
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.backBarButtonItem = self.navigationItem.backBarButtonItem;
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.tintColor = [UIColor whiteColor];
    
    
    [_btnMsgComposer addTarget:self action:@selector(onBtnMessageComposer) forControlEvents:UIControlEventTouchUpInside];
    UIImage *strechBg = [[UIImage imageNamed:@"SocialYourCommentButtonBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:23];
    _btnMsgComposer.backgroundColor = [UIColor clearColor];
    [_btnMsgComposer setBackgroundImage:strechBg forState:UIControlStateNormal];
    [_btnMsgComposer setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 0.0f, 0.0f, 0.0f)];
    [_btnMsgComposer setTitle:Localize(@"YourComment") forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTopNotificationHandle) name:EXO_NOTIFICATION_SCROLL_TO_TOP object:nil];
}


- (void)onBtnMessageComposer
{

    MessageComposerViewController_iPhone* messageComposerViewController = [[MessageComposerViewController_iPhone alloc] initWithNibName:@"MessageComposerViewController_iPhone" bundle:nil];
    messageComposerViewController.delegate = self;
    messageComposerViewController.tblvActivityDetail = _tblvActivityDetail;
    messageComposerViewController.isPostMessage = NO;
    messageComposerViewController.strActivityID = self.socialActivity.activityId;
    
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:messageComposerViewController] autorelease];
    [messageComposerViewController release];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:YES animated:YES];
    
    [self presentModalViewController:navController animated:YES];

    
    
}

- (void)finishLoadingAllLikers {
    [super finishLoadingAllLikers];
    [_tblvActivityDetail reloadData];
    // reload likers view
    [self.likeViewCell reloadAvatarViews:NO];
}

- (void)finishLoadingAllComments {
    [super finishLoadingAllComments];
    //if comment tableview scroll at bottom
    [_tblvActivityDetail reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    if(isPostComment){
        if([self.socialActivity.comments count] > 0){
            [_tblvActivityDetail scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.socialActivity.comments count] - 1 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        isPostComment = NO;
    }
}


#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
    self.hudLoadWaiting.center = self.view.center;
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
    
    ActivityLinkDisplayViewController_iPhone* linkWebViewController = [[[ActivityLinkDisplayViewController_iPhone alloc] 
                                                                       initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPhone"
                                                                       bundle:nil 
                                                                       url:url] autorelease];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:linkWebViewController animated:YES];
    
}

#pragma mark - UIWebViewDelegateMethod 
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //CAPTURE USER LINK-CLICK.
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		ActivityLinkDisplayViewController_iPhone* linkWebViewController = [[[ActivityLinkDisplayViewController_iPhone alloc] 
                                                                       initWithNibAndUrl:@"ActivityLinkDisplayViewController_iPhone"
                                                                       bundle:nil 
                                                                       url:[request URL]] autorelease];
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:linkWebViewController animated:YES]; 
        return NO;
    }
    return YES;   
}

#pragma mark - TableView management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return (section == 2 && self.socialActivity.totalNumberOfComments > 0) ? [self.socialActivity.comments count] : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kIdentifierActivityDetailCommentTableViewCell = @"ActivityDetailCommentTableViewCell";
    if (indexPath.section == 1) {        
        return self.likeViewCell;
    } else if (indexPath.section == 2) {
        if (self.socialActivity.totalNumberOfComments == 0) {
            return self.noCommentCell;
        } else {
            ActivityDetailCommentTableViewCell* cell = (ActivityDetailCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailCommentTableViewCell];
            
            //Check if we found a cell
            if (cell == nil) 
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailCommentTableViewCell" owner:self options:nil];
                cell = (ActivityDetailCommentTableViewCell *)[nib objectAtIndex:0];
                
                //Create a cell, need to do some configurations
                [cell configureCell];
                cell.width = tableView.frame.size.width;
                cell.extraDelegateForWebView = self;
            }
            
            SocialComment* socialComment = [self.socialActivity.comments objectAtIndex:indexPath.row];
            [cell setSocialComment:socialComment];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
        return kLikeCellHeight;
    else if (indexPath.section == 2 && self.socialActivity.totalNumberOfComments == 0) {
        return self.noCommentCell.bounds.size.height;
    }
    else return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {        
        ActivityLikersViewController *likersView = [[[ActivityLikersViewController alloc] init] autorelease];
        likersView.socialActivity = self.socialActivity;
        NSString *likerLabel = (self.socialActivity.totalNumberOfLikes <= 1) ? @"numOfLiker" : @"numOfLikers";
        likersView.view.title = [NSString stringWithFormat:Localize(likerLabel), self.socialActivity.totalNumberOfLikes];
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:likersView animated:YES];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

-(void) scrollToTopNotificationHandle {
    if (self.view.window)
        [self.tblvActivityDetail setContentOffset:CGPointZero animated:YES];
}
#pragma mark - like/dislike management
- (void)likeDislikeActivity:(NSString *)activity {
    [super likeDislikeActivity:activity];
    [self.likeViewCell likeButtonToActivityIndicator];
}

- (void)didFinishedLikeAction {
    [super didFinishedLikeAction];
    [self.likeViewCell activityIndicatorToLikeButton];
    [self.likeViewCell setUserLikeThisActivity:self.likeViewCell.socialActivity.liked];
}

- (void)didFailedLikeAction {
    [self.likeViewCell activityIndicatorToLikeButton];
    [super didFailedLikeAction];
}

#pragma mark - overriden
- (void)setSocialActivity:(SocialActivity *)socialActivity {
    [super setSocialActivity:socialActivity];
    self.likeViewCell.socialActivity = socialActivity;
}

@end

//
//  AcitivityDetailViewController.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 6/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "MockSocial_Activity.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityDetailMessageTableViewCell.h"
#import "ActivityCalendarDetailMessageTableViewCell.h"
#import "ActivityPictureDetailMessageTableViewCell.h"
#import "ActivityLinkDetailMessageTableViewCell.h"
#import "ActivityForumDetailMessageTableViewCell.h"
#import "ActivityWikiDetailMessageTableViewCell.h"
#import "ActivityAnswerDetailMessageTableViewCell.h"
#import "ActivityStreamBrowseViewController.h"
#import "MessageComposerViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "SocialActivity.h"
#import "SocialActivityDetailsProxy.h"
#import "SocialUserProfileProxy.h"
#import "SocialComment.h"
#import "SocialLikeActivityProxy.h"
#import "ActivityDetailLikeTableViewCell.h"
#import "SocialUserProfileCache.h"
#import "defines.h"
#import "NSString+HTML.h"
#import "LanguageHelper.h"
#import "ActivityHelper.h"


#define NUMBER_OF_COMMENT_TO_LOAD 30



@implementation ActivityDetailViewController

@synthesize iconType = _iconType;
@synthesize socialActivity = _socialActivity;
@synthesize activityDetailCell = _activityDetailCell;
@synthesize tblvActivityDetail = _tblvActivityDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _activityAction = 0;
        zoomOutOrZoomIn = NO;
        isPostComment = NO;
    }
    return self;
}

- (void)dealloc
{
    [_tblvActivityDetail release];
    [_navigation release];
    [_activityDetailCell release];
    
    [_txtvMsgComposer release];
    [_btnMsgComposer release];    
    
    [_refreshHeaderView release];
    [_dateOfLastUpdate release];
    
    [_socialActivity release];
        
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = EXO_BACKGROUND_COLOR;
    //Set the last update date at now 
    _dateOfLastUpdate = [[NSDate date]retain];
    
	[self.view addSubview:self.hudLoadWaiting.view];
    
    //Set the title of the screen
    //TODO Localize
    self.title = Localize(@"Details");
    
    //Set the background Color of the view    
    //_tblvActivityDetail.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    _tblvActivityDetail.backgroundColor = EXO_BACKGROUND_COLOR;
    
    
    [_btnMsgComposer addTarget:self action:@selector(onBtnMessageComposer) forControlEvents:UIControlEventTouchUpInside];
    UIImage *strechBg = [[UIImage imageNamed:@"SocialYourCommentButtonBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:23];
    _btnMsgComposer.backgroundColor = [UIColor clearColor];
    [_btnMsgComposer setBackgroundImage:strechBg forState:UIControlStateNormal];
    
    //Add the pull to refresh header
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tblvActivityDetail.bounds.size.height, self.view.frame.size.width, _tblvActivityDetail.bounds.size.height)];
		view.delegate = self;
		[_tblvActivityDetail addSubview:view];
		_refreshHeaderView = view;
		[view release];
        _reloading = FALSE;
        
	}
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *selection = [_tblvActivityDetail indexPathForSelectedRow];
    if (selection) {
        [_tblvActivityDetail deselectRowAtIndexPath:selection animated:YES];
    }
}

/*
- (void)viewWillAppear:(BOOL)animated
{
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
   return 0;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
   return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    int n = 0;
    if (indexPath.section == 0) 
    {
        return self.activityDetailCell.bounds.size.height;
    }
    
    if (indexPath.section == 1) 
    {
        n = 55;
    }
    if (indexPath.section == 2) 
    {
        SocialComment* comment = [self.socialActivity.comments objectAtIndex:indexPath.row];
        n = [ActivityHelper calculateCellHeighForTableView:tableView andText:comment.text];

    }
    return n;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    if (indexPath.section == 0) {
        return self.activityDetailCell;
    } else {
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // message detail cell
        cell.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//
-(void)showContent:(UITapGestureRecognizer *)tapGesture{
    //NSLog(@"test");
}

#pragma mark - cell initialization
- (ActivityDetailMessageTableViewCell *)activityDetailCell {
    if (!_activityDetailCell) {
        switch (self.socialActivity.activityType) {
            case ACTIVITY_DOC:
            case ACTIVITY_CONTENTS_SPACE: {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityPictureDetailMessageTableViewCell" owner:self options:nil];
                _activityDetailCell = (ActivityPictureDetailMessageTableViewCell *)[nib objectAtIndex:0];
                //Create a cell, need to do some configurations
                [_activityDetailCell configureCell];
                [_activityDetailCell configureCellForSpecificContentWithWidth:_tblvActivityDetail.frame.size.width];
                //Set the delegate of the webview
                _activityDetailCell.webViewForContent.delegate = self;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContent:)];
                [_activityDetailCell.imgvAttach addGestureRecognizer:tapGesture];
                [tapGesture release];
            
                break;
            }
            case ACTIVITY_WIKI_ADD_PAGE:
            case ACTIVITY_WIKI_MODIFY_PAGE: {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityWikiDetailMessageTableViewCell" owner:self options:nil];
                _activityDetailCell = (ActivityWikiDetailMessageTableViewCell *)[nib objectAtIndex:0];
                //Create a cell, need to do some configurations
                [_activityDetailCell configureCell];
                [_activityDetailCell configureCellForSpecificContentWithWidth:_tblvActivityDetail.frame.size.width];
                //Set the delegate of the webview
                _activityDetailCell.webViewForContent.delegate = self;
                break;
            }
            case ACTIVITY_FORUM_CREATE_POST: 
            case ACTIVITY_FORUM_CREATE_TOPIC:
            case ACTIVITY_FORUM_UPDATE_POST:
            case ACTIVITY_FORUM_UPDATE_TOPIC: {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityForumDetailMessageTableViewCell" owner:self options:nil];
                _activityDetailCell = (ActivityForumDetailMessageTableViewCell *)[nib objectAtIndex:0];
                //Create a cell, need to do some configurations
                [_activityDetailCell configureCell];
                [_activityDetailCell configureCellForSpecificContentWithWidth:_tblvActivityDetail.frame.size.width];
                //Set the delegate of the webview
                _activityDetailCell.webViewForContent.delegate = self;
                break;
            }
            case ACTIVITY_CALENDAR_UPDATE_TASK: 
            case ACTIVITY_CALENDAR_ADD_TASK:
            case ACTIVITY_CALENDAR_UPDATE_EVENT:
            case ACTIVITY_CALENDAR_ADD_EVENT: {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityCalendarDetailMessageTableViewCell" owner:self options:nil];
                _activityDetailCell = (ActivityCalendarDetailMessageTableViewCell *)[nib objectAtIndex:0];
                //Create a cell, need to do some configurations
                [_activityDetailCell configureCell];
                [_activityDetailCell configureCellForSpecificContentWithWidth:_tblvActivityDetail.frame.size.width];
                //Set the delegate of the webview
                _activityDetailCell.webViewForContent.delegate = self;
                break; 
            }
            case ACTIVITY_ANSWER_QUESTION:
            case ACTIVITY_ANSWER_ADD_QUESTION:
            case ACTIVITY_ANSWER_UPDATE_QUESTION: {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityAnswerDetailMessageTableViewCell" owner:self options:nil];
                _activityDetailCell = (ActivityAnswerDetailMessageTableViewCell *)[nib objectAtIndex:0];
                //Create a cell, need to do some configurations
                [_activityDetailCell configureCell];
                [_activityDetailCell configureCellForSpecificContentWithWidth:_tblvActivityDetail.frame.size.width];
                //Set the delegate of the webview
                _activityDetailCell.webViewForContent.delegate = self;            
                break;
            }
            case ACTIVITY_LINK: {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityLinkDetailMessageTableViewCell" owner:self options:nil];
                _activityDetailCell = (ActivityLinkDetailMessageTableViewCell *)[nib objectAtIndex:0];
                //Create a cell, need to do some configurations
                [_activityDetailCell configureCell];
                [_activityDetailCell configureCellForSpecificContentWithWidth:_tblvActivityDetail.frame.size.width];
                
                //Set the delegate of the webview
                _activityDetailCell.webViewForContent.delegate = self;
                _activityDetailCell.webViewComment.delegate = self;
                break;
            }
            default: {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailMessageTableViewCell" owner:self options:nil];
                _activityDetailCell = (ActivityDetailMessageTableViewCell *)[nib objectAtIndex:0];
                //Create a cell, need to do some configurations
                [_activityDetailCell configureCell];
                
                //Set the delegate of the webview
                _activityDetailCell.webViewForContent.delegate = self;
                break;
            }
        }
        _activityDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _activityDetailCell.imgType.image = [UIImage imageNamed:_iconType];
        [_activityDetailCell setSocialActivityDetail:self.socialActivity];
        [_activityDetailCell retain];
    }
    
    return _activityDetailCell;
}

#pragma mark - Loader Management
- (void)updateHudPosition {
    //Default implementation
    //Nothing keep the default position of the HUD
}



#pragma mark - Data Management

- (void)updateActivityInActivityStream {
    [[NSNotificationCenter defaultCenter] postNotificationName:EXO_NOTIFICATION_ACTIVITY_UPDATED object:nil];
}



- (void)finishLoadingAllDataForActivityDetails {
    //Prevent any reloading status
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityDetail];
    
    //Prepare data to be displayed
    for (SocialComment* comment in self.socialActivity.comments) 
    {
        [comment convertToPostedTimeInWords];
        [comment convertHTMLEncoding];
    }
    
    
    //We have retreive new datas from API
    //Set the last update date at now 
    _dateOfLastUpdate = [[NSDate date] retain];
    
    //Hide the loader
    [self hideLoader:YES];
    
    
    [self updateActivityInActivityStream];
}

#pragma - Proxy Management
- (void)startLoadingActivityDetail
{
    _reloading = YES;
    SocialActivityDetailsProxy* socialActivityDetailsProxy = [[SocialActivityDetailsProxy alloc] initWithNumberOfComments:NUMBER_OF_COMMENT_TO_LOAD andNumberOfLikes:4];
    socialActivityDetailsProxy.delegate = self;
    [socialActivityDetailsProxy getActivityDetail:self.socialActivity.activityId];
    
}

- (void)setSocialActivityStream:(SocialActivity *)socialActivityStream andCurrentUserProfile:(SocialUserProfile *)currentUserProfile
{
    self.socialActivity = socialActivityStream;
    _activityAction = 0;
    [self startLoadingActivityDetail];
}


#pragma mark - Social Proxy Delegate

- (void)proxyDidFinishLoading:(SocialProxy *)proxy 
{
    if ([proxy isKindOfClass:[SocialActivityDetailsProxy class]]) {
        SocialActivity *socialActivityDetails = [(SocialActivityDetailsProxy*)proxy socialActivityDetails];
        self.socialActivity.likedByIdentities = socialActivityDetails.likedByIdentities;
        self.socialActivity.comments = socialActivityDetails.comments;
        self.socialActivity.totalNumberOfComments = socialActivityDetails.totalNumberOfComments;
        self.socialActivity.totalNumberOfLikes = socialActivityDetails.totalNumberOfLikes;
        
        [self.socialActivity convertToPostedTimeInWords];
        //Set the last update date at now 
        _dateOfLastUpdate = [[NSDate date]retain];
        
        [self finishLoadingAllDataForActivityDetails];
        //SocialLikeActivityProxy
    }else if ([proxy isKindOfClass:[SocialLikeActivityProxy class]]) {
        if (_activityAction == 2) {
            self.socialActivity.liked = YES;
            self.socialActivity.totalNumberOfLikes++;
        } else if (_activityAction == 3) {
            self.socialActivity.liked = NO;
            self.socialActivity.totalNumberOfLikes--;
        }
        [self didFinishedLikeAction];
        SocialActivityDetailsProxy* socialActivityDetailsProxy = [[SocialActivityDetailsProxy alloc] initWithNumberOfComments:NUMBER_OF_COMMENT_TO_LOAD 
                                                                                                             andNumberOfLikes:4];
        socialActivityDetailsProxy.delegate = self;
        [socialActivityDetailsProxy getActivityDetail:self.socialActivity.activityId];
    }
}

-(void)proxy:(SocialProxy *)proxy didFailWithError:(NSError *)error
{
    //    [error localizedDescription] 
    
    NSString *alertMessage = nil;
    if(_activityAction == 0)
        alertMessage = Localize(@"GettingActionCannotBeCompleted");
    else if(_activityAction == 1)
        alertMessage = Localize(@"UpdatingActionCannotBeCompleted");
    else {
        alertMessage = Localize(@"LikingActionCannotBeCompleted");
        [self didFailedLikeAction];
    }
    
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:Localize(@"Error") message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
     
    [alertView show];
}

#pragma mark - like/unlike management
- (void)didFailedLikeAction {}

- (void)didFinishedLikeAction {}

- (void)likeDislikeActivity:(NSString *)activity
{
    
    SocialLikeActivityProxy* likeDislikeActProxy = [[SocialLikeActivityProxy alloc] init];
    likeDislikeActProxy.delegate = self;
    
    if(self.socialActivity.liked)
    {
        _activityAction = 3;
        [likeDislikeActProxy dislikeActivity:activity];
    }
    else
    {
        _activityAction = 2;
        [likeDislikeActProxy likeActivity:activity];
    }
}

#pragma mark -
#pragma mark MessageComposer Methods
- (void)messageComposerDidSendData{
    isPostComment = YES;
    [self startLoadingActivityDetail];
}


#pragma mark - UIWebViewDelegate methods 
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView == self.activityDetailCell.webViewForContent || webView == self.activityDetailCell.webViewComment) {
        // update the webview to display all the content 
        CGRect frame = webView.frame;
        frame.size.height = 1;
        webView.frame = frame;
        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        frame.size.height += kPadding;
        webView.frame = frame;
        
        [self.activityDetailCell updateSizeToFitSubViews];
        [_tblvActivityDetail reloadData];
    }
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    _activityAction = 1;
    [self startLoadingActivityDetail];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return _dateOfLastUpdate; // should return date data source was last changed
	
}

#pragma mark - 
#pragma mark UIAlertViewDelegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Remove the loader
    
    [self hideLoader:NO];
    
    if(_activityAction == 1)
    {
        //Prevent any reloading status
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tblvActivityDetail];
    }
}






@end

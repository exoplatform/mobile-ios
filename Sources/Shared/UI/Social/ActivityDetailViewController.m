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
#import "ActivityDetailCommentTableViewCell.h"
#import "ActivityDetailMessageTableViewCell.h"
#import "ActivityCalendarDetailMessageTableViewCell.h"
#import "ActivityPictureDetailMessageTableViewCell.h"
#import "ActivityLinkDetailMessageTableViewCell.h"
#import "ActivityDetailLikeTableViewCell.h"
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
#import "EmptyView.h"


#define NUMBER_OF_COMMENT_TO_LOAD 30



@implementation ActivityDetailViewController

@synthesize iconType = _iconType;
@synthesize socialActivity = _socialActivity;

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
    
    [_cellForMessage release];
    [_cellForLikes release];

    
    [_txtvMsgComposer release];
    [_btnMsgComposer release];    
    
    [_refreshHeaderView release];
    [_dateOfLastUpdate release];
    
//    [tapGesture release];
//    [maskView release];
        
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


// Specific method to retrieve the height of the cell
// This method override the inherited one.
- (float)getHeighSizeForTableView:(UITableView *)tableView andText:(NSString*)text
{
    CGRect rectTableView = tableView.frame;
    float fWidth = 0;
    float fHeight = 0;
    
    if (rectTableView.size.width > 320) 
    {
        fWidth = rectTableView.size.width - 85; //fmargin = 85 will be defined as a constant.
    }
    else
    {
        fWidth = rectTableView.size.width - 100;
    }
    
    NSString* textWithoutHtml = [text stringByConvertingHTMLToPlainText];
    
    CGSize theSize = [textWithoutHtml sizeWithFont:kFontForMessage constrainedToSize:CGSizeMake(fWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    if (theSize.height < 30) 
    {
        fHeight = 100;
    }
    else
    {
        fHeight = 75 + theSize.height;
    }
    
    return fHeight;
}



#pragma mark - Table view Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    int n = 3;
    if ([self.socialActivity.likedByIdentities count] == 0) 
    {
        //n --;
    }
    if ([self.socialActivity.comments count] == 0) 
    {
        n--;
    }
    return n;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int n = 0;
    if (section == 0) 
    {
        n = 1;
    }
    if (section == 1) 
    {
        n = 1;
    }
    if (section == 2) 
    {
        n = [self.socialActivity.comments count];
    }
    return n;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    int n = 0;
    if (indexPath.section == 0) 
    {
        return self.socialActivity.cellHeight;
    }
    
    if (indexPath.section == 1) 
    {
        n = 55;
    }
    if (indexPath.section == 2) 
    {
        SocialComment* comment = [self.socialActivity.comments objectAtIndex:indexPath.row];
        n = [self getHeighSizeForTableView:tableView andText:comment.text];

    }
    return n;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *kIdentifierActivityDetailMessageTableViewCell = @"ActivityDetailMessageTableViewCell";
    static NSString *kIdentifierActivityPictureDetailMessageTableViewCell = @"ActivityPictureDetailMessageTableViewCell";
    static NSString *kIdentifierActivityForumDetailMessageTableViewCell = @"ActivityForumDetailMessageTableViewCell";
    static NSString *kIdentifierActivityWikiDetailMessageTableViewCell = @"ActivityWikiDetailMessageTableViewCell";
    static NSString *kIdentifierActivityAnswerDetailMessageTableViewCell = @"kIdentifierActivityAnswerDetailMessageTableViewCell";
    static NSString *kIdentifierActivityLinkDetailMessageTableViewCell = @"kIdentifierActivityLinkDetailMessageTableViewCell";
    static NSString *kIdentifierActivityCalendarDetailMessageTableViewCell = @"kIdentifierActivityCalendarDetailMessageTableViewCell";
    
    static NSString *kIdentifierActivityDetailLikeTableViewCell = @"ActivityDetailLikeTableViewCell";
    static NSString *kIdentifierActivityDetailCommentTableViewCell = @"ActivityDetailCommentTableViewCell";
    
	////Create a cell, need to do some Configurations
    //If section for messages
    if (indexPath.section == 0) 
    {
        ActivityDetailMessageTableViewCell* cell;
        switch (self.socialActivity.activityType) {
            case ACTIVITY_DOC:
            case ACTIVITY_CONTENTS_SPACE:{
                //Check if we found a cell
                cell = (ActivityPictureDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityPictureDetailMessageTableViewCell];
                if (cell == nil) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityPictureDetailMessageTableViewCell" owner:self options:nil];
                    cell = (ActivityPictureDetailMessageTableViewCell *)[nib objectAtIndex:0];
                    //Create a cell, need to do some configurations
                    [cell configureCell];
                    [cell configureCellForSpecificContentWithWidth:tableView.frame.size.width];
                    //Set the delegate of the webview
                    cell.webViewForContent.delegate = self;
                }
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContent:)];
                [cell.imgvAttach addGestureRecognizer:tapGesture];
                [tapGesture release];
            }
                break;
            case ACTIVITY_WIKI_ADD_PAGE:
            case ACTIVITY_WIKI_MODIFY_PAGE:
            {
                cell = (ActivityWikiDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityWikiDetailMessageTableViewCell];
                //Check if we found a cell
                if (cell == nil) 
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityWikiDetailMessageTableViewCell" owner:self options:nil];
                    cell = (ActivityWikiDetailMessageTableViewCell *)[nib objectAtIndex:0];
                    //Create a cell, need to do some configurations
                    [cell configureCell];
                    [cell configureCellForSpecificContentWithWidth:tableView.frame.size.width];
                    //Set the delegate of the webview
                    cell.webViewForContent.delegate = self;
                }

            }
                break;
            case ACTIVITY_FORUM_CREATE_POST: 
            case ACTIVITY_FORUM_CREATE_TOPIC:
            case ACTIVITY_FORUM_UPDATE_POST:
            case ACTIVITY_FORUM_UPDATE_TOPIC:{
                cell = (ActivityForumDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityForumDetailMessageTableViewCell];
                //Check if we found a cell
                if (cell == nil) 
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityForumDetailMessageTableViewCell" owner:self options:nil];
                    cell = (ActivityForumDetailMessageTableViewCell *)[nib objectAtIndex:0];
                    //Create a cell, need to do some configurations
                    [cell configureCell];
                    [cell configureCellForSpecificContentWithWidth:tableView.frame.size.width];
                    //Set the delegate of the webview
                    cell.webViewForContent.delegate = self;
                }
                
            }
                break;
            case ACTIVITY_CALENDAR_UPDATE_TASK: 
            case ACTIVITY_CALENDAR_ADD_TASK:
            case ACTIVITY_CALENDAR_UPDATE_EVENT:
            case ACTIVITY_CALENDAR_ADD_EVENT:{
                cell = (ActivityCalendarDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityCalendarDetailMessageTableViewCell];
                //Check if we found a cell
                if (cell == nil) 
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityCalendarDetailMessageTableViewCell" owner:self options:nil];
                    cell = (ActivityCalendarDetailMessageTableViewCell *)[nib objectAtIndex:0];
                    //Create a cell, need to do some configurations
                    [cell configureCell];
                    [cell configureCellForSpecificContentWithWidth:tableView.frame.size.width];
                    //Set the delegate of the webview
                    cell.webViewForContent.delegate = self;
                }
            }
                break; 
            case ACTIVITY_ANSWER_QUESTION:
            case ACTIVITY_ANSWER_ADD_QUESTION:
            case ACTIVITY_ANSWER_UPDATE_QUESTION:{
                cell = (ActivityAnswerDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityAnswerDetailMessageTableViewCell];
                //Check if we found a cell
                if (cell == nil) 
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityAnswerDetailMessageTableViewCell" owner:self options:nil];
                    cell = (ActivityAnswerDetailMessageTableViewCell *)[nib objectAtIndex:0];
                    //Create a cell, need to do some configurations
                    [cell configureCell];
                    [cell configureCellForSpecificContentWithWidth:tableView.frame.size.width];
                    //Set the delegate of the webview
                    cell.webViewForContent.delegate = self;
                }
            }
                break;
            case ACTIVITY_LINK:{
                cell = (ActivityLinkDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityLinkDetailMessageTableViewCell];
                //Check if we found a cell
                if (cell == nil) 
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityLinkDetailMessageTableViewCell" owner:self options:nil];
                    cell = (ActivityLinkDetailMessageTableViewCell *)[nib objectAtIndex:0];
                    //Create a cell, need to do some configurations
                    [cell configureCell];
                    [cell configureCellForSpecificContentWithWidth:tableView.frame.size.width];
                    
                    //Set the delegate of the webview
                    cell.webViewForContent.delegate = self;
                    cell.webViewComment.delegate = self;
                }
            }
                break;
            default:{
                cell = (ActivityDetailMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailMessageTableViewCell];
                //Check if we found a cell
                if (cell == nil) 
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailMessageTableViewCell" owner:self options:nil];
                    cell = (ActivityDetailMessageTableViewCell *)[nib objectAtIndex:0];
                    //Create a cell, need to do some configurations
                    [cell configureCell];
                    
                    //Set the delegate of the webview
                    cell.webViewForContent.delegate = self;
                }
            }
                break;
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imgType.image = [UIImage imageNamed:_iconType];
        [cell setSocialActivityDetail:self.socialActivity];
        return cell;
    }
    else if (indexPath.section == 1) 
    {
        ActivityDetailLikeTableViewCell* cell = (ActivityDetailLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailLikeTableViewCell];
        
        //Check if we found a cell
        
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailLikeTableViewCell" owner:self options:nil];
            cell = (ActivityDetailLikeTableViewCell *)[nib objectAtIndex:0];    
            //Create a cell, need to do some configurations
            [cell configureCell];
        }
    
        cell.delegate = self;
        [cell setContent:@""];
        
        NSString *strLike;
        NSMutableArray *arrLikes = [[NSMutableArray alloc] initWithCapacity:[self.socialActivity.likedByIdentities count]];
        _currentUserLikeThisActivity = NO;
        
        if ([self.socialActivity.likedByIdentities count] > 0)
        { 
            for (int i = 0; i < [self.socialActivity.likedByIdentities count]; i++) 
            {
                SocialUserProfile *userProfile = (SocialUserProfile*) [self.socialActivity.likedByIdentities objectAtIndex:i];
                     
                NSString *username = userProfile.fullName;
                
                if ([self.socialActivity.posterIdentity.identity isEqualToString:userProfile.identity]) {
                    _currentUserLikeThisActivity = YES;
                    continue;
                }
                [arrLikes addObject:[NSString stringWithFormat:@" %@", [username retain]]];
            }

            if (_currentUserLikeThisActivity) {
                [arrLikes insertObject:Localize(@"You") atIndex:0];
            }
            
            //rearrange like
            int n = [arrLikes count];
            NSMutableArray *arrCopy = [[NSMutableArray alloc] init];
            if(n == 2){
                strLike = [NSString stringWithFormat:@"%@ %@%@",[[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], Localize(@"and"),[arrLikes objectAtIndex:1]];
            } else if(n == 3){
                if(_currentUserLikeThisActivity){
                    strLike = [NSString stringWithFormat:@"%@,%@ %@%@", [[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               [arrLikes objectAtIndex:1], Localize(@"and"), [arrLikes objectAtIndex:2]];
                } else {
                    strLike = [NSString stringWithFormat:@"%@,%@,%@", [[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                               [arrLikes objectAtIndex:1], [arrLikes objectAtIndex:2]];
                }

            } else if(n >= 4){
                [arrCopy addObject:[[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                [arrCopy addObject:[arrLikes objectAtIndex:1]];
                [arrCopy addObject:[arrLikes objectAtIndex:2]];
                
                strLike = [arrCopy componentsJoinedByString:@","];
                strLike = [strLike stringByAppendingString:[NSString stringWithFormat:@" %@ %d %@", Localize(@"and"), n-3, Localize(@"more")]];
            } else if (n == 1){
                strLike = [NSString stringWithFormat:@"%@",[[arrLikes objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            }
            if(n == 1 && !_currentUserLikeThisActivity)
                strLike = [strLike stringByAppendingString:[NSString stringWithFormat:@" %@", Localize(@"likesThisActivity")]];
            else 
                strLike = [strLike stringByAppendingString:[NSString stringWithFormat:@" %@", Localize(@"likeThisActivity")]];
            [arrCopy release];
        }
        else
        {
            strLike = Localize(@"NoLikeForTheMoment");
        }
        [arrLikes release];
        //NSLog(@"%@", strLike);
        [cell setUserProfile:self.socialActivity.posterIdentity];
        [cell setContent:strLike];
        [cell setUserLikeThisActivity:_currentUserLikeThisActivity];
        [cell setSocialActivityDetails:self.socialActivity];
        
        return cell;
    }
    else
    {
        ActivityDetailCommentTableViewCell* cell = (ActivityDetailCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kIdentifierActivityDetailCommentTableViewCell];
    
        //Check if we found a cell
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActivityDetailCommentTableViewCell" owner:self options:nil];
            cell = (ActivityDetailCommentTableViewCell *)[nib objectAtIndex:0];
            
            //Create a cell, need to do some configurations
            [cell configureCell];
            cell.width = tableView.frame.size.width;
            cell.webViewForContent.delegate = self;
        }
        
        SocialComment* socialComment = [self.socialActivity.comments objectAtIndex:indexPath.row];
        [cell setSocialComment:socialComment];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// Empty State
-(void)emptyState {
    //add empty view to the view 
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForNoActivities.png" andContent:Localize(@"NoComment")];
    emptyView.tag = TAG_EMPTY;
    [self.view insertSubview:emptyView belowSubview:self.hudLoadWaiting.view];
    [emptyView release];
}

//
-(void)showContent:(UITapGestureRecognizer *)tapGesture{
    //NSLog(@"test");
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
    EmptyView *emptyview = (EmptyView *)[_tblvActivityDetail viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview removeFromSuperview];
    }
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
    
    [_tblvActivityDetail reloadData];
    
    //if comment tableview scroll at bottom
    if(isPostComment){
        if([self.socialActivity.comments count] > 0){
            [_tblvActivityDetail scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.socialActivity.comments count] - 1 inSection:2] 
                                       atScrollPosition:UITableViewScrollPositionBottom 
                                               animated:YES];
        }
        isPostComment = NO;
    }
    if([self.socialActivity.comments count] == 0){
        CGRect rect = CGRectZero;
        float height = 0.0;
        UITableViewCell *cell = [_tblvActivityDetail cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        height += cell.frame.size.height;
        height += 55;
        
        rect.size.width = _tblvActivityDetail.frame.size.width;
        rect.origin.y = height;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            rect.size.height = 400;
        } else {
            rect.size.height = 200;
        }
        _tblvActivityDetail.contentSize = CGSizeMake(_tblvActivityDetail.frame.size.width, rect.size.height + rect.origin.y);
        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:rect withImageName:@"IconForNoActivities.png" andContent:Localize(@"NoComment")];
        emptyView.tag = TAG_EMPTY;
        [_tblvActivityDetail insertSubview:emptyView belowSubview:self.hudLoadWaiting.view];
        [emptyView release];
        
    }
    
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
    //[self.view insertSubview:maskView belowSubview:_hudActivityDetails.view];
    self.socialActivity = socialActivityStream;
    _activityAction = 0;
    NSLog(@"Tempalte Params:%@ \n Body:%@\nType:%@", self.socialActivity.body, [self.socialActivity.templateParams description],self.socialActivity.type);
    [self startLoadingActivityDetail];
}


#pragma mark - Social Proxy Delegate

- (void)proxyDidFinishLoading:(SocialProxy *)proxy 
{
    if ([proxy isKindOfClass:[SocialActivityDetailsProxy class]]) {
        
        SocialActivity *socialActivityDetails = [(SocialActivityDetailsProxy*)proxy socialActivityDetails];
        self.socialActivity.likedByIdentities = socialActivityDetails.likedByIdentities;
        self.socialActivity.comments = socialActivityDetails.comments;
        
        [self.socialActivity convertToPostedTimeInWords];
        [self.socialActivity cellHeightCalculationForWidth:_tblvActivityDetail.frame.size.width];
        //Set the last update date at now 
        _dateOfLastUpdate = [[NSDate date]retain];
        
        [self finishLoadingAllDataForActivityDetails];
        //SocialLikeActivityProxy
    }else{
        if (_activityAction == 2){
            self.socialActivity.liked = YES;
        } else if (_activityAction == 3){
            self.socialActivity.liked = NO;
        }
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
    else
        alertMessage = Localize(@"LikingActionCannotBeCompleted");
    
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:Localize(@"Error") message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
     
    [alertView show];
}

- (void)likeDislikeActivity:(NSString *)activity
{
    
    [self displayHudLoader];
    SocialLikeActivityProxy* likeDislikeActProxy = [[SocialLikeActivityProxy alloc] init];
    likeDislikeActProxy.delegate = self;
    
    if(_currentUserLikeThisActivity)
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


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

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

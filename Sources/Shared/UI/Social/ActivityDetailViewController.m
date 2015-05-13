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

@interface ActivityDetailViewController ()

@property (nonatomic, retain) SocialActivityDetailsProxy *getCommentsProxy;
@property (nonatomic, retain) SocialActivityDetailsProxy *getLikersProxy;
@property (nonatomic, retain) SocialLikeActivityProxy *likeActivityProxy;
@property (nonatomic, retain) NSDate *dateOfLastUpdate;

@end

@implementation ActivityDetailViewController

@synthesize iconType = _iconType;
@synthesize socialActivity = _socialActivity;
@synthesize activityDetailCell = _activityDetailCell;
@synthesize tblvActivityDetail = _tblvActivityDetail;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize getCommentsProxy = _getCommentsProxy;
@synthesize getLikersProxy = _getLikersProxy;
@synthesize likeActivityProxy = _likeActivityProxy;
@synthesize dateOfLastUpdate = _dateOfLastUpdate;

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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
    [_getCommentsProxy release];
    [_getLikersProxy release];
    [_likeActivityProxy release];
    
    _tblvActivityDetail.delegate = nil;
    _tblvActivityDetail.dataSource = nil;
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
    self.dateOfLastUpdate = [NSDate date];
    
	[self.view addSubview:self.hudLoadWaiting.view];
    
    //Set the title of the screen
    //TODO Localize
    self.title = Localize(@"Details");
    
    
    //Set the background Color of the view    
    //_tblvActivityDetail.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    _tblvActivityDetail.backgroundColor = EXO_BACKGROUND_COLOR;
    
    //Add the pull to refresh header
    if (self.refreshHeaderView == nil) {
		
		self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tblvActivityDetail.bounds.size.height, self.view.frame.size.width, _tblvActivityDetail.bounds.size.height)] autorelease];
		self.refreshHeaderView.delegate = self;
		[_tblvActivityDetail addSubview:self.refreshHeaderView];
        _reloading = FALSE;
        
	}
    // Observe the change language notif to update the labels
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLabelsWithNewLanguage) name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
    
    [self.tblvActivityDetail registerNib: [UINib nibWithNibName:@"ActivityPictureDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityPictureDetailMessageTableViewCell"];
    [self.tblvActivityDetail registerNib: [UINib nibWithNibName:@"ActivityDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityDetailMessageTableViewCell"];
    [self.tblvActivityDetail registerNib: [UINib nibWithNibName:@"ActivityLinkDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityLinkDetailMessageTableViewCell"];
    [self.tblvActivityDetail registerNib: [UINib nibWithNibName:@"ActivityWikiDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityWikiDetailMessageTableViewCell"];
    [self.tblvActivityDetail registerNib: [UINib nibWithNibName:@"ActivityForumDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityForumDetailMessageTableViewCell"];
    [self.tblvActivityDetail registerNib: [UINib nibWithNibName:@"ActivityAnswerDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityAnswerDetailMessageTableViewCell"];
    [self.tblvActivityDetail registerNib: [UINib nibWithNibName:@"ActivityCalendarDetailMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActivityCalendarDetailMessageTableViewCell"];

//ActivityAnswerDetailMessageTableViewCell
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
        return [self.activityDetailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1;
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
                
                NSString * identCell = @"ActivityPictureDetailMessageTableViewCell" ;
                _activityDetailCell = [self.tblvActivityDetail dequeueReusableCellWithIdentifier:identCell];

                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContent:)];
                [_activityDetailCell.imgvAttach addGestureRecognizer:tapGesture];
                [tapGesture release];
            
                break;
            }
            case ACTIVITY_WIKI_ADD_PAGE:
            case ACTIVITY_WIKI_MODIFY_PAGE: {
                NSString * identCell = @"ActivityWikiDetailMessageTableViewCell" ;
                _activityDetailCell = [self.tblvActivityDetail dequeueReusableCellWithIdentifier:identCell];
                break;
            }
            case ACTIVITY_FORUM_CREATE_POST: 
            case ACTIVITY_FORUM_CREATE_TOPIC:
            case ACTIVITY_FORUM_UPDATE_POST:
            case ACTIVITY_FORUM_UPDATE_TOPIC: {
                NSString * identCell = @"ActivityForumDetailMessageTableViewCell" ;
                _activityDetailCell = [self.tblvActivityDetail dequeueReusableCellWithIdentifier:identCell];
                break;
            }
            case ACTIVITY_CALENDAR_UPDATE_TASK: 
            case ACTIVITY_CALENDAR_ADD_TASK:
            case ACTIVITY_CALENDAR_UPDATE_EVENT:
            case ACTIVITY_CALENDAR_ADD_EVENT: {
                NSString * identCell = @"ActivityCalendarDetailMessageTableViewCell" ;
                _activityDetailCell = [self.tblvActivityDetail dequeueReusableCellWithIdentifier:identCell];
                break; 
            }
            case ACTIVITY_ANSWER_QUESTION:
            case ACTIVITY_ANSWER_ADD_QUESTION:
            case ACTIVITY_ANSWER_UPDATE_QUESTION: {
                NSString * identCell = @"ActivityAnswerDetailMessageTableViewCell" ;
                _activityDetailCell = [self.tblvActivityDetail dequeueReusableCellWithIdentifier:identCell];
                break;
            }
            case ACTIVITY_LINK: {
                NSString * identCell = @"ActivityLinkDetailMessageTableViewCell" ;
                _activityDetailCell = [self.tblvActivityDetail dequeueReusableCellWithIdentifier:identCell];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContent:)];
                [_activityDetailCell addGestureRecognizer:tapGesture];
                [tapGesture release];

                break;
            }
            default: {
                NSString * identCell = @"ActivityDetailMessageTableViewCell" ;
                _activityDetailCell = [self.tblvActivityDetail dequeueReusableCellWithIdentifier:identCell];        
                break;
            }
        }
        _activityDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _activityDetailCell.imgType.image = [UIImage imageNamed:_iconType];
        [_activityDetailCell setSocialActivityDetail:self.socialActivity];
        [_activityDetailCell setNeedsLayout];
        [_activityDetailCell layoutIfNeeded];
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

- (void)finishLoadingAllComments {
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
    self.dateOfLastUpdate = [NSDate date];
        
    [self updateActivityInActivityStream];
}

- (void)finishLoadingAllLikers {
    
}

#pragma - Proxy Management
- (void)startLoadingActivityDetail
{
    _reloading = YES;
    self.getCommentsProxy = [[[SocialActivityDetailsProxy alloc] initWithNumberOfComments:0 andNumberOfLikes:0] autorelease];
    self.getCommentsProxy.delegate = self;
    [self.getCommentsProxy getAllOfComments:self.socialActivity.activityId];
    // Refresh list of likers 
    self.getLikersProxy = [[[SocialActivityDetailsProxy alloc] initWithNumberOfComments:0 andNumberOfLikes:0] autorelease];
    self.getLikersProxy.delegate = self;
    [self.getLikersProxy getLikers:self.socialActivity.activityId];
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
    if (proxy == self.getCommentsProxy) {
        SocialActivity *socialActivityDetails = [(SocialActivityDetailsProxy*)proxy socialActivityDetails];
        self.socialActivity.comments = socialActivityDetails.comments;
        self.socialActivity.totalNumberOfComments = socialActivityDetails.totalNumberOfComments;
        self.getCommentsProxy = nil;
        [self.socialActivity convertToPostedTimeInWords];
        [self.socialActivity convertToUpdatedTimeInWords];
        //Set the last update date at now 
        self.dateOfLastUpdate = [NSDate date];
        
        [self finishLoadingAllComments];
        //SocialLikeActivityProxy
    }else if (proxy == self.likeActivityProxy) {
        if (_activityAction == 2) {
            self.socialActivity.liked = YES;
            self.socialActivity.totalNumberOfLikes++;
            NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.socialActivity.likedByIdentities];
            [newArray addObject:self.socialActivity.posterIdentity];
        } else if (_activityAction == 3) {
            self.socialActivity.liked = NO;
            self.socialActivity.totalNumberOfLikes--;
        }
        [self didFinishedLikeAction];
        self.likeActivityProxy = nil;
        // Refresh list of likers 
        self.getLikersProxy = [[[SocialActivityDetailsProxy alloc] initWithNumberOfComments:0 andNumberOfLikes:0] autorelease];
        self.getLikersProxy.delegate = self;
        [self.getLikersProxy getLikers:self.socialActivity.activityId];
    } else if (proxy == self.getLikersProxy) {
        self.socialActivity.totalNumberOfLikes = self.getLikersProxy.socialActivityDetails.totalNumberOfLikes;
        self.socialActivity.likedByIdentities = self.getLikersProxy.socialActivityDetails.likedByIdentities;
        [self finishLoadingAllLikers];
        self.getLikersProxy = nil;
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
    
    self.likeActivityProxy = [[[SocialLikeActivityProxy alloc] init] autorelease];
    self.likeActivityProxy.delegate = self;
    
    if(self.socialActivity.liked)
    {
        _activityAction = 3;
        [self.likeActivityProxy dislikeActivity:activity];
    }
    else
    {
        _activityAction = 2;
        [self.likeActivityProxy likeActivity:activity];
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

#pragma mark - UIAlertViewDelegate method

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

#pragma mark - change language management

- (void)updateLabelsWithNewLanguage{
    [super updateLabelsWithNewLanguage];
    // Update the labels of the activity
    [self.activityDetailCell updateLabelsWithNewLanguage];
    [self.view setNeedsDisplay];
}




@end
